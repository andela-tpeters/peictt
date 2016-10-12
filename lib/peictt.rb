require "peictt/version"
require "peictt/dependencies"

module Peictt
  class Application
    ASSETS_REGEXP = %r(^[(\/|)]assets\/[(css|js)]+\/([a-z_]+\.[(css|js)]+)$)
    def call(env)
      if ASSETS_REGEXP =~ env["PATH_INFO"]
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
      route, params = Peictt::Http::Checker.check_url(env,
                                                      self.class.routes.all)
      @@request.params.merge! params unless params.nil?
      if route.respond_to? :controller
        return route.controller.action(route.action).call(env)
      else
        return route.call(env)
      end
    end
  end
end
