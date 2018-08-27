require 'bundler/setup'
require 'typed_ruby'
require 'rspec/its'
require 'pry'

ROOT = File.expand_path('../..', __FILE__)
$: << ROOT

Dir['spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
