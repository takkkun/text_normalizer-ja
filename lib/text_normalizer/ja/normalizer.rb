module TextNormalizer
  module Ja
    module Normalizer
      def self.included(klass)
        klass.extend(ClassMethods)
        klass.instance_variable_set(:@order, [])
        klass.instance_variable_set(:@filters, {})
      end

      module ClassMethods

        # @attribute [r] order
        # @return [Array<Symbol>] name of filters (order which you defined the
        #   filters)
        attr_reader :order

        # @attribute [r] filters
        # @return [Hash<Symbol, Proc>] defined filters
        attr_reader :filters

        # Define a filter.
        #
        # @param [Symbol, String] name name of the filter
        # @yield [input] from input to output
        # @yieldparam [Object] input any input
        # @yieldreturn [Object] any output
        def define(name, &filter)
          name = name.to_sym
          order << name unless order.include?(name)
          filters[name] = filter.dup.extend(Composable)
        end

        # Build a normalizer with any filters.
        #
        # @return [Proc] the normalizer
        # @yield build the normalizer with any filters
        # @yieldreturn [Proc] the normalizer
        def build(&build)
          raise ArgumentError, 'need a block' unless block_given?
          normalizer = BuildingScope.new(self).instance_eval(&build)
          raise ArgumentError, 'did not get a normalizer from the block' unless normalizer.is_a?(Proc)
          normalizer
        end

      end

      class BuildingScope
        def initialize(normalizer)
          @normalizer = normalizer
        end

        def all
          @normalizer.order.map(&method(:__send__)).inject { |f, g| f >> g }
        end

        def f(&filter)
          filter.dup.extend(Composable)
        end

        def method_missing(name, *)
          raise NameError, "#{name} filter is not defined in #{@normalizer}", caller unless @normalizer.filters.key?(name)
          @normalizer.filters[name]
        end
      end

      module Composable
        def <<(f)
          lambda { |*args| call(f.call(*args)) }.extend(Composable)
        end

        def >>(g)
          g << self
        end
      end
    end
  end
end
