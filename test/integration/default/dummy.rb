# frozen_string_literal: true

describe file('/.dockerenv') do
  it { should exist }
end
