module Peictt
  module Http
    class PUT < Peictt::Http::Http

      def initialize(*args)
        super
        @verb = "PUT"
      end
    end
  end
end
