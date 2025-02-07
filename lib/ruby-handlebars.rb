require_relative 'ruby-handlebars/parser'
require_relative 'ruby-handlebars/tree'
require_relative 'ruby-handlebars/template'
require_relative 'ruby-handlebars/helper'
require_relative 'ruby-handlebars/helpers/register_default_helpers'
require_relative 'ruby-handlebars/escapers/html_escaper'

module Handlebars
  class Handlebars
    include Context
    attr_reader :escaper

    def initialize()
      @helpers = {}
      @partials = {}
      register_default_helpers
      set_escaper
    end

    def compile(template)
      Template.new(self, template_to_ast(template))
    end

    def register_helper(name, &fn)
      @helpers[name.to_s] = Helper.new(self, fn)
    end

    def get_helper(name)
      @helpers[name.to_s]
    end

    def register_partial(name, content)
      @partials[name.to_s] = Template.new(self, template_to_ast(content))
    end

    def get_partial(name)
      @partials[name.to_s]
    end

    def set_context(ctx)
      @data = ctx
    end

    def set_escaper(escaper = nil)
      @escaper = escaper || Escapers::HTMLEscaper
    end

    private

    PARSER = Parser.new
    TRANSFORM = Transform.new

    def template_to_ast(content)
      TRANSFORM.apply(PARSER.parse(content))
    end

    def register_default_helpers
      Helpers.register_default_helpers(self)
    end
  end
end
