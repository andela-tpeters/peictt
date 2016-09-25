module Peictt
  module Builder
    class Template
      attr_reader :body, :arg, :locals, :action, :format
      FORMAT = [:json, :text].freeze

      def initialize(args, controller_name, action)
        @arg = args
        @action = action
        @controller = controller_name
        process_args arg.dup
        raise "Template view not found" unless @body
      end

      def process_args(arg)
        if (arg.size > 1) && (arg[1].is_a? Hash)

          get_format arg[1].keys
          build_body arg[0], arg[1]
          get_locals arg[1]

        elsif (arg.size == 1) && (arg[0].is_a? Hash)

          get_format arg[0].keys
          build_body @action, arg[0]
          get_locals arg[0]

        elsif (arg.size == 1) && (!arg[0].is_a? Hash)

          @format = :html
          build_body @action
          get_locals

        else
          raise "First for render argument must be a view name as a Symbol or"\
            "string; Second argument for render must be type Hash"
        end
      end

      def get_format(keys)
        format = keys.select { |key| FORMAT.include? key }
        raise "2 application types given...expected 1" if format.size > 1
        @format = (format[0] unless format.empty?) || :html
      end

      def get_locals(options = {})
        @locals = options[:locals] || {}
        @locals.merge! options[:json] if json?
      end

      def build_body(view_name, options = {})
        if options[:controller].nil?
          template_from_view(view_name)
        elsif options[:controller]
          template_from_controller(view_name, options[:controller])
        else
          build_template_from_parts(options)
        end
      end

      def build_template_from_parts(parts)
        if parts[:controller]
          template_from_controller @action, parts[:controller]
        end
      end

      def template_from_view(name)
        @body = filename(name, @controller) if html? || text?
        @body = File.read(filename(name, @controller)) if json?
      end

      def template_from_controller(name, controller_name)
        @body = filename(name, controller_name) if html? || text?
        @body = File.read(filename(name, controller_name)) if json?
      end

      def filename(name, controller_name)
        return json_file(name, controller_name) if json?
        html_file
      end

      def html_file(name, controller_name)
        File.join("app", "views", controller_name, "#{name}.haml")
      end

      def json_file(name, controller_name)
        File.join("app", "views", controller_name, "#{name}.json.haml")
      end

      def html?
        @format == :html
      end

      def json?
        @format == :json
      end

      def text?
        @format == :text
      end
    end
  end
end
