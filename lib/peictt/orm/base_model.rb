module Peictt
  class BaseModel
    def initialize(properties = {})
      properties.each {|key, value| send("#{key}=", value)}
    end
  end
end
