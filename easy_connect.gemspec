require_relative "lib/easy_connect/version"

Gem::Specification.new do |spec|
  spec.name        = "easy_connect"
  spec.version     = EasyConnect::VERSION
  spec.authors     = [ "tylercschneider" ]
  spec.email       = [ "tylercschneider@gmail.com" ]
  spec.homepage    = "https://github.com/DYB-Development/easy_connect"
  spec.summary     = "A canvas where an admin draws lines between items a Rails host app hands in."
  spec.description = "EasyConnect stores boards of items a host app creates, lets an admin draw lines between them, and gives the host the lines as JSON."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.3"
end
