$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'comable/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable'
  s.version     = Comable::VERSION
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/hyoshida/comable#comable'
  s.summary     = 'Comable provides a simple way to add e-commerce features to your Ruby on Rails application.'
  s.description = 'Comable provides a simple way to add e-commerce features to your Ruby on Rails application.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'comable_core'
  s.add_dependency 'comable_backend'
end
