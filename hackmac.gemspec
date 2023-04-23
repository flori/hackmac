# -*- encoding: utf-8 -*-
# stub: hackmac 1.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "hackmac".freeze
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Florian Frank".freeze]
  s.date = "2023-04-23"
  s.description = "This ruby gem provides some useful tools for working with a Hackintosh.".freeze
  s.email = "flori@ping.de".freeze
  s.executables = ["efi".freeze, "gfxmon".freeze, "usb".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "lib/hackmac.rb".freeze, "lib/hackmac/asset_tools.rb".freeze, "lib/hackmac/config.rb".freeze, "lib/hackmac/disks.rb".freeze, "lib/hackmac/github_source.rb".freeze, "lib/hackmac/kext.rb".freeze, "lib/hackmac/kext_upgrader.rb".freeze, "lib/hackmac/oc.rb".freeze, "lib/hackmac/oc_upgrader.rb".freeze, "lib/hackmac/oc_validator.rb".freeze, "lib/hackmac/plist.rb".freeze, "lib/hackmac/url_download.rb".freeze, "lib/hackmac/utils.rb".freeze, "lib/hackmac/version.rb".freeze]
  s.files = [".gitignore".freeze, "Gemfile".freeze, "README.md".freeze, "Rakefile".freeze, "VERSION".freeze, "bin/efi".freeze, "bin/gfxmon".freeze, "bin/usb".freeze, "hackmac.gemspec".freeze, "lib/hackmac.rb".freeze, "lib/hackmac/asset_tools.rb".freeze, "lib/hackmac/config.rb".freeze, "lib/hackmac/disks.rb".freeze, "lib/hackmac/github_source.rb".freeze, "lib/hackmac/hackmac.yml".freeze, "lib/hackmac/kext.rb".freeze, "lib/hackmac/kext_upgrader.rb".freeze, "lib/hackmac/oc.rb".freeze, "lib/hackmac/oc_upgrader.rb".freeze, "lib/hackmac/oc_validator.rb".freeze, "lib/hackmac/plist.rb".freeze, "lib/hackmac/url_download.rb".freeze, "lib/hackmac/utils.rb".freeze, "lib/hackmac/version.rb".freeze]
  s.homepage = "http://github.com/flori/hackmac".freeze
  s.rdoc_options = ["--title".freeze, "Hackmac - Some useful tools for working with a Hackintosh".freeze, "--main".freeze, "README.md".freeze]
  s.rubygems_version = "3.3.26".freeze
  s.summary = "Some useful tools for working with a Hackintosh".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<gem_hadar>.freeze, ["~> 1.12.0"])
    s.add_development_dependency(%q<debug>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<tins>.freeze, ["~> 1.14"])
    s.add_runtime_dependency(%q<term-ansicolor>.freeze, ["~> 1.3"])
    s.add_runtime_dependency(%q<complex_config>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<amatch>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<plist>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<tabulo>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<search_ui>.freeze, [">= 0"])
  else
    s.add_dependency(%q<gem_hadar>.freeze, ["~> 1.12.0"])
    s.add_dependency(%q<debug>.freeze, [">= 0"])
    s.add_dependency(%q<tins>.freeze, ["~> 1.14"])
    s.add_dependency(%q<term-ansicolor>.freeze, ["~> 1.3"])
    s.add_dependency(%q<complex_config>.freeze, [">= 0"])
    s.add_dependency(%q<amatch>.freeze, [">= 0"])
    s.add_dependency(%q<plist>.freeze, [">= 0"])
    s.add_dependency(%q<tabulo>.freeze, [">= 0"])
    s.add_dependency(%q<search_ui>.freeze, [">= 0"])
  end
end
