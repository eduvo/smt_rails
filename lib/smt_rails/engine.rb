module SmtRails
  class Engine < ::Rails::Engine
    config.before_configuration do |app|
      app.paths['app/views'] << SmtRails.template_base_path
    end

    initializer "sprockets.smt_rails", :group => :all do |app|
      app.config.assets.configure do |env|
        if env.respond_to?(:register_transformer)
          env.register_mime_type 'text/html', extensions: ['.mustache'], charset: :html
          args = ['text/html', Tilt
          args << { silence_deprecation: true } if Sprockets::VERSION.start_with?("3")
          env.register_preprocessor *args
        elsif env.respond_to?(:register_engine)
          args = [".#{SmtRails.template_extension}", Tilt]
          if Sprockets::VERSION.start_with?("3")
            args << { mime_type: 'text/html', extensions: ['.mustache'], silence_deprecation: true }
          end
          env.register_engine(*args)
        end
      end
      app.config.assets.paths << SmtRails.template_base_path
    end
  end
end
