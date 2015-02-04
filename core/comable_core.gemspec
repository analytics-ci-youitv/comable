version = File.read(File.expand_path('../../COMABLE_VERSION', __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable_core'
  s.version     = version
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/hyoshida/comable#comable'
  s.summary     = 'Provide core functions for Comable.'
  s.description = 'Provide core functions for Comable.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile']

  s.add_dependency 'rails', '>= 3.2.0'
  s.add_dependency 'devise', '~> 3.2'
  s.add_dependency 'enumerize'
  s.add_dependency 'state_machine'
  s.add_dependency 'ancestry'
  s.add_dependency 'acts_as_list'
  s.add_dependency 'carrierwave'
  s.add_dependency 'cancancan', '~> 1.10'
end
