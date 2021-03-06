lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'x-real-ip/version'

Gem::Specification.new do |spec|
  spec.name          = "x-real-ip"
  spec.version       = XRealIp::VERSION
  spec.authors       = ["55ideas"]
  spec.email         = ["info@55ideas.ru"]
  spec.description   = %q{Replace REMOTE_IP with X-Real-Ip if it's trusted (useful for Nginx)}
  spec.summary       = %q{}
  spec.homepage      = "https://github.com/55ideas/x-real-ip"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "rack"
  # todo rails 4.2
  #spec.add_dependency 'actionpack'
  spec.add_dependency "activesupport"
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '~> 2.14'
end

