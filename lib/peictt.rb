require "peictt/version"
require "pry"
require "haml"
require "puma"
require "json"
require "jsonify"
require "peictt/session"
require "peictt/controller"
require "peictt/routing"
require "peictt/utils"
require "peictt/config/puma"
require "peictt/builder/http_header"
require "peictt/builder/template"
require "peictt/parser/json"

module Peictt
  class Application
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [ 500, {}, [] ]
      end

      get_rack_app(env).call(env)
    end

    def route(&block)
      @router ||= Peictt::Router.new
      @router.instance_eval(&block)
    end

    def get_rack_app(env)
      @router.check_url(env["PATH_INFO"])
    end
  end
end
