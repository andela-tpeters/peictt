module Peictt
  module Builder
    class Template
      attr_reader :body, :arg, :locals, :action, :format
      FORMAT = [:json, :text]

      def initialize(args, controller_name, action)
        @arg = args
        @action = action
        @controller = controller_name
        get_format arg.dup
        get_locals
        build_body
        raise "Template view not found" unless @body
      end

      def get_format(arg)
        arg.shift if arg.size > 1
        format = arg[0].keys.select! { |key| FORMAT.include? key }
        raise "2 application types given...expected 1" if format.size > 1
        @format = (format[0] unless format.empty?) || :html
      end

      def get_locals
        if arg.size > 1
          @locals = arg[1][:locals] || {}
          @locals.merge! arg[1][:json] if json?
        else
          @locals = arg[0][:locals] || {}
          @locals.merge! arg[0][:json] if json?
        end
      end

      def build_body
        if arg && arg.size > 1 && arg[1][:controller].nil?
          template_from_view(arg.dup.shift.to_s)
        elsif arg && arg.size > 1 && arg[1][:controller]
          template_from_controller(arg.dup.shift.to_s, arg[1][:controller])
        else
          build_template(arg[0])
        end
      end

      def build_template(parts)
        if parts[:controller]
          template_from_controller @action, parts[:controller]
        end
      end

      def template_from_view(name)
        @body = File.read(filename(name, @controller))
      end


      def template_from_controller(name, controller_name)
        @body = File.read(filename(name, controller_name))
      end

      def filename(name, controller_name)
        (File.join("app","views", controller_name, "#{name}.haml") if html?) ||
        (File.join("app","views", controller_name, "#{name}.json.peictt") if json?)
      end

      def html?
        @format == :html
      end

      def json?
        @format == :json
      end
    end
  end
end
