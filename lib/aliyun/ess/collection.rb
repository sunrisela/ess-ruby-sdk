# -*- encoding : utf-8 -*-
module Aliyun
  module ESS
    class Collection
      include SelectiveAttributeProxy

      attr_reader :response, :attributes

      def initialize(response)
        @response   = response
        @attributes = response.parsed.slice(*%W{page_number page_size total_count})
      end

      def items
        @items ||= build_items!
      end

      def build_items!
        item_class = eval response.class.name.sub(/::Response$/, '')
        response.items.map{|e| item_class.new e }
      end
    end
  end
end