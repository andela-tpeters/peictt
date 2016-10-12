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

      private

      def get_locals(options = {})
        @locals = options[:locals] || {}
        @locals.merge!(options[:json]) if json?
      end

      def build_body(view_name, options = {})
        if options[:controller].nil?
          template_from_view(view_name)
        elsif options[:controller]
          @controller = options[:controller]
          template_from_controller(view_name, options[:controller])
        else
          build_template_from_parts(options)
        end
      end

      def get_format(keys)
        format = keys.select { |key| FORMAT.include? key }
        raise "2 application types given...expected 1" if format.size > 1
        @format = (format[0] unless format.empty?) || :html
      end

      def properties_from_array_args(arg)
        get_format arg[1].keys
        build_body(arg[0], arg[1])
        get_locals arg[1]
      end

      def properties_from_hash_arg(arg)
        get_format arg[0].keys
        build_body @action, arg[0]
        get_locals arg[0]
      end

      def properties_from_string_arg(_arg)
        @format = :html
        build_body @action
        get_locals
      end

      def arg_error
        "First for render argument must be a view"\
        " name as a Symbol or"\
        " string; Second argument for render must be type Hash"
      end

      def process_args(arg)
        if (arg.size > 1) && (arg[1].is_a? Hash)
          properties_from_array_args(arg)
        elsif (arg.size == 1) && (arg[0].is_a? Hash)
          properties_from_hash_arg(arg)
        elsif (arg.size == 1) && (!arg[0].is_a? Hash)
          properties_from_string_arg(arg)
        else
          raise ArgumentError.new arg_error
        end
      end

      def build_template_from_parts(parts)
        if parts[:controller]
          template_from_controller @action, parts[:controller]
        end
      end

      def template_from_view(name)
        @body = filename(name, @controller)
      end

      def template_from_controller(name, controller_name)
        @body = filename(name, controller_name)
      end

      def filename(name, controller_name)
        return json_file(name, controller_name) if json?
        html_file(name, controller_name)
      end

      def html_file(name, controller_name)
        File.join(APP_ROOT, "app", "views", controller_name, "#{name}.haml")
      end

      def json_file(name, controller_name)
        File.join(
          APP_ROOT,
          "app",
          "views",
          controller_name,
          "#{name}.json.haml"
        )
      end
    end
  end
end
