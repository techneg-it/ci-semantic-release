# frozen_string_literal: true

describe command('apt-get update') do
  its('exit_status') { should eq 0 }
end

describe command('apt-get --dry-run upgrade') do
  its('exit_status') { should eq 0 }
  its('stdout') { should_not match(/^Inst /) }
end
