module BQC
  module Tags
    class QubeBlock < Liquid::Block
      include Liquid::StandardFilters

      ARGUMENT = %r![a-zA-Z0-9_-]+!.freeze
      PARAM = %r!
        ([\w-]+)\s*=\s*
        (?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w.-]+))
      !x.freeze
      MARKUP = %r!(?<qube>#{ARGUMENT})(?<language>(\s+#{ARGUMENT})?)(?<unparsed_params>.*)!.freeze

      def initialize(tag_name, markup, tokens)
        super
        matched = @markup.strip.match(MARKUP)
        raise SyntaxError, <<~MSG unless matched
          Syntax Error in tag '#{@tag_name}' while parsing the following markup:

          #{markup.strip}

          Valid syntax: qube <qube> <language> [caption="Caption for figure"] [description="Description of code"] [mark_lines="3 4 5"] [linenos="false"|"true"]
        MSG

        @qube = matched["qube"].strip
        @language = matched["language"].strip
        @unparsed_params = matched["unparsed_params"].strip
        @tag_name = tag_name
      end

      LEADING_OR_TRAILING_LINE_TERMINATORS = %r!\A(\n|\r)+|(\n|\r)+\z!.freeze

      def render(context)
        require "rouge"
        parse_params(context)

        prefix = context["highlighter_prefix"] || ""
        suffix = context["highlighter_suffix"] || ""
        code = super.to_s.gsub(LEADING_OR_TRAILING_LINE_TERMINATORS, "")

        content = figure(format(code))

        if @params["edit_command"]
          content = figure(
            format(
              @params["edit_command"],
              language="console"
            ),
            caption="Editor command"
          ) + content
        end

        qube_label = context.registers[:site].data["qubes"][@qube]["label"]

        blockquote_class_attribute = ["#{qube_label}-title"]

        if @params["id"]
          blockquote_class_attribute.append(@params["id"])
        end

        html = <<~HTML.gsub(/\s*\n\s*/, "")
          <blockquote class="#{blockquote_class_attribute.join(" ")}">
            <p>#{@qube}</p>
            %s
          </blockquote>
        HTML

        sprintf(html, content, @params["caption"] || "")
      end

      private

      def parse_params(context)
        @params = {"line_numbers" => false}

        @params["caption"] = "Console" if @language == "console"

        @unparsed_params.scan(PARAM) do |key, d_quoted, s_quoted, variable|
          value = if d_quoted
                    d_quoted.include?('\\"') ? d_quoted.gsub('\\"', '"') : d_quoted
                  elsif s_quoted
                    s_quoted.include?("\\'") ? s_quoted.gsub("\\'", "'") : s_quoted
                  elsif variable
                    context[variable]
                  else
                    raise SyntaxError, <<~MSG
                      Syntax Error in tag '#{@tag_name}' while parsing the following markup:

                      #{value.strip}

                      Valid syntax for values:
                      
                      - Double-quoted: "value"
                      - Single-quoted: 'value'
                      - Bare variable: variable
                    MSG
                  end

          case key
          when "mark_lines"
            begin
              value = value.split.map(&:to_i)
            rescue => exception
              warn exception.message
              raise SyntaxError, <<~MSG
                Syntax Error in tag '#{@tag_name}' while parsing the following markup:

                #{value.strip}

                Value for 'mark_lines' parameter must be a quoted, space-separated list of integers. Examples:

                - "1 2 3"
                - "5"
              MSG
            end
          when "line_numbers"
            value.downcase == "true" ? value = true : value = false
          end

          @params[key] = value
        end
      end

      def format(code, language=@language)
        formatter = Rouge::Formatters::HTMLLineTable.new(Rouge::Formatters::HTML.new)
        lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText
        formatter.format(lexer.lex(code))
      end

      def figure(content, caption=@params["caption"])
        figure_class_attribute = ["highlight"]

        if not @params["line_numbers"]
          figure_class_attribute.append("no-line-numbers")
        end

        html = <<~HTML.gsub(/\s*\n\s*/, "")
          <figure class="#{figure_class_attribute.join(" ")}">
            %s
            <figcaption>
              %s
            </figcaption>
          </figure>
        HTML

        sprintf(html, content, caption)
      end
      
    end
  end
end 

Liquid::Template.register_tag('qubecode', BQC::Tags::QubeBlock)
