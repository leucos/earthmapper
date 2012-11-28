path = File.expand_path('../', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'earthmapper'
  s.version     = '0.0.10'
  s.date        = '2012-12-28'
  s.authors     = ['Michel Blanc']
  s.email       = 'mb@mbnet.fr'
  s.summary     = 'GoogleEarth Tile Server'
  s.homepage    = 'https://github.com/leucos/earthmapper'
  s.description = s.summary
  s.files       = `cd #{path}; git ls-files`.split("\n").sort

  s.add_dependency('ramaze', ['>= 2011.07.25'])
  s.add_dependency('rgeo', ['>= 0.3.19'])
  s.add_dependency('celluloid-io', ['~> 0.12.0'])
  s.add_dependency('thin', ['>= 1.4.1'])
end
