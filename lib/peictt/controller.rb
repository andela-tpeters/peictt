require 'tilt/haml'

module Peictt
  class Controller
    attr_reader :request

    def redirect_to(url)
      response([], 301, "Location" => url)
    end

    def response(body, status = 200, headers = {})
      @response = Rack::Response.new(body, status, headers)
    end

    def get_response
      @response
    end

    def params
      Peictt::Application.params
    end

    def session
      Peictt::Application.session
    end

    def render(*args)
      headers = Builder::HttpHeader.new(args.dup)
      template = Builder::Template.new(args.dup, controller_name, @action)
      response(render_template(template), headers.status, headers.headers)
    end


    def render_template(template)
      if template.html? || template.text?
        render_html(template)
      else
        return render_json(template)
      end
    end

    def render_html(template)
      @@layout.render(self, template.locals) do
        Tilt::HamlTemplate.new(template.body).render(self, template.locals)
      end
    end

    def render_json(template)
      return Parser::JSON.new(template.body).render(self, template.locals)
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
      -> (env) { self.new.dispatch(action_name) }
    end

    def self.layout(layout_name = nil)
      default = "application"
      view_name = layout_name || default
      file = File.join("app","views","layouts","#{view_name}.haml")
      @@layout = Tilt::HamlTemplate.new(file)
    end
  end
end
