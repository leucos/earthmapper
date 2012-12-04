
module EarthMapper
  Gemspec = Gem::Specification::load(
    File.expand_path('../earth_mapper.gemspec', __FILE__)
  )
end

begin
  require 'bundler'
rescue
  sh 'gem install bundler'
ensure
  sh 'bundle'
end

task :default => "server:start"

namespace :server do
  desc "Start everything."
  multitask :start => [ 'server:web', 'server:grabber' ]

  task :web do
    #sh "bundle exec ruby bin/earthmapper.rb"
    sh "bundle exec ramaze start -s thin"
  end

  task :grabber do
    sh "bundle exec ruby bin/grabber.rb"
  end
end

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
end # namespace :build

