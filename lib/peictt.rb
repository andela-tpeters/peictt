require "peictt/version"
require "pry"
require "haml"
require "puma"
require "json"
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

module Peictt
  class Application

    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [ 500, {}, [] ]
      end
      @@request = Rack::Request.new(env)
      get_rack_app(env).call(env)
    end

    def self.config(&block)
      binding.pry
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
      Peictt::Http::Checker.check_url(env, self.class.routes.all)
    end
  end
end
