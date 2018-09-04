require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :compile do
  sh 'racc -o lib/typed_ruby/ast/signatures_parser.rb -O .racc_output lib/typed_ruby/ast/signatures_parser.y'
end

task :default => :spec
