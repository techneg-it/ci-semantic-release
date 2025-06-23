# frozen_string_literal: true

describe file('/usr/local/bin/semantic-release') do
  it { should exist }
end

describe command('semantic-release --version') do
  its('exit_status') { should eq 0 }
  its(:stderr) { should be_empty }
  its(:stdout) { should match input('SEM_REL_VERSION') }
end

describe command('semantic-release --dry-run') do
  its('exit_status') { should eq 0 }
  its(:stderr) { should be_empty }
  its(:stdout) { should match(/Running semantic-release/) }
end
