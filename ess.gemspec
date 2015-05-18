# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "aliyun/ess/version"

Gem::Specification.new do |s|
  s.name          = "aliyun-ess"
  s.version       = Aliyun::ESS::Version
  s.authors       = ["Joshua Li"]
  s.email         = ["sunrisela@gmail.com"]
  s.homepage      = "https://github.com/sunrisela"
  s.summary       = "Aliyun::ESS is a Ruby library for Aliyun's Elastic Scaling Service API (http://www.aliyun.com/product/ess)"
  s.description   = "Full documentation of the currently supported API can be found at http://www.aliyun.com/product/ess#resources."
  #s.homepage      = ""
  s.license       = "MIT"

  s.files         = Dir["{bin,lib}/**/*", "CHANGELOG", "Gemfile", "INSTALL", "LICENSE.txt", "Rakefile", "README.md"]
  s.executables  << "ess"
  s.test_files    = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_dependency "yajl-ruby", "~> 1.0"
  s.add_dependency "rack", "~> 1.4"
end
