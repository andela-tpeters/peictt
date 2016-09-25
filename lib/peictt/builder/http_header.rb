module Peictt
  module Builder
    class HttpHeader
      attr_reader :status, :args
      attr_writer :status
      MODIFIERS = [:text, :json, :headers, :status].freeze

      def initialize(arg)
        @args = arg
        @headers = { "Content-Type" => "text/html" }
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

      attr_reader :headers

      def add_headers(headers)
        @headers.merge! headers
      end

      def process_args
        args.shift if args.size > 1
        status args[0][:status] if args[0][:status]
        args[0].keys.each do |key|
          if MODIFIERS.include?(key) && key != :headers
            send(key)
          elsif MODIFIERS.include?(key) && key == :headers
            add_headers args[0][:headers]
          end
        end
      end
    end
  end
end
