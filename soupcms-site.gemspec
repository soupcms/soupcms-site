# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soupcms/site/version'

Gem::Specification.new do |spec|
  spec.name          = 'soupcms-site'
  spec.version       = SoupCMS::Site::VERSION
  spec.authors       = ['Sunit Parekh']
  spec.email         = ['parekh.sunit@gmail.com']
  spec.description   = %q{soupCMS website}
  spec.summary       = %q{soupCMS website using soupCMS framework}
  spec.homepage      = 'http://www.soupcms.com/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib','ui']

end
