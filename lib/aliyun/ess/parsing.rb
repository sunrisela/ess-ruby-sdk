# -*- encoding : utf-8 -*-
#:stopdoc:
module Aliyun
  module ESS
    module Parsing
      
      module Typecasting
        def typecast(object)
          case object
          when Hash
            typecast_hash(object)
          when Array
            object.map {|element| typecast(element)}
          when String
            CoercibleString.coerce(object)
          else
            object
          end
        end
        
        def typecast_hash(hash)
          keys   = hash.keys.map {|key| key.underscore}
          values = hash.values.map {|value| typecast(value)}
          keys.inject({}) do |new_hash, key|
            new_hash[key] = values.slice!(0)
            new_hash
          end
        end
      end

      class JsonParser < Hash
        include Typecasting
        
        attr_reader :body, :code

        def initialize(body)
          @body = body
          unless body.strip.empty?
            parse
            typecast_json_parsed
            set_code
          end
        end

        def slice(*keys)
          keys.map! { |key| key.to_s }
          keys.inject({}) { |hash, k| hash[k] = self[k] if has_key?(k); hash }
        end

        private

        def parse
          @json_parsed = JSON.parse(body)
        end

        def set_code
          @code = self['code']
        end

        def typecast_json_parsed
          typecast_json = {}
          @json_parsed.dup.each do |key, value| # Some typecasting is destructive so we dup
            typecast_json[key.underscore] = typecast(value)
          end
          # An empty body will try to update with a string so only update if the result is a hash
          update(typecast_json) unless typecast_json.keys.size==0
        end
      end
    end
  end
end
#:startdoc:
