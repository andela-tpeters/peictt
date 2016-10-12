require 'thor'
require 'pry'
require "peictt/utils"
require "pathname"

module Generators
  class Generator < Thor
    include Thor::Actions

    attr_reader :app

    @dirs = %w(
      app
      bin
      app/assets/css
      app/assets/js
      app/controllers
      app/models
      app/views
      app/views/layouts
      db
      db/migrations
      config public
    )

    class << self
      attr_reader :dirs
    end

    def self.source_root
      File.dirname(__FILE__) + "/templates"
    end

    desc "new", "generates a new app"

    def new(name)
      @app = name.downcase
      create_app_directories
      create_directory_files
    end

    desc "generate", "this is generator"
    def generate(file, name)
      send(file, name)
    end

    desc "g", "alias for generate"
    alias g generate

    desc "console", "Starts the console"
    def console
      exec "pry"
    end

    desc "server", "Starts the Peictt server"
    def server
      exec "rackup"
    end

    desc "s", "alias for server"
    alias s server

    desc "migrate", "Run migations"
    def migrate
      files = process_migration_files
      say("You have no migrations") && return if files.empty?

      files.each do |file|
        say "===========Migrating #{file[:name]}"
        file[:class].new.change
        say "===========Migrated #{file[:name]}"
        puts
      end unless files.empty?

      say "******Db Migrations Completed******"
      puts
    end

    desc "reset_migration", "Resets all migrations"
    def drop_tables
      files = process_migration_files
      say("You have no migrations") && return if files.empty?

      files.each do |file|
        say "===========Processing Table drop for #{file[:name]}"
        file[:class].new.down
        say "===========Table drop for #{file[:name]} completed"
        puts
      end unless files.empty?

      say "******Db Reset Completed******"
      puts
    end

    desc "reset_db", "Drops tables and makes a new migration"
    def reset_db
      drop_tables
      migrate
    end

    private

    def process_migration_files
      Dir[File.join(APP_ROOT, "db", "migrations", "*.rb")].map do |file|
        require file
        filename = Pathname.new(file).basename.to_s.sub! /.rb/, ''
        klass = Object.const_get "#{filename.to_camel_case}Migration"
        { name: filename, class: klass }
      end
    end

    def migration(name)
      template "migration_template.rb",
        "#{APP_ROOT}/db/migrations/#{name.to_snake_case.pluralize}.rb",
        {name: name}
    end

    def model(name)
      template "model_template.rb",
        "#{APP_ROOT}/app/models/#{name.to_snake_case.singularize}.rb",
        {name: name}
    end

    def controller(name)
      template "controller_template.rb",
        "#{APP_ROOT}/app/controllers/#{name.to_snake_case}_controller.rb",
        { name: name }
    end

    def create_app_directories
      empty_directory app

      self.class.dirs.each do |dir|
        empty_directory "#{app}/#{dir}"
      end
    end

    def create_directory_files
      copy_file "application_controller.rb",
                File.join(app,"app","controllers","application_controller.rb")

      template "application.tt", File.join(app,"config","application.rb")
      template "config.tt", File.join(app,"config.ru")
      copy_file "Gemfile", File.join(app, "Gemfile")
      template "routes.rb", File.join(app,"config","routes.rb"), { name: app }
      template "readme.md", File.join(app,"README.md"), { name: app }
      template "application.haml", File.join(app,"app","views","layouts","application.haml"), { name: app }
      copy_file "landing_controller.rb", File.join(app,"app","controllers","landing_controller.rb")
      copy_file "index.haml", File.join(app,"app","views","landing","index.haml")
      copy_file "style.css", File.join(app,"app","assets", "css","style.css")

      %w(peictt setup console).each do |filename|
        file = File.join(File.dirname(__FILE__), "..", "bin", filename)
        copy_file file, "#{app}/bin/#{filename}"
      end
      chmod("#{app}/bin/peictt", 0755)
    end
  end
end
