module Peictt
  module Http
    class DELETE < Peictt::Http::Http
      def initialize(*args)
        super
        @verb = "DELETE"
      end
    end
  end
end
