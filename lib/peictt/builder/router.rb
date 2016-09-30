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

      def root(arg)
        url = "/"
        route = Peictt::Http::GET.new url, to: arg
        @routes << route
        route
      end

      def method_missing(name, url, args = {})
        verb = name.to_s.upcase
        verb_class = Object.const_get "Peictt::Http::#{verb}"
        route = verb_class.new url, args
        @routes << route unless route_exists? route
        route
      end

      def route_exists?(route)
        @routes.each do |r|
          if r.url == route.url
            return true
          end
        end
        false
      end


      def respond_to_missing?(type, include_private = false)
        super
      end
    end
  end
end
