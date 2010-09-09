Gem::Specification.new do |s|
  s.name = "device_space_left"
  s.version = "0.1.1"
  s.author = "Guillaume Luccisano"
  s.email = "guillaume.luccisano@gmail.com"
  s.homepage = "http://github.com/kwi/device_space_left"
  s.summary = "Small ruby gem/plugin giving you the ability to retrieve easily the space available on your devices"
  s.description = "device_space_left is a small plugin giving you the ability to retrieve easily the space available on your devices"

  s.files = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end