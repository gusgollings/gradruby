# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'Run RSpec'
RSpec::Core::RakeTask.new(:spec)

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop)

desc 'Default: Run RSpec and RuboCop'
task default: %i[spec rubocop]
