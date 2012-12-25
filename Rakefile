require 'rake'
require 'rake/clean'
require 'date'
require 'time'

RAMAZE_ROOT = File.expand_path(File.dirname(__FILE__))

CLEAN.include %w[
  **/.*.sw?
  *.gem
  .config
  **/*~
  **/{vttroute-*.db,cache.yaml}
  *.yaml
  pkg
  rdoc
  public/doc
  *coverage*
]

Dir.glob(File.expand_path('../task/*.rake', __FILE__)).each do |f|
  import(f)
end

task :default => "server:start"

namespace :build do
  desc 'Builds a new Gem'
  task :gem do
    gem_path     = File.expand_path('../', __FILE__)
    gemspec_path = File.join(
      gem_path,
      "#{EarthMapper::Gemspec.name}-" \
        "#{EarthMapper::Gemspec.version.version}.gem"
    )

    Dir.exist?(File.join(gem_path, 'pkg')) or mkdir File.join(gem_path, 'pkg')

    pkg_path = File.join(
      gem_path,
      'pkg',
      "#{EarthMapper::Gemspec.name}-" \
        "#{EarthMapper::Gemspec.version.version}.gem"
    )

    # Build and install the gem
    sh('gem', 'build'     , File.join(gem_path, 'earth_mapper.gemspec'))
    sh('mv' , gemspec_path, pkg_path)
  end

  task :zip do
    sh "git archive --format zip --output ../earthmapper-$(git describe --always --tag).zip master --prefix earthmapper/"
  end
end # namespace :build
