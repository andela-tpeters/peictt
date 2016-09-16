require 'haml'

module Peictt
  class Controller < Peictt::Session
    attr_reader :request

    def initialize(env)
      @env = env
      @request = Rack::Request.new(env)
    end

    def redirect_to(url)
      response([], 302, "Location"=>url)
    end

    def response(body, status = 200, headers = {})
      @response = Rack::Response.new(body, status, headers)
    end

    def get_response
      @response
    end

    def params
      request.params
    end

    def render(*args)
      headers = Builder::HttpHeader.new(args.dup)
      template = Builder::Template.new(args.dup, controller_name, @action)
      response(render_template(template), headers.status, headers.headers)
    end


    def render_template(template)
      return Haml::Engine.new(template.body).render(self, template.locals) if template.html? || template.text?
      return Parser::JSON.new(template.body).render(self, template.locals) if template.json?
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/,"").to_snake_case
    end

    def dispatch(action)
      @action = action
      content = self.send(action)
      if get_response
        get_response
      else
        render(action)
        get_response
      end
    end

    def self.action(action_name)
      -> (env) { self.new(env).dispatch(action_name) }
    end
  end
end
