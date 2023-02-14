require "smt_rails/version"
require "smt_rails/config"

module SmtRails
  extend Config

  autoload(:Processor, 'smt_rails/processor')

  if defined?(Rails)
    require 'smt_rails/engine'
  else
    require 'sprockets'
    Sprockets.register_engine ".#{SmtRails.template_extension}", Processor
  end
end

# init action view handler
require "smt_rails/mustache"
