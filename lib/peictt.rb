require "peictt/version"
require "pry"
require "haml"
require "puma"
require "json"
require "jsonify"
require "peictt/session"
require "peictt/controller"
require "peictt/utils"
require "peictt/config/puma"
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

module Peictt
  class Application
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [ 500, {}, [] ]
      end
      get_rack_app(env).call(env)
    end

    def routes
      @route_builder ||= Peictt::Builder::Router.new
    end

    def get_rack_app(env)
      Peictt::Http::Checker.check_url(env, @route_builder.routes)
    end
  end
end
