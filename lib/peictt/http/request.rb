module Peictt
  module Http
    class Request
      def initialize(env)
        @request = Rack::Request.new env
      end
    end
  end
end
