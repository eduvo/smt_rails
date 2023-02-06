# -*- encoding: utf-8 -*-
require File.expand_path('../lib/smt_rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexey Vasiliev", "Alexander Chaplinsky"]
  gem.email         = ["contacts@railsware.com"]
  gem.description   = %q{Shared mustache templates for rails 3}
  gem.summary       = %q{Shared mustache templates for rails 3}
  gem.homepage      = "https://github.com/railsware/smt_rails"

  gem.extra_rdoc_files  = [ "LICENSE", "README.md" ]
  gem.rdoc_options      = ["--charset=UTF-8"]

  gem.add_runtime_dependency "rails",           "~> 6.0.0"
  gem.add_runtime_dependency "tilt",            "~> 2.0.11"
  gem.add_runtime_dependency "sprockets",       "~> 2.4.0"
  gem.add_runtime_dependency "mustache",        "~> 1.1.1"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "smt_rails"
  gem.require_paths = ["lib"]
  gem.version       = SmtRails::VERSION
end
