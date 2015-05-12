# -*- encoding : utf-8 -*-
module Aliyun
  module ESS
    class ScalingInstance < Base
      class << self
        def find(params={}, options={})
          params = {'action' => 'DescribeScalingInstances', 'region_id' => 'cn-hangzhou', 'page_number' => 1}.merge params
          Collection.new get('/', params, options)
        end

        def find_by(*args)
          c = find(*args)
          c.items.first
        end
      end

      include SelectiveAttributeProxy

      attr_accessor :scaling_group

      def initialize(attributes = {})
        super
      end

      def id
        attributes['instance_id']
      end
      
    end
  end
end