# frozen_string_literal: true

describe file('/usr/local/bin/semantic-release') do
  it { should exist }
end

describe command('semantic-release --version') do
  its('exit_status') { should eq 0 }
  its(:stderr) { should be_empty }
  its(:stdout) { should match input('SEM_REL_VERSION') }
end

describe command('semantic-release') do
  its('exit_status') { should eq 0 }
  its(:stderr) { should be_empty }
  its(:stdout) { should match(/Running semantic-release/) }
  its(:stdout) { should match(/Analysis of 1 commits complete: minor release/) }
  its(:stdout) { should match(/Found 1 file\(s\) to commit/) }
  its(:stdout) { should match(/Published release 1.0.0 on default channel/) }
end
