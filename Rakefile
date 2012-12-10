
module EarthMapper
  Gemspec = Gem::Specification::load(
    File.expand_path('../earth_mapper.gemspec', __FILE__)
  )
end

begin
  require 'bundler'
rescue LoadError
  print "Installing bundler..."
  sh 'gem install bundler --no-ri --no-rdoc'
  puts "done"
ensure
  puts "Installing required gems..."
  sh 'bundle --path vendor'
end

task :default => "server:start"

namespace :server do
  desc "Start server"
  task :start do
    sh "bundle exec ramaze start"
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

