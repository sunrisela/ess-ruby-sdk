# -*- encoding : utf-8 -*-
module Aliyun
  module ESS
    class ScalingGroup < Base
      class << self
        def find(params={}, options={})
          params = {'action' => 'DescribeScalingGroups', 'region_id' => 'cn-hangzhou', 'page_number' => 1}.merge params
          Collection.new get('/', params, options)
        end

        def find_by(*args)
          c = find(*args)
          c.items.first
        end
      end

      include SelectiveAttributeProxy

      def initialize(attributes = {})
        super
      end

      def id
        attributes['scaling_group_id']
      end

      def name
        attributes['scaling_group_name']
      end

      def scaling_rules
        @scaling_rules ||= begin
          build_scaling_rules!
        end
      end

      private

      def build_scaling_rules!
        items = ScalingRule.find(:scaling_group_id => id).items
        items.each {|e| register(e) }
        items
      end
      
      def register(object)
        object.scaling_group = self
      end
    end
  end
end