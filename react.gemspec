# -*- ruby -*-
$:.unshift(File.expand_path('../lib', __FILE__))
require 'react/version'

Gem::Specification.new do |s|
  s.name               = 'authtools'
  s.version            = React.version
  s.homepage           = 'http://github.com/nu7hatch/react'
  s.email              = ['chris@nu7hat.ch']
  s.authors            = ['Chris Kowalik']
  s.summary            = %q{Redis based remote commands executor.}
  s.description        = %q{A simple application that allows for remote execution of commands.}
  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test}/*`.split("\n")
  s.require_paths      = %w[lib]
  s.extra_rdoc_files   = %w[README.rdoc]
  s.executables        = %w[react]
  s.default_executable = 'react'
  
  s.add_runtime_dependency 'daemons',  ["~> 1.0"]
  s.add_runtime_dependency 'redis',    [">= 2.0"]
  s.add_runtime_dependency 'optitron', [">= 2.1"]
end
