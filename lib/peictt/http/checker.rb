module Peictt
  module Http
    class Checker
      def self.check_url(env, routes)
        routes.each do |route|
          match = route.regexp.match(env["PATH_INFO"])
          if match && ((env["REQUEST_METHOD"] == route.verb) ||
            (route.verb.include? env["REQUEST_METHOD"]))
            return route.controller.action(route.action)
          end
        end

        -> (_env) { [404, {}, ["Route not found"]] }
      end
    end
  end
end
