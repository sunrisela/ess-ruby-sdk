# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "ess/version"

Gem::Specification.new do |s|
  s.name        = "aliyun-ess"
  s.version     = Aliyun::ESS::Version
  s.authors     = ["Joshua Li"]
  s.email       = ["sunrisela@gmail.com"]
  s.homepage    = "https://github.com/sunrisela"
  s.summary     = "Aliyun::ESS is a Ruby library for Aliyun's Elastic Scaling Service API (http://www.aliyun.com/product/ess)"
  s.description = "Full documentation of the currently supported API can be found at http://www.aliyun.com/product/ess#resources."

  s.files = Dir["{bin,lib}/**/*", "COPYING", "README", "INSTALL", "CHANGELOG"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "yajl-ruby"
  s.add_dependency "rack", "~> 1.4"
end
