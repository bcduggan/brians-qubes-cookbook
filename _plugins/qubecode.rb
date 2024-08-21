module BQC
  module Tags
    class Block < Liquid::Block
      DOUBLE_QUOTED = %r!"[^"\\]*(?:\\.[^"\\]*)*"!.freeze
      SINGLE_QUOTED = %r!'[^'\\]*(?:\\.[^'\\]*)*'!.freeze
      BARE = %r![\w_-]+!.freeze
      VALUE = %r!#{DOUBLE_QUOTED}|#{SINGLE_QUOTED}|#{BARE}!.freeze
      PARAM = %r!(#{BARE})\s*=\s*(#{VALUE})!.freeze
      PARAMS_STRING = %r!(?<params_string>.*)!.freeze

      ATTRIBUTE_NAMES = ["id"]
      ARGS = %r!(?<tag>#{BARE})!.freeze

      def initialize(tag_name, markup, tokens)
        super
        matched = markup.match(%r!#{self.class::ARGS}#{PARAMS_STRING}!.freeze)

        @params_string = matched["params_string"]
        @param_strings = @params_string.scan(PARAM).each_with_object({}) {|(name, string), hash| hash[name] = string}.to_h

        @arg_strings = matched.named_captures.select do |name, string| 
          name != "params_string"
        end

        @bare_arg_strings = @arg_strings.map do |name, string|
          [name, unquote_arg(string.strip)]
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
        qube_label = context.registers[:site].data["qubes"][@args["qube"]]["label"]
        content = super.to_s
        title = html("p", @args["qube"])
        figcaption = html("figcaption", "Console")
        code = highlight("console", content, context)
        figure = html("figure", code + figcaption, *{"class" => "highlight no-line-numbers"})
        html("blockquote", title + figure, *{"class" => "#{qube_label}-title"}, *@attributes)
      end
    end

    #class CalloutBlock < Liquid::Block
    #  include Block

    #  MARKUP = %r!(?<callout>#{ARGUMENT})(?<tail>.*)!.freeze

    #  def initialize(tag_name, markup, tokens)
    #    super
    #    pre_initialize(MARKUP)
    #  end

    #  def render(context)
    #    evaluated_params = eval_params(context)
    #    class_attribute = evaluated_params["class"] ? "#{@matched['callout']} #{evaluated_params['class']}" : callout_class
    #    attributes = {
    #      **evaluated_params,
    #      "class" => class_attribute
    #    }
    #    content = markdownify(super.to_s, context)
    #    html_tag_wrap("blockquote", attributes, content)
    #  end
    #end

    #class CalloutTitleBlock < Liquid::Block
    #  include Block

    #  MARKUP = %r!(?<callout>#{ARGUMENT})(?<title>(\s+#{ARGUMENT})?)(?<tail>.*)!.freeze

    #  def initialize(tag_name, markup, tokens)
    #    super
    #    pre_initialize(MARKUP)
    #  end

    #  def render(context)
    #    evaluated_params = eval_params(context)
    #    callout_class = "#{@matched['callout']}-title"
    #    class_attribute = evaluated_params["class"] ? "#{callout_class} #{evaluated_params['class']}" : callout_class
    #    attributes = {
    #      **evaluated_params,
    #      "class" => class_attribute
    #    }
    #    title = markdownify(eval_argument(@matched['title'], context), context)
    #    content = markdownify(super.to_s, context)
    #    html_tag_wrap("blockquote", attributes, title + content)
    #  end
    #end

    #class QubeRunBlock < Liquid::Block
    #  include Block

    #  MARKUP = %r!(?<qube>#{ARGUMENT})(?<tail>.*)!.freeze

    #  def initialize(tag_name, markup, tokens)
    #    super
    #    pre_initialize(MARKUP)
    #  end

    #  def render(context)
    #    evaluated_params = eval_params(context)
    #    qube_label = context.registers[:site].data["qubes"][@matched["qube"]]["label"]
    #    callout_class = "#{qube_label}-title"
    #    class_attribute = evaluated_params["class"] ? "#{callout_class} #{evaluated_params['class']}" : callout_class
    #    attributes = {
    #      **evaluated_params,
    #      "class" => class_attribute
    #    }
    #    title = html_tag_wrap("p", {}, @matched['qube'])
    #    code = highlight_render("console", super.to_s, context)
    #    caption = html_tag_wrap("figcaption", {}, "Console")
    #    content = html_tag_wrap("figure", {"class" => "highlight no-line-numbers"}, code + caption)
    #    html_tag_wrap("blockquote", attributes, title + content)
    #  end
    #end

    #class Qube

    #module Tag
    #  QUOTED_VALUE = %r!(?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)')!.freeze
    #  ARGUMENT = %r![\w_-]+|#{QUOTED_VALUE}!.freeze
    #  PARAM = %r!
    #    ([\w-]+)\s*=\s*
    #    #{ARGUMENT}
    #  !x.freeze

    #  private

    #  def html_tag(tag, content="", attributes="")
    #    "<#{tag} #{attributes}>#{content}</#{tag}>"
    #  end

    #  def markdownify(content, context)
    #    context.registers[:site].find_converter_instance(
    #      Jekyll::Converters::Markdown
    #    ).convert(content.to_s)
    #  end

    #  def parse_params(string, context)
    #    string.scan(PARAM).each_with_object({}) do |key, d_quoted, s_quoted, variable, obj|
    #      value = if d_quoted
    #                d_quoted.include?('\\"') ? d_quoted.gsub('\\"', '"') : d_quoted
    #              elsif s_quoted
    #                s_quoted.include?("\\'") ? s_quoted.gsub("\\'", "'") : s_quoted
    #              elsif variable
    #                context[variable]
    #              else
    #                raise SyntaxError, <<~MSG
    #                  Syntax Error in tag '#{@tag_name}' while parsing the following markup:

    #                  #{value.strip}

    #                  Valid syntax for values:
    #                  
    #                  - Double-quoted: "value"
    #                  - Single-quoted: 'value'
    #                  - Bare variable: variable
    #                MSG
    #              end

    #      obj[key] = value
    #    end
    #  end
    #end

    #module Highlight
    #  LEADING_OR_TRAILING_LINE_TERMINATORS = %r!\A(\n|\r)+|(\n|\r)+\z!.freeze

    #  def highlight_render(context)
    #    require "rouge"
    #    code = super.to_s.gsub(LEADING_OR_TRAILING_LINE_TERMINATORS, "")
    #    highlight_wrap(
    #      highlight_format(code),
    #      context
    #    )
    #  end

    #  private

    #  def highlight_format(code)
    #    require "rouge"
    #    formatter = Rouge::Formatters::HTMLLineTable.new(
    #      Rouge::Formatters::HTML.new
    #    )
    #    lexer = Rouge::Lexer.find_fancy(@language, code) || Rouge::Lexers::PlainText
    #    formatter.format(lexer.lex(code))
    #  end

    #  def highlight_wrap(content, context)
    #    prefix = context["highlighter_prefix"] || ""
    #    suffix = context["highlighter_suffix"] || ""
    #    prefix + content + suffix
    #  end

    #end

    #module Callout
    #  include Tag

    #  private

    #  def callout(title, color, content, id_attr, class_attr)
    #    title = html_tag("title", title)
    #    attributes["
    #    blockquote("#{title}#{content}", attributes)
    #  end

    #  def blockquote(content, attributes="")
    #    html_tag("blockquote", content, attributes)
    #  end

    #end

    #module Figure
    #  include Tag

    #  private

    #  def figcaption(content, attributes="")
    #    html_tag("figcaption", content, attributes)
    #  end
    #end

    #class CalloutBlock < Liquid::Block
    #  include Callout

    #  MARKUP = %r!(?<title>#{ARGUMENT})(?<color>(\s+#{ARGUMENT})?)(?<tail>.*)!.freeze

    #  def initialize(tag_name, markup, tokens)
    #    super
    #    matched = @markup.strip.match(MARKUP)
    #    raise SyntaxError, <<~MSG unless matched
    #      Syntax Error in tag '#{@tag_name}' while parsing the following markup:

    #      #{markup.strip}

    #      Valid syntax: callout <title> <color> [id=<value>] [class=<value>]
    #    MSG

    #    @title= matched["title"].strip
    #    @color = matched["color"].strip
    #    @markup_tail = matched["tail"].strip 
    #  end

    #  def render(context)
    #    attributes = parse_params(@markup_tail, context)
    #    classes = [%(#{@color}-title), attributes["class"]].join(" ")
    #    <<~HTML
    #      <blockquote id="#{attributes["id"]}" class="#{classes}">
    #        #{markdownify(@title, context)}
    #        #{super.to_s}
    #      </blockquote>
    #    HTML
    #  end
    #end

    #class HighlightBlock < Liquid::Block
    #  include Tag

    #  MARKUP = %r!(?<language>#{ARGUMENT})(?<tail>.*)!.freeze
    #  LEADING_OR_TRAILING_LINE_TERMINATORS = %r!\A(\n|\r)+|(\n|\r)+\z!.freeze

    #  def initialize(tag_name, markup, tokens)
    #    super
    #    matched = @markup.strip.match(MARKUP)
    #    raise SyntaxError, <<~MSG unless matched
    #      Syntax Error in tag '#{@tag_name}' while parsing the following markup:

    #      #{markup.strip}

    #      Valid syntax: highlight <language> [attribute=value]*
    #    MSG

    #    @language= matched["language"].strip
    #    @markup_tail = matched["tail"].strip 
    #  end

    #  def render(context)
    #    highlight_render
    #  end

    #end

    #class FigureBlock < Liquid::Block
    #  include Tag

    #  MARKUP = %r!(?<caption>#{ARGUMENT})(?<tail>.*)!.freeze

    #  def initialize(tag_name, markup, tokens)
    #    super
    #    matched = @markup.strip.match(MARKUP)
    #    raise SyntaxError, <<~MSG unless matched
    #      Syntax Error in tag '#{@tag_name}' while parsing the following markup:

    #      #{markup.strip}

    #      Valid syntax: figure [caption] [attribute=value]*
    #    MSG

    #    @caption = matched["caption"].strip
    #    @markup_tail = matched["tail"].strip 
    #  end

    #  def render(context)
    #    attributes = parse_params(@markup_tail, context)
    #    sprintf(%(<figure class="#{attributes["class"]}">%s%s</figure>), super.to_s, figcaption(@caption))
    #  end
    #end

    #class CodeBlock < Liquid::Block
    #  include Tag
    #  MARKUP = %r!(?<caption>(#{PARAM})?)(?<tail>.*)!.freeze

    #  def initialize(tag_name, markup, tokens)
    #    super
    #    matched = @markup.strip.match(MARKUP)
    #    raise SyntaxError, <<~MSG unless matched
    #      Syntax Error in tag '#{@tag_name}' while parsing the following markup:

    #      #{markup.strip}

    #      Valid syntax: code [caption] [attribute=value]*
    #    MSG

    #    @caption = matched["caption"].strip
    #    @markup_tail = matched["tail"].strip 
    #  end

    #  def render(context)
    #    %({% figure "#{caption}" class="highlight" %}#{super.to_s}{% endfigure %})
    #  end
    #end



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
Liquid::Template.register_tag('html', BQC::Tags::HTMLBlock)
Liquid::Template.register_tag('blockquote', BQC::Tags::BlockquoteBlock)
Liquid::Template.register_tag('callout', BQC::Tags::CalloutBlock)
Liquid::Template.register_tag('qubeconsole', BQC::Tags::QubeConsoleBlock)
#Liquid::Template.register_tag('callout_title', BQC::Tags::CalloutTitleBlock)
#Liquid::Template.register_tag('quberun', BQC::Tags::QubeRunBlock)
#Liquid::Template.register_tag('bilight', BQC::Tags::HighlightBlock)
#Liquid::Template.register_tag('figure', BQC::Tags::FigureBlock)
#Liquid::Template.register_tag('code', BQC::Tags::CodeBlock)
