# -*- encoding : utf-8 -*-
module Aliyun
  module ESS
    # The service lets you find out general information about your account, like what buckets you have. 
    # 
    class Service < Base
      @@response = nil #:nodoc:
      
      class << self
        # Sometimes methods that make requests to the OSS servers return some object, like a Bucket or an OSSObject. 
        # Other times they return just <tt>true</tt>. Other times they raise an exception that you may want to rescue. Despite all these 
        # possible outcomes, every method that makes a request stores its response object for you in Service.response. You can always 
        # get to the last request's response via Service.response.
        # 
        #   objects = Bucket.objects('jukebox')
        #   Service.response.success?
        #   # => true
        #
        # This is also useful when an error exception is raised in the console which you weren't expecting. You can 
        # root around in the response to get more details of what might have gone wrong.
        def response
          @@response
        end
        
        def response=(response) #:nodoc:
          @@response = response
        end
      end
    end
  end
end
