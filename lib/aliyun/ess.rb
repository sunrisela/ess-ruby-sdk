# -*- encoding : utf-8 -*-
require 'cgi'
require 'uri'
require 'openssl'
require 'digest/sha1'
require 'net/https'
require 'time'
require 'date'
require 'open-uri'
require 'yajl/json_gem'
require 'rack/utils'
require 'byebug'

$:.unshift(File.dirname(__FILE__))

require 'ess/version'
require 'ess/extensions'
require 'ess/exceptions'
require 'ess/error'
require 'ess/authentication'
require 'ess/connection'
require 'ess/parsing'
require 'ess/base'
require 'ess/service'
require 'ess/collection'
require 'ess/scaling_group'
require 'ess/scaling_rule'
require 'ess/scaling_instance'
require 'ess/response'


Aliyun::ESS::Base.class_eval do
  include Aliyun::ESS::Connection::Management
end