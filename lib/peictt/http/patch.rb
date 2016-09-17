module Peictt
  module Http
    class PATCH < Peictt::Http::Http

      def initialize(*args)
        super
        @verb = "PATCH"
      end
    end
  end
end
