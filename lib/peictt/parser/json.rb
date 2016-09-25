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

      def parse_instance_variables(klass)
        if klass
          vars = klass.instance_variables.select do |var|
            !NOT_ALLOWED.include? var
          end
          vars.each do |var|
            var_str = to_str var
            value = klass.instance_variable_get(var)
            @file = replace_placeholders @file, value
          end
        end
      end

      def parse_local_variables(locals)
        unless locals.empty?
          keys = locals.keys
          keys.each do |key|
            key_str = to_str key
            value = locals[key]
            @file = replace_placeholders @file, value
          end
        end
      end

      def replace_placeholders(file, value)
        file.gsub(
          regexp_with_space(key_str), (("\"#{value}\"" if value) || "")
        ).gsub(
          regexp_without_space(key_str), (("\"#{value}\"" if value) || "")
        )
      end

      def parse_missing_variables
        @file = @file.gsub(regexp_with_space, "\"\"").
                gsub(regexp_without_space, "\"\"")
      end

      def minify
        @file.gsub(/(\s+)/, "\s")
      end

      def regexp_with_space(str = "[a-z_]")
        Regexp.new("(=\s#{str}+)")
      end

      def regexp_without_space(str = "[a-z_]")
        Regexp.new("(=#{str}+)")
      end

      def to_str(sym)
        sym.to_s.delete(":")
      end
    end
  end
end
