version = File.read(File.expand_path('../../COMABLE_VERSION', __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable_backend'
  s.version     = version
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/hyoshida/comable#comable'
  s.summary     = 'Provide backend functions for Comable.'
  s.description = 'Provide backend functions for Comable.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile']

  s.add_dependency 'comable_core', version

  s.add_dependency 'rails', '>= 3.2.0'
  s.add_dependency 'slim-rails'
end
