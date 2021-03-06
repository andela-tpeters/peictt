module Peictt
  module Builder
    class HttpHeader
      attr_reader :args
      attr_reader :headers
      ERROR_MSG = "First for render argument must be a view"\
      "name as a Symbol or"\
      "string; Second argument for render must be type Hash".freeze

      MODIFIERS = [:text, :json, :headers, :status].freeze

      def initialize(arg)
        @args = arg
        @headers = { "Content-Type" => "text/html" }
        process_args
      end

      def status
        @status || 200
      end

      private

      def json
        @headers["Content-Type"] = "application/json"
      end

      def text
        @headers["Content-Type"] = "text/plain"
      end

      def add_headers(headers)
        @headers.merge! headers
      end

      def process_options(options)
        @status = options[:status]
        options.keys.each do |key|
          if MODIFIERS.include?(key) && (key != :headers)
            send(key)
          elsif MODIFIERS.include?(key) && (key == :headers)
            add_headers options[:headers]
          end
        end
      end

      def process_args
        if (args.size > 1) && (args[1].is_a? Hash)
          process_options args[1]
        elsif (args.size == 1) && (args[0].is_a? Hash)
          process_options args[0]
        elsif (args.size == 1) &&
              ((args[0].is_a? String) || (args[0].is_a? Symbol))
          status
        elsif (args.size > 1) && (!args[1].is_a? Hash)
          raise ArgumentError.new ERROR_MSG
        end
      end
    end
  end
end
