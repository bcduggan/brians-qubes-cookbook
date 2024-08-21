module BQC
  module Tags
    class Block < Liquid::Block
      DOUBLE_QUOTED = %r!"[^"\\]*(?:\\.[^"\\]*)*"!.freeze
      SINGLE_QUOTED = %r!'[^'\\]*(?:\\.[^'\\]*)*'!.freeze
      BARE = %r![/\w_-]+!.freeze
      VALUE = %r!#{DOUBLE_QUOTED}|#{SINGLE_QUOTED}|#{BARE}!.freeze
      PARAM = %r!(#{BARE})\s*=\s*(#{VALUE})!.freeze
      PARAMS_STRING = %r!(?<params_string>.*)!.freeze

      ATTRIBUTE_NAMES = ["id"]
      ARGS = %r!(?<tag>#{BARE})!.freeze

      def initialize(tag_name, markup, tokens)
        super
        matched = markup.match(%r!#{self.class::ARGS}\s+#{PARAMS_STRING}!.freeze)

        @params_string = matched["params_string"]
        @param_strings = @params_string.scan(PARAM).each_with_object({}) {|(name, string), hash| hash[name] = string}.to_h

        @arg_strings = matched.named_captures.select do |name, string| 
          name != "params_string"
        end

        @bare_arg_strings = @arg_strings.map do |name, string|
          [name, unquote_arg(string)]
        end

        @args = @bare_arg_strings.to_h
      end

      def render(context)
        @params = @param_strings.map {|name, string| [name, eval_param(string, context)]}.to_h
        @attributes = @params.select { |(name, value)| self.class::ATTRIBUTE_NAMES.include?(name) }
        super.to_s
      end

      private

      def markdownify(content, context)
        context.registers[:site].find_converter_instance(
          Jekyll::Converters::Markdown
        ).convert(content.to_s).strip
      end

      def unquote(string)
        case string
          when DOUBLE_QUOTED
            string[1..-2].gsub('\\"', '"')
          when SINGLE_QUOTED
            string[1..-2].gsub("\\'", "'")
          else
            raise StandardError.new "Not a quoted string: \n#{string}"
        end
      end

      def unquote_arg(string)
        begin
          unquote(string)
        rescue StandardError
          if string.match?(BARE)
            string
          else
            raise Exception.new "Not a bare word or quoted string: \n#{string}"
          end
        end
      end

      def eval_param(string, context)
        begin
          unquote(string)
        rescue StandardError
          if string.match?(BARE)
            context[string]
          else
            raise Exception.new "Not a bare word or quoted string: \n#{string}"
          end
        end
      end

      def html(tag, content, *attributes)
        attribute_strings = attributes.collect { |name, value| %(#{name}="#{value}") }
        attributes_string = attribute_strings.length ? " #{attribute_strings.join(' ')}" : ""
        "<#{tag}#{attributes_string}>#{content}</#{tag}>"
      end

      LEADING_OR_TRAILING_LINE_TERMINATORS = %r!\A(\n|\r)+|(\n|\r)+\z!.freeze

      def highlight(language, content, context)
        require "rouge"
        code = content.gsub(LEADING_OR_TRAILING_LINE_TERMINATORS, "")
        highlight_wrap(
          highlight_format(language, code),
          context
        )
      end

      def highlight_format(language, code)
        require "rouge"
        formatter = Rouge::Formatters::HTMLLineTable.new(
          Rouge::Formatters::HTML.new
        )
        lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText
        formatter.format(lexer.lex(code))
      end

      def highlight_wrap(content, context)
        prefix = context["highlighter_prefix"] || ""
        suffix = context["highlighter_suffix"] || ""
        prefix + content + suffix
      end
    end

    class HTMLBlock < Block
      def render(context)
        html(@args["tag"], super.to_s, *@attributes)
      end
    end

    class BlockquoteBlock < Block
      ARGS = ""

      def render(context)
        content = super.to_s
        html("blockquote", content, *@attributes)
      end
    end

    class CalloutBlock < Block
      ARGS = %r!(?<callout>#{BARE})!.freeze
      ATTRIBUTE_NAMES = ["id", "class"]

      def render(context)
        content = super.to_s
        attributes = {
          **@attributes,
          "class" => @args["callout"]
        }
        html("blockquote", content, *attributes)
      end
    end

    class QubeConsoleBlock < Block
      ARGS = %r!(?<qube>#{BARE})!.freeze

      def render(context)
        content = super.to_s
        qube_label = context.registers[:site].data["qubes"][@args["qube"]]["label"]
        title = html("p", @args["qube"])
        figcaption = html("figcaption", "Console")
        code = highlight("console", content, context)
        figure = html("figure", code + figcaption, *{"class" => "highlight no-line-numbers"})
        html("blockquote", title + figure, *{"class" => "#{qube_label}-title"}, *@attributes)
      end

    end

    class QubePolicyBlock < Block
      ARGS = %r!(?<qube>#{VALUE})\s+(?<file>#{VALUE})!.freeze

      def render(context)
        content = super.to_s

        qube_label = context.registers[:site].data["qubes"][@args["qube"]]["label"]

        title = html("p", @args["qube"])

        console_caption = html("figcaption", "Edit #{@args["file"]}")
        console_code = highlight("console", "$ qubes-policy-edit #{@args["file"]}", context)
        console_figure = html("figure", console_code + console_caption, *{"class" => "highlight no-line-numbers"})

        policy_caption = html("figcaption", @args["file"])
        policy = highlight("plaintext", content, context)
        policy_figure = html("figure", policy + policy_caption, *{"class" => "highlight no-line-numbers"})

        html("blockquote", title + console_figure + policy_figure, *@attributes, *{"class" => "#{qube_label}-title"})
      end
    end
  end
end 

Liquid::Template.register_tag('qubeconsole', BQC::Tags::QubeConsoleBlock)
Liquid::Template.register_tag('qubepolicy', BQC::Tags::QubePolicyBlock)
