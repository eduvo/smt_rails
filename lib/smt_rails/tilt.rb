require 'tilt'

module SmtRails
  class Tilt < Tilt::Template
    self.metadata[:mime_type] = 'application/javascript'

    def prepare
      @namespace = "this.#{SmtRails.template_namespace}"
    end

    attr_reader :namespace

    def evaluate(scope, locals, &block)
      template_key = path_to_key scope
      <<~MUSTACHE_TEMPLATE
        (function() {
        #{namespace} || (#{namespace} = {});
        #{namespace}Cache || (#{namespace}Cache = {});
        #{namespace}Cache[#{template_key.inspect}] = Mustache.compile(#{data.inspect});
        Mustache.compilePartial(#{template_key.inspect}, #{data.inspect});

        #{namespace}[#{template_key.inspect}] = function(object) {
          if (!object){ object = {}; }
          return #{SmtRails.template_namespace}Cache[#{template_key.inspect}](object);
        };
        }).call(this);
      MUSTACHE_TEMPLATE
    end

    def self.call(input)
      new { input[:data] }.render
    end

    def path_to_key(scope)
      path = scope.logical_path.to_s.split('/')
      path.last.gsub!(/^_/, '')
      path.join('/')
    end
  end
end
