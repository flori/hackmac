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
    'tags', '.bundle', '.DS_Store', '.byebug_history'
  readme      'README.md'

  dependency  'tins',           '~>1.14'
  dependency  'term-ansicolor', '~>1.3'
  dependency  'complex_config'
  dependency  'amatch'
  dependency  'plist'
  dependency  'tabulo'
end
