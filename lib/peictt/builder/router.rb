module Peictt
  module Builder
    class Router
      def initialize
        @routes = []
        @placeholders = []
      end

      def draw(&block)
        instance_eval(&block)
      end

      def all
        @routes
      end

      def method_missing(name, url, args = {})
        verb = name.to_s.upcase
        verb_class = Object.const_get "Peictt::Http::#{verb}"
        route = verb_class.new url, args
        @routes << route
        route
      end
    end
  end
end
