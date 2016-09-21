module Peictt
  module Builder
    class HttpHeader
      attr_reader :status, :args
      MODIFIERS = [:text, :json, :headers, :status]

      def initialize(arg)
        @args = arg
        @headers = { "Content-Type"=>"text/html" }
        process_args
      end

      def json
        @headers["Content-Type"] = "application/json"
      end

      def text
        @headers["Content-Type"] = "text/plain"
      end

      def status(status = 200)
        @status = status
      end

      def headers
        @headers
      end

      def add_headers(headers)
        @headers.merge! headers
      end

      def process_options(options)
        (status(options[:status]) if options[:status]) || status
        options.keys.each do |key|
          if MODIFIERS.include?(key) && key != :headers
            self.send(key)
          elsif MODIFIERS.include?(key) && key == :headers
            add_headers options[:headers]
          end
        end
      end

      def process_args
        if (args.size > 1) && (args[1].is_a? Hash)
          process_options args[1]
        elsif (args.size == 1) && (args[0].is_a? Hash)
          process_options args[0]
        elsif (args.size == 1) && ((args[0].is_a? String) || (args[0].is_a? Symbol))
          status
        elsif (args.size > 1) && (!args[1].is_a? Hash)
          raise "First for render argument must be a view name as a Symbol or\
            string; Second argument for render must be type Hash"
        end
      end
    end
  end
end
