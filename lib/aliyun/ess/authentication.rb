# -*- encoding : utf-8 -*-
module Aliyun
  module ESS
    class Authentication
      class Signature < String #:nodoc:
        attr_reader :params, :access_key_id, :secret_access_key, :options
  
        def initialize(params, access_key_id, secret_access_key, options = {})
          super()
          @params, @access_key_id, @secret_access_key = params, access_key_id, secret_access_key
          @options = options
        end
  
        private

        def escape_string(str)
          CGI.escape(str).gsub(/\+/,'%20').gsub(/%7E/, '~')
        end
    
        def sign_string
          StringToSign.new(canonical_string)
        end

        def canonical_string
          @canonical_string ||= CanonicalString.new(params, access_key_id, {})
        end
  
        def encoded_canonical
          digest   = OpenSSL::Digest::Digest.new('sha1')
          b64_hmac = [OpenSSL::HMAC.digest(digest, secret_access_key+'&', sign_string)].pack("m").strip
          url_encode? ? CGI.escape(b64_hmac) : b64_hmac
        end
        
        def url_encode?
          !@options[:url_encode].nil?
        end
      end

      class QueryString < Signature
        def initialize(*args)
          super
          self << build
        end

        private

        def build
          "#{canonical_string}&Signature=#{escape_string(encoded_canonical)}"
        end
      end

      class StringToSign < String
        attr_reader :canonicalized_query_string
        def initialize(canonicalized_query_string)
          super()
          @canonicalized_query_string = canonicalized_query_string
          build
        end

        private

        def build
          self << 'GET'
          self << '&%2F&'
          self << escape_string(canonicalized_query_string)
        end

        def escape_string(str)
          CGI.escape(str).gsub(/\+/,'%20').gsub(/%7E/, '~')
        end
      end

      class CanonicalString < String
        DEFAULT_PARAMS = {
          'Format'           => 'JSON',
          'SignatureMethod'  => 'HMAC-SHA1',
          'SignatureVersion' => '1.0',
          'Version'          => '2014-08-28'
        }

        attr_reader :params, :query

        def initialize(params, access_key_id, options = {})
          super()
          @params        = params
          @access_key_id = access_key_id
          @options       = options
          self << build
        end

        private

        def build
          initialize_query

          canonicalized_query_string = query.sort_by{|k, _| k}.map do |key, value|
            value = value.to_s.strip
            escaped_value = escape_string(value)
            "#{key}=#{escaped_value}"
          end.join('&')

          canonicalized_query_string
        end

        def escape_string(str)
          CGI.escape(str).gsub(/\+/,'%20').gsub(/%7E/, '~')
        end

        def initialize_query
          @query = { 'AccessKeyId' => @access_key_id }
          @query = params.merge(@query)
          @query = DEFAULT_PARAMS.merge('SignatureNonce' => random_string, 'Timestamp' => Time.now.utc.iso8601).merge(@query)
        end

        def random_string(len=32)
          rand(36**(len-1)..36**(len)).to_s 36
        end
      end
    end
  end
end