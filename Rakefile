# vim: set filetype=ruby et sw=2 ts=2:

require 'gem_hadar'

GemHadar do
  name        'hackmac'
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "http://github.com/flori/#{name}"
  summary     'Some useful tools for working with a Hackintosh'
  description 'This ruby gem provides some useful tools for working with a Hackintosh.'
  bindir      'bin'
  executables Dir['bin/*'].map(&File.method(:basename))
  test_dir    'tests'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', '.rvmrc', '.AppleDouble',
    'tags', '.bundle', '.DS_Store', '.yardoc', 'doc'
  package_ignore '.gitignore', '.contexts', '.github'

  readme      'README.md'

  github_workflows(
    'static.yml' => {}
  )

  dependency  'tins',           '~>1.14'
  dependency  'term-ansicolor', '~>1.10'
  dependency  'graphina',       '~>0.3'
  dependency  'complex_config'
  dependency  'amatch'
  dependency  'plist'
  dependency  'tabulo'
  dependency  'search_ui'
  dependency  'hashie'
  development_dependency 'debug'

  licenses << 'MIT'
end
