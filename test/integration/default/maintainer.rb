# frozen_string_literal: true

describe file('/usr/local/bin/maintainer') do
  it { should exist }
end

describe command('maintainer --help') do
  its('exit_status') { should eq 0 }
  its(:stderr) { should be_empty }
end
