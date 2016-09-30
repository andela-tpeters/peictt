require "tilt/haml"

module Peictt
  class Controller
    DEFAULT_LAYOUT = "application".freeze
    attr_reader :request

    class << self
      attr_accessor :layout

      def action(action_name)
        -> (_env) { new.dispatch(action_name) }
      end

      def layout(layout_name = nil)
        view_name = layout_name || DEFAULT_LAYOUT
        file = File.join(
          APP_ROOT,
          "app",
          "views",
          "layouts",
          "#{view_name}.haml"
        )
        @layout = Tilt::HamlTemplate.new(file)
      end

      def get_asset(filename)
        file = ""
        if /^[a-z_]+\.css$/.match filename
          file = File.read File.join(APP_ROOT, "app", "assets","css", "#{filename}")
        elsif /^[a-z_]+\.js$/.match filename
          file = File.read File.join(APP_ROOT, "app", "assets","js", "#{filename}")
        end
        Rack::Response.new(file, 200, {"Content-Type"=>"text/css"})
      end
    end

    def redirect_to(url)
      response([], 302, "Location" => url)
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
        return render_html(template)
      else
        return render_json(template)
      end
    end

    def render_html(template)
      self.class.layout.render(self, template.locals) do
        Tilt::HamlTemplate.new(template.body).render(self, template.locals)
      end
    end

    def render_json(template)
      Parser::JSON.new(File.read(template.body)).render(self, template.locals)
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").to_snake_case
    end

    def dispatch(action)
      @action = action
      send(action)
      render(action) unless get_response
      get_response
    end
  end
end
