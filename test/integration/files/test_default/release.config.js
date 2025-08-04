module.exports = {
  ci: false,
  repositoryUrl: '.',
  plugins: [
    ['@semantic-release/commit-analyzer'],
    ['@semantic-release/changelog', {
      changelogFile: 'CHANGELOG.md',
      changelogTitle: '# Changelog'
    }],
    ['@semantic-release/exec', {
      prepareCmd: 'true'
    }],
    ['@semantic-release/git', {
      assets: ['*.md']
    }]
  ]
}
