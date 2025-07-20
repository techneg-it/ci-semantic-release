# frozen_string_literal: true

describe file('AUTHORS.md') do
  it { should exist }
end

describe command('m2r --help') do
  its('exit_status') { should eq 0 }
  its(:stderr) { should be_empty }
end

describe command('m2r AUTHORS.md') do
  its('exit_status') { should eq 0 }
  its(:stderr) { should be_empty }
end

describe file('AUTHORS.rst') do
  it { should exist }
  its('content') { should include '@myii <https://github.com/myii>' }
end
