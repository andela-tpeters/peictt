module Peictt
  module Http
    class MATCH
      attr_reader :regexp, :controller, :action, :verb

      DEFAULT_METHODS = %w(GET PATCH DELETE PUT POST).freeze

      def initialize(regexp, options = {})
        @regexp = (regexp if regexp.is_a? Regexp) || regexp_error
        @controller = options[:controller] || controller_error
        @action = options[:action] || action_error
        get_verbs options[:methods]
      end

      def get_verbs(methods)
        no_method_error methods
        @verb = (methods unless methods.empty?) || DEFAULT_METHODS
      end

      def regexp_error
        raise ArgumentError.new("Provide regexp for match First argument")
      end

      def controller_error
        raise ArgumentError.new("controller for match not provided")
      end

      def action_error
        raise ArgumentError.new("action for match not provided")
      end

      def no_method_error(methods)
        unless methods.is_a? Array
          raise ArgumentError.new("methods for match must be array")
        end
      end
    end
  end
end
