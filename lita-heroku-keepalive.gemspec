Gem::Specification.new do |spec|
  spec.name          = "lita-heroku-keepalive"
  spec.version       = "0.1.0"
  spec.authors       = ["Ronghai Wei"]
  spec.email         = ["Ronghai.Wei@msn.com"]
  spec.description   = "Based on hubot-heroku-keepalive, to keep Heroku's free tire live"
  spec.summary       = "Keep Heroku's free tier live"
  spec.homepage      = "https://github.com/ronghai/lita-heroku-keepalive"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
