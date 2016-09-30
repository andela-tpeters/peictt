require "peictt/version"
require "pry"
require "haml"
require "puma"
require "json"
require "active_support/inflector"
require "peictt/controller"
require "peictt/utils"
require "peictt/dependencies"
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
require "peictt/http/delete"
require "peictt/parser/json"
require "peictt/orm/database"
require "peictt/orm/base_model"
require "peictt/orm/migrations"
require "peictt/orm/constraints_parser"
require "peictt/orm/database_mapper"

module Peictt
  class Application
    def call(env)
      if /^[(\/|)]assets\/[(css|js)]+\/([a-z_]+\.[(css|js)]+)$/.match env["PATH_INFO"]
        return Peictt::Controller.get_asset($1)
      end
      @@request = Rack::Request.new(env)
      get_rack_app(env)
    end

    def self.config
    end

    def self.params
      @@request.params
    end

    def self.session
      @@request.session
    end

    def self.routes
      @route_builder ||= Peictt::Builder::Router.new
    end

    def get_rack_app(env)
      route, params = Peictt::Http::Checker.check_url(env, self.class.routes.all)
      @@request.params.merge! params unless params.nil?
      if route.respond_to? :controller
        return route.controller.action(route.action).call(env)
      else
        return route.call(env)
      end
    end
  end
end
