module Peictt
  module Http
    class MATCH
      attr_reader :regexp, :controller, :action, :verb

      DEFAULT_METHODS = ["GET","PATCH","DELETE","PUT","POST"]
      def initialize(regexp, options = {})
        @regexp = (regexp if regexp.is_a? Regexp) || (raise ArgumentError.new("Provide regexp for match First argument"))
        @controller = options[:controller] || (raise ArgumentError.new("controller for match not provided"))
        @action = options[:action] || (raise ArgumentError.new("action for match not provided"))
        get_verbs options[:methods]
      end

      def get_verbs(methods)
        raise ArgumentError.new("methods for match must be array") unless (methods.is_a? Array)
        @verb = (methods unless methods.empty?) || DEFAULT_METHODS
      end
    end
  end
end
