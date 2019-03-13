require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :compile do
  sh 'racc lib/typed_ruby/parsers/signatures_parser.y -o lib/typed_ruby/parsers/signatures_parser.rb --debug' # -O .racc_output'
end

task :default => :spec
