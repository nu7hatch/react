# -*- ruby -*-
$:.unshift(File.expand_path('../lib', __FILE__))
require 'react/version'
require 'rake/testtask'
require 'rake/rdoctask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue
  puts "Rcov is not available!"
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "React #{React.version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :spec

desc "Build current version as a rubygem"
task :build do
  `gem build react.gemspec`
  `mv react-*.gem pkg/`
end

desc "Relase current version to rubygems.org"
task :release => :build do
  `git tag -am "Version bump to #{React.version}" v#{React.version}`
  `git push origin master`
  `git push origin master --tags`
  `gem push pkg/react-#{React.version}.gem`
end
