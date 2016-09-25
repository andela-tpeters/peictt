module Peictt
  class BaseModel
    class << self
      attr_accessor :table
    end

    def initialize(attributes = {})
      self.class.table = self.class.to_s.downcase.pluralize
      self.class.set_methods
      attributes.each do |key, value|
        send("#{key}=", value)
      end unless attributes.empty?
      self
    end

    def self.set_methods
      columns = Database.connect.table_info(self.class.table).map do |column|
        column["name"]
      end
      make_methods columns
    end

    def self.make_methods(columns)
      columns.each do |column|
        attr_accessor column.to_sym unless columns == "created_at" || "updated_at"
        if (column == "created_at") || (column == "updated_at")
          attr_reader column.to_sym
        else
          attr_accessor column.to_sym
        end
      end
    end

    def save
      if @id
        self.class.parse_time_to_s self
        return DatabaseMapper.new(self, :update).save
      else
        return DatabaseMapper.new(self, :create).save
      end
    end

    def self.parse_time_to_s(model)
      model.updated_at = Time.now.to_s
      model.created_at = model.created_at.to_s
    end

    def self.create(attributes)

    end

    def update(attributes)
      attributes.each do |key, value|
      end
    end

    def self.find_by(attributes = {})
    end

    def self.where()
    end
  end
end
