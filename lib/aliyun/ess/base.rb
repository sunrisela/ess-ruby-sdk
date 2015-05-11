# -*- encoding : utf-8 -*-
module Aliyun
  module ESS
    DEFAULT_HOST = 'ess.aliyuncs.com'
    class Base
      class << self
        # Wraps the current connection's request method and picks the appropriate response class to wrap the response in.
        # If the response is an error, it will raise that error as an exception. All such exceptions can be caught by rescuing
        # their superclass, the ResponseError exception class.
        #
        # It is unlikely that you would call this method directly. Subclasses of Base have convenience methods for each http request verb
        # that wrap calls to request.
        def request(verb, path, params = {}, options = {}, body = nil, attempts = 0, &block)
          Service.response = nil
          process_params!(params, verb)
          response = response_class.new(connection.request(verb, path, params, options, body, attempts, &block))
          Service.response = response

          Error::Response.new(response.response).error.raise if response.error?
          response
        # Once in a while, a request to OSS returns an internal error. A glitch in the matrix I presume. Since these 
        # errors are few and far between the request method will rescue InternalErrors the first three times they encouter them
        # and will retry the request again. Most of the time the second attempt will work.
        rescue InternalError, RequestTimeout
          if attempts == 3
            raise
          else
            attempts += 1
            retry
          end
        end

        [:get, :post, :put, :delete, :head].each do |verb|
          class_eval(<<-EVAL, __FILE__, __LINE__)
            def #{verb}(path, params = {}, headers = {}, body = nil, &block)
              request(:#{verb}, path, params, headers, body, &block)
            end
          EVAL
        end

        private

        def response_class
          FindResponseClass.for(self)
        end

        def process_params!(params, verb)
          params.replace(RequestParams.process(params, verb))
        end
        
        # Using the conventions layed out in the <tt>response_class</tt> works for more than 80% of the time.
        # There are a few edge cases though where we want a given class to wrap its responses in different
        # response classes depending on which method is being called.
        def respond_with(klass)
          eval(<<-EVAL, binding, __FILE__, __LINE__)
            def new_response_class
              #{klass}
            end
            class << self
              alias_method :old_response_class, :response_class
              alias_method :response_class, :new_response_class
            end
          EVAL
          yield
        ensure
          # Restore the original version
          eval(<<-EVAL, binding, __FILE__, __LINE__)
            class << self
              alias_method :response_class, :old_response_class
            end
          EVAL
        end

        class RequestParams < Hash #:nodoc:
          attr_reader :options, :verb
          
          class << self
            def process(*args, &block)
              new(*args, &block).process!
            end
          end
          
          def initialize(options, verb = :get)
            @options = options.inject({}) {|h, (k,v)| h[k.to_s.camelize] = v.to_s; h }
            @verb    = verb
            super()
          end
          
          def process!
            replace(options)
          end
        end
      end

      def initialize(attributes = {}) #:nodoc:
        @attributes = attributes
      end
      
      private

      attr_reader :attributes
      
      def connection
        self.class.connection
      end
      
      def http
        connection.http
      end
      
      def request(*args, &block)
        self.class.request(*args, &block)
      end
      
      def method_missing(method, *args, &block)
        case
        when attributes.has_key?(method.to_s) 
          attributes[method.to_s]
        when attributes.has_key?(method)
          attributes[method]
        else 
          super
        end
      end

    end
  end
end