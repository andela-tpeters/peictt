module Peictt
  module Parser
    class JSON
      NOT_ALLOWED = [:@env, :@request, :@response, :@action].freeze

      def initialize(file)
        @file = file
      end

      def render(klass = nil, locals = {})
        parse_instance_variables(klass)
        parse_local_variables(locals)
        parse_missing_variables
        minify
      end

      private

      def parse_instance_variables(klass)
        if klass
          vars = prune_instance_variables klass
          vars.each do |var|
            value = klass.instance_variable_get(var)
            parse_variables_helper(to_str(var), value, @file)
          end
        end
      end

      def prune_instance_variables(klass)
        klass.instance_variables.select { |var| !NOT_ALLOWED.include? var }
      end

      def parse_local_variables(locals)
        unless locals.empty?
          keys = locals.keys
          keys.each do |key|
            parse_variables_helper(to_str(key), locals[key], @file)
          end
        end
      end

      def parse_variables_helper(key, value, file)
        @file = file.gsub(regexp_with_space(key), "\"#{value}\"").
                gsub(regexp_without_space(key), "\"#{value}\"")
      end

      def parse_missing_variables
        @file = @file.gsub(regexp_with_space, "\"\"").
                gsub(regexp_without_space, "\"\"")
      end

      def minify
        @file.gsub(/(\s+)/, "\s")
      end

      def regexp_with_space(str = "[a-z_@]")
        Regexp.new("(=\s#{str}+)")
      end

      def regexp_without_space(str = "[a-z_@]")
        Regexp.new("(=#{str}+)")
      end

      def to_str(sym)
        sym.to_s.delete(":")
      end
    end
  end
end
