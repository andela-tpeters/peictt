module Peictt
  module Http
    class Http
      attr_reader :url, :placeholders, :regexp, :controller, :action, :verb
      CONTROLLER_ACTION_REGEXP = /^([^#]+)#([^#]+)$/
      INVALID_ARG_ERROR = "Second argument for routes must either be a"\
                          "string or hash type".freeze
      INVALID_ROUTE_ARG = "Route arguments are not correct".freeze
      INVALID_URL_FORMAT = "correct format for 2nd argument for routes"\
                          "is `controller#action`".freeze

      def initialize(*args)
        @verb = "GET"
        @placeholders = []
        separate_args args
        process_url @url
        process_args if @args
      end

      private

      def separate_args(args)
        @args = args[1] if args.size > 1
        @url = args[0]
      end

      def args_valid?(args)
        unless (args.is_a? String) || (args.is_a? Hash)
          raise ArgumentError.new(INVALID_ARG_ERROR)
        end
      end

      def process_args
        args_valid? @args

        properties_from_string(@args) && return if @args.is_a? String
        properties_from_hash @args
      end

      def process_url(url)
        if correct_format?(url) && @args.empty?
          @url = url.tr("#", "/")
          url =~ CONTROLLER_ACTION_REGEXP
          set_controller_and_action($1, $2)
        elsif !correct_format?(url) && @args.empty?
          raise ArgumentError.new(INVALID_ROUTE_ARG)
        end
        @regexp = Regexp.new("#{get_url_regexp(@url)}$")
      end

      def set_controller_and_action(controller, action)
        controller_name = controller.to_camel_case
        @controller = Object.const_get("#{controller_name}Controller")
        @action = action
      end

      def get_url_regexp(url)
        return "/" if url == "/"
        url_parts = url.split("/")
        url_parts.select! { |part| !part.empty? }
        regexp_parts = get_placeholders url_parts
        regexp_parts.join("/")
      end

      def get_placeholders(url_parts)
        url_parts.map do |part|
          if part[0] == ":"
            @placeholders << part[1..-1]
            "([A-Za-z0-9_]+)"
          else
            part
          end
        end
      end

      def properties_from_string(str)
        raise ArgumentError.new(INVALID_URL_FORMAT) unless correct_format?(str)
        str =~ CONTROLLER_ACTION_REGEXP
        set_controller_and_action($1, $2)
      end

      def properties_from_hash(hash)
        raise ArgumentError.new(INVALID_URL_FORMAT) if correct_format? @url

        keys = hash.keys
        if (keys.include? :controller) && (keys.include? :action)
          set_controller_and_action hash[:controller], hash[:action]
          return
        end

        if (keys.include? :to) && (correct_format? hash[:to])
          hash[:to] =~ CONTROLLER_ACTION_REGEXP
          set_controller_and_action($1, $2)
          return
        end
      end

      def correct_format?(str)
        CONTROLLER_ACTION_REGEXP === str
      end
    end
  end
end
