require "sqlite3"
module Peictt
  class Database
    def self.connect
      @db ||= SQLite3::Database.new(File.join(APP_ROOT, "db", "app.db"))
    end

    def self.execute_query(*query)
<<<<<<< d5dc68b9d4fd37a6a1ccef152c3c1c5d4a520893
      connect.execute(query[0], query[1] || [])
=======
      connect.execute(*query)
>>>>>>> migration generation complete [finished #131042879]
    end
  end
end
