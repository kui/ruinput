#-*- coding:utf-8-unix; mode:ruby; -*-

require File.expand_path('../lib/ruinput/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Keiichiro Ui"]
  gem.email         = ["keiichiro.ui@gmail.com"]
  gem.description   = "a ruby binding for uinput.h"
  gem.summary       = "ruinput is a ruby binding for uinput.h."
  gem.homepage      = "https://rubygems.org/gems/ruinput"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ruinput"
  gem.require_paths = ["lib"]
  gem.version       = Ruinput::VERSION

  gem.add_dependency 'revdev', '>= 0.1.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler'
end
