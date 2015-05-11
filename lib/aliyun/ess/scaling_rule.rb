# -*- encoding : utf-8 -*-
module Aliyun
  module ESS
    class ScalingRule < Base
      class << self
        def find(params={}, options={})
          params = {'Action' => 'DescribeScalingRules', 'RegionId' => 'cn-hangzhou', 'PageNumber' => 1}.merge params
          Collection.new get('/', params, options)
        end

        def find_by(*args)
          c = find(*args)
          c.items.first
        end

        def execute(params={'ScalingRuleAri' => 'ari:acs:ess:cn-hangzhou:1358641544878377:scalingrule/duK8myelWehmcB5WH9cUTsu7'}, options={})
          params = {'Action' => 'ExecuteScalingRule'}.merge params
          get('/', params, options)
        end
      end

      include SelectiveAttributeProxy

      attr_accessor :scaling_group

      def initialize(attributes = {})
        super

      end

      def id
        attributes['scaling_rule_id']
      end

      def name
        attributes['scaling_rule_name']
      end

      def execute
        self.class.execute :scaling_rule_ari => scaling_rule_ari
      end

    end
  end
end