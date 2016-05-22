$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bold-flickr"
  s.version     = '0.1.0'
  s.authors     = ["Jens Kraemer"]
  s.email       = ["jk@jkraemer.net"]
  s.homepage    = 'http://github.com/bold-app/bold-flickr'
  s.summary     = "Flickr plugin for Bold"
  s.description = "Flickr plugin for Bold"
  s.license     = "AGPL"

  s.files = Dir["{app,config,lib}/**/*", "LICENSE", "README.md"]
  s.test_files = Dir["test/**/*"]

#  s.add_dependency 'flickraw'
end
