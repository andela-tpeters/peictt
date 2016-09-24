require "sqlite3"
module Peictt
  class Database
    def self.connect
      @db ||= SQLite3::Database.new(File.join(APP_ROOT, "db", "app.db"))
    end

    def self.execute_query(*query)
      connect.execute(query[0], query[1] || [])
    end
  end
end
