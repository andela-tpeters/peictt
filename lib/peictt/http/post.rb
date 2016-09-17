module Peictt
  module Http
    class POST < Peictt::Http::Http

      def initialize(*args)
        super
        @verb = "POST"
      end
    end
  end
end
