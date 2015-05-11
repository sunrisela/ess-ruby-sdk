# -*- encoding : utf-8 -*-
#!/usr/bin/env ruby
if ENV['ACCESS_KEY_ID'] && ENV['SECRET_ACCESS_KEY']
  Aliyun::ESS::Base.establish_connection!(
    :access_key_id     => ENV['ACCESS_KEY_ID'], 
    :secret_access_key => ENV['SECRET_ACCESS_KEY']
  )
end

#require File.dirname(__FILE__) + '/../test/fixtures'
include Aliyun::ESS
