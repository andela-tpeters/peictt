require 'thor'
require 'pry'
require "peictt/utils"

module Generators
  class Generator < Thor
    include Thor::Actions

    attr_reader :app

    @dirs = %w(
      app
      bin
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

    desc "new", "this generates a new peictt app"

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

    private

    def controller(name)
      if File.exists?("config.ru")
        template "controller_template.rb",
          "app/controllers/#{name.to_snake_case}.rb"
      else
        say "Can't find the config.ru file"
      end
    end

    def create_app_directories
      empty_directory app

      self.class.dirs.each do |dir|
        empty_directory "#{app}/#{dir}"
      end
    end

    def create_directory_files
      copy_file "application_controller.rb",
                "#{app}/app/controllers/application_controller.rb"

      template "application.tt", "#{app}/config/application.rb"
      template "config.tt", "#{app}/config.ru"
      copy_file "Gemfile", "#{app}/Gemfile"
      copy_file "routes.rb", "#{app}/config/routes.rb"
      copy_file "application.haml", "#{app}/app/views/layouts/application.haml"

      %w(peictt setup console).each do |filename|
        file = File.join(File.dirname(__FILE__), "..", "bin", filename)
        copy_file file, "#{app}/bin/#{filename}"
      end
    end
  end
end
