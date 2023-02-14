module SmtRails
  class Processor
    attr_reader :namespace

    def initialize(filename, &block)
      @namespace = "this.#{SmtRails.template_namespace}"
      @filename = filename
      @source   = block.call
    end

    def render(context, empty_hash_wtf)
      self.class.run(@filename, @source, context)
    end

    class << self
      def run(filename, source, context)
        evaluate(context, source)
      end

      def call(input)
        filename = input[:filename]
        source   = input[:data]
        context  = input[:environment].context_class.new(input)

        result = run(filename, source, context)
        context.metadata.merge(data: result)
      end

      private

      def evaluate(scope, source)
        template_key = path_to_key(scope)
        <<~MUSTACHE_TEMPLATE
        (function() {
        #{@namespace} || (#{@namespace} = {});
        #{@namespace}Cache || (#{@namespace}Cache = {});
        #{@namespace}Cache[#{template_key.inspect}] = Mustache.compile(#{source});
        Mustache.compilePartial(#{template_key.inspect}, #{source});

        #{@namespace}[#{template_key.inspect}] = function(object) {
          if (!object){ object = {}; }
          return #{SmtRails.template_namespace}Cache[#{template_key.inspect}](object);
        };
        }).call(this);
        MUSTACHE_TEMPLATE
      end

      def path_to_key(scope)
        path = scope.logical_path.to_s.split('/')
        path.last.gsub!(/^_/, '')
        path.join('/')
      end
    end
  end
end
