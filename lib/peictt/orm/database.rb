require "sqlite3"
module Peictt
  class Database
    def self.connect
      @db ||= SQLite3::Database.new(File.join(APP_ROOT, "db", "app.db"))
    end

    def self.execute_query(*query)
      binding.pry
      connect.execute(*query)
    end
  end
end
