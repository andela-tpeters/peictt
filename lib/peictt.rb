require "peictt/version"
require "pry"
require "haml"
require "puma"
require "json"
<<<<<<< 1caf55363536f16d7be7286789841ef9f8729231
require "active_support/inflector"
=======
>>>>>>> ft base model
require "peictt/controller"
require "peictt/utils"
require "peictt/builder/http_header"
require "peictt/builder/template"
require "peictt/builder/router"
require "peictt/http/http"
require "peictt/http/checker"
require "peictt/http/get"
require "peictt/http/post"
require "peictt/http/put"
require "peictt/http/patch"
require "peictt/http/match"
require "peictt/parser/json"
require "peictt/orm/database"
require "peictt/orm/base_model"
require "peictt/orm/migrations"
require "peictt/orm/constraints_parser"
require "peictt/orm/database_mapper"

module Peictt
  class Application
    @request = nil
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [500, {}, []]
      end
      @request = Rack::Request.new(env)
      get_rack_app(env).call(env)
    end

    def self.config(&block)
      # binding.pry
    end

    def self.params
      @request.params
    end

    def self.session
      @request.session
    end

    def self.routes
      @route_builder ||= Peictt::Builder::Router.new
    end

    def get_rack_app(env)
      Peictt::Http::Checker.check_url(env, self.class.routes.all)
    end
  end
end
