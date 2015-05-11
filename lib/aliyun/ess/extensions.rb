# -*- encoding : utf-8 -*-
#:stopdoc:

class Hash
  def slice(*keys)
    keys.map! { |key| key.to_s }
    keys.inject(Hash.new) { |hash, k| hash[k] = self[k] if has_key?(k); hash }
  end unless public_method_defined? :slice
end

class String
  # ActiveSupport adds an underscore method to String so let's just use that one if
  # we find that the method is already defined
  def underscore
    gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").downcase
  end unless public_method_defined? :underscore

  def camelize
    string = to_s.sub(/^[a-z\d]*/) { $&.capitalize }
    string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
    string.gsub!(/\//, '::')
    string
  end unless public_method_defined? :camelize

  if RUBY_VERSION >= '1.9'
    def valid_utf8?
      dup.force_encoding('UTF-8').valid_encoding?
    end
  else
    def valid_utf8?
      scan(Regexp.new('[^\x00-\xa0]', nil, 'u')) { |s| s.unpack('U') }
      true
    rescue ArgumentError
      false
    end
  end
  
  # All paths in in OSS have to be valid unicode so this takes care of 
  # cleaning up any strings that aren't valid utf-8 according to String#valid_utf8?
  if RUBY_VERSION >= '1.9'
    def remove_extended!
      sanitized_string = ''
      each_byte do |byte|
        character = byte.chr
        sanitized_string << character if character.ascii_only?
      end
      sanitized_string
    end
  else
    def remove_extended!
      #gsub!(/[\x80-\xFF]/) { "%02X" % $&[0] }
      gsub!(Regext.new('/[\x80-\xFF]')) { "%02X" % $&[0] }
    end
  end
  
  def remove_extended
    dup.remove_extended!
  end
end

class CoercibleString < String
  class << self
    def coerce(string)
      new(string).coerce
    end
  end
  
  def coerce
    case self
    when 'true';         true
    when 'false';         false
    # Don't coerce numbers that start with zero
    when  /^[1-9]+\d*$/;   Integer(self)
    when datetime_format; Time.parse(self)
    else
      self
    end
  end
  
  private
    # Lame hack since Date._parse is so accepting. OSS dates are of the form: '2006-10-29T23:14:47.000Z'
    # so unless the string looks like that, don't even try, otherwise it might convert an object's
    # key from something like '03 1-2-3-Apple-Tree.mp3' to Sat Feb 03 00:00:00 CST 2001.
    def datetime_format
      /^\d{4}-\d{2}-\d{2}\w\d{2}:\d{2}:\d{2}/
    end
end

class Class # :nodoc:
  def cattr_reader(*syms)
    syms.flatten.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}
          @@#{sym}
        end

        def #{sym}
          @@#{sym}
        end
      EOS
    end
  end

  def cattr_writer(*syms)
    syms.flatten.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}=(obj)
          @@#{sym} = obj
        end

        def #{sym}=(obj)
          @@#{sym} = obj
        end
      EOS
    end
  end

  def cattr_accessor(*syms)
    cattr_reader(*syms)
    cattr_writer(*syms)
  end
end if Class.instance_methods(false).grep(/^cattr_(?:reader|writer|accessor)$/).empty?

module SelectiveAttributeProxy
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.class_eval(<<-EVAL, __FILE__, __LINE__)
      cattr_accessor :attribute_proxy
      cattr_accessor :attribute_proxy_options
      
      # Default name for attribute storage
      self.attribute_proxy         = :attributes
      self.attribute_proxy_options = {:exclusively => true}
      
      private
        # By default proxy all attributes
        def proxiable_attribute?(name)
          return true unless self.class.attribute_proxy_options[:exclusively]
          send(self.class.attribute_proxy).has_key?(name)
        end
        
        def method_missing(method, *args, &block)
          # Autovivify attribute storage
          if method == self.class.attribute_proxy
            ivar = "@\#{method}"
            instance_variable_set(ivar, {}) unless instance_variable_get(ivar).is_a?(Hash)
            instance_variable_get(ivar)
          # Delegate to attribute storage
          elsif method.to_s =~ /^(\\w+)(=?)$/ && proxiable_attribute?($1)
            attributes_hash_name = self.class.attribute_proxy
            $2.empty? ? send(attributes_hash_name)[$1] : send(attributes_hash_name)[$1] = args.first
          else
            super
          end
        end
    EVAL
  end

  module ClassMethods
  end
end

#:startdoc: