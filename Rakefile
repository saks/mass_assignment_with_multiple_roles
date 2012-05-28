#!/usr/bin/env rake
require "bundler/gem_tasks"

dir = File.dirname(__FILE__)

require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = Dir.glob("#{dir}/test/cases/**/*_test.rb").sort
  t.warning = true
end

namespace :test do
  task :isolated do
    ruby = File.join(*RbConfig::CONFIG.values_at('bindir', 'RUBY_INSTALL_NAME'))
    Dir.glob("#{dir}/test/**/*_test.rb").all? do |file|
      sh(ruby, '-w', "-I#{dir}/lib", "-I#{dir}/test", file)
    end or raise "Failures"
  end
end
