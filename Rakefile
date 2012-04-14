#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'
require 'rake/clean'

NAME="ruinput"
MAKEFILES = Dir.glob "ext/**/Makefile"

## dir
directory "lib/#{NAME}"

## so file
file "lib/#{NAME}/#{NAME}.so" =>
  (Dir.glob("ext/#{NAME}/*.{rb,c}") << "lib/#{NAME}")do

  Dir.chdir "ext/#{NAME}" do
    ruby "extconf.rb"
    sh "make"
  end

  cp "ext/#{NAME}/#{NAME}.so", "lib/#{NAME}"

end

## make_clean
desc "do `make clean` with all Makefiles"
task :make_clean do
  MAKEFILES.each do |file|
    dir = File.dirname file
    puts "cd #{dir}"
    Dir.chdir dir do
      sh "make clean"
    end
  end
end

## clobber
CLOBBER.include "lib/**/*.so"

### clean
CLEAN.include MAKEFILES
task :clean => :make_clean

## test
desc "Run tests"
task :test => "lib/#{NAME}/#{NAME}.so"
Rake::TestTask.new :test do |t|
  t.verbose = true
end

## default
task :default => :test
