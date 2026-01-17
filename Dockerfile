FROM alpine:latest@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62 AS go-builder

ARG TARGETARCH
# renovate: datasource=golang-version depName=go
ARG GO_VERSION=1.25.6
ARG MNTN_VERSION=cd0c04e4d4168e5d13a26602e9c07f51e47a34b3

RUN : \
    && apk add --no-cache wget ca-certificates \
    && wget -O /go.tar.gz https://go.dev/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz \
    && tar -C /usr/local -xzf /go.tar.gz \
    && :
ENV PATH="$PATH:/usr/local/go/bin"

RUN : \
    && go env -w GOBIN=/ \
    && go install github.com/maintainer-org/maintainer@${MNTN_VERSION} \
    && :

FROM node:24-bookworm-slim@sha256:bf22df20270b654c4e9da59d8d4a3516cce6ba2852e159b27288d645b7a7eedc AS install

SHELL ["/bin/bash", "-x", "-o", "pipefail", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

# renovate: datasource=npm depName=semantic-release
ARG SEM_REL_VERSION=25.0.2
# renovate: datasource=npm depName=@semantic-release/changelog
ARG SR_CHLG_VERSION=6.0.3
# renovate: datasource=npm depName=@semantic-release/exec
ARG SR_EXEC_VERSION=7.1.0
# renovate: datasource=npm depName=@semantic-release/git
ARG SR_GIT_VERSION=10.0.1
# renovate: datasource=npm depName=conventional-changelog-conventionalcommits
ARG CC_CONV_COMMITS_VERSION=9.1.0

RUN : \
    && npm install -g semantic-release@${SEM_REL_VERSION} \
         @semantic-release/changelog@${SR_CHLG_VERSION} \
         @semantic-release/exec@${SR_EXEC_VERSION} \
         @semantic-release/git@${SR_GIT_VERSION} \
         conventional-changelog-conventionalcommits@${CC_CONV_COMMITS_VERSION} \
    && :

COPY --from=go-builder /maintainer /usr/local/bin

FROM install AS update

SHELL ["/bin/bash", "-x", "-o", "pipefail", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

RUN : \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
         ca-certificates \
         git \
         m2r \
    && git config --system user.name "Null" \
    && git config --system user.email "null@example.com" \
    && :

RUN : \
    && apt-get update \
    && apt-get upgrade --yes \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :
