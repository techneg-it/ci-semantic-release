FROM alpine:latest@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS go-builder

ARG TARGETARCH
# renovate: datasource=golang-version depName=go
ARG GO_VERSION=1.26.2
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

FROM node:24-bookworm-slim@sha256:06e5c9f86bfa0aaa7163cf37a5eaa8805f16b9acb48e3f85645b09d459fc2a9f AS install

SHELL ["/bin/bash", "-x", "-o", "pipefail", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

# renovate: datasource=npm depName=semantic-release
ARG SEM_REL_VERSION=25.0.3
# renovate: datasource=npm depName=@semantic-release/changelog
ARG SR_CHLG_VERSION=6.0.3
# renovate: datasource=npm depName=@semantic-release/exec
ARG SR_EXEC_VERSION=7.1.0
# renovate: datasource=npm depName=@semantic-release/git
ARG SR_GIT_VERSION=10.0.1
# renovate: datasource=npm depName=conventional-changelog-conventionalcommits
ARG CC_CONV_COMMITS_VERSION=9.3.1

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
