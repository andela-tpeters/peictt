module Peictt
  module Http
    class Checker
      def self.check_url(env, routes)
        routes.each do |route|
          params = {}
          match = route.regexp.match(env["PATH_INFO"])
          if match && ((env["REQUEST_METHOD"] == route.verb) ||
            (route.verb.include? env["REQUEST_METHOD"]))
            unless route.placeholders.empty?
              params = route.placeholders.zip(match.captures).to_h
            end
            return [route, params]
          end
        end

        -> (_env) { [404, {}, ["Route not found"]] }
      end
    end
  end
end
