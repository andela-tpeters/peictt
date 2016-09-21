module Peictt
  module Orm
    class BaseModel
      def initialize(properties = {})
        properties.each {|key, value| send("#{key}=", value)}
      end
    end
  end
end
