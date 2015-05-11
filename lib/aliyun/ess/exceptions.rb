# -*- encoding : utf-8 -*-
module Aliyun
  module ESS
    
    # Abstract super class of all Aliyun::OSS exceptions
    class Exception < StandardError
    end
    
    # All responses with a code between 300 and 599 that contain an <Error></Error> body are wrapped in an
    # ErrorResponse which contains an Error object. This Error class generates a custom exception with the name
    # of the xml Error and its message. All such runtime generated exception classes descend from ResponseError
    # and contain the ErrorResponse object so that all code that makes a request can rescue ResponseError and get
    # access to the ErrorResponse.
    class ResponseError < Exception
      attr_reader :response
      def initialize(message, response)
        @response = response
        super(message)
      end
    end
    
    #:stopdoc:
    
    # Most ResponseError's are created just time on a need to have basis, but we explicitly define the
    # InternalError exception because we want to explicitly rescue InternalError in some cases.
    class InternalError < ResponseError
    end
    
    class NoSuchKey < ResponseError
    end
    
    class RequestTimeout < ResponseError
    end

    class InvalidParameter < ResponseError
    end
    
    # Abstract super class for all invalid options.
    class InvalidOption < Exception
    end

    module IncorrectCapacity
    end
    
    # Raised if an invalid value is passed to the <tt>:access</tt> option when creating a Bucket or an OSSObject.
    class InvalidAccessControlLevel < InvalidOption
      def initialize(valid_levels, access_level)
        super("Valid access control levels are #{valid_levels.inspect}. You specified `#{access_level}'.")
      end
    end
    
    # Raised if either the access key id or secret access key arguments are missing when establishing a connection.
    class MissingAccessKey < InvalidOption
      def initialize(missing_keys)
        key_list = missing_keys.map {|key| key.to_s}.join(' and the ')
        super("You did not provide both required access keys. Please provide the #{key_list}.")
      end
    end
    
    # Raised if a request is attempted before any connections have been established.
    class NoConnectionEstablished < Exception
    end
    
    # Raised if an unrecognized option is passed when establishing a connection.
    class InvalidConnectionOption < InvalidOption
      def initialize(invalid_options)
        message = "The following connection options are invalid: #{invalid_options.join(', ')}. "    +
                  "The valid connection options are: #{Connection::Options::VALID_OPTIONS.join(', ')}."
        super(message)
      end
    end
    
    class ExceptionClassClash < Exception #:nodoc:
      def initialize(klass)
        message = "The exception class you tried to create (`#{klass}') exists and is not an exception"
        super(message)
      end
    end
    
    #:startdoc:
  end
end
