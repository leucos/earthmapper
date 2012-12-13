
# module EarthMapper
#   Gemspec = Gem::Specification::load(
#     File.expand_path('../earth_mapper.gemspec', __FILE__)
#   )
# end


task :default => "server:start"

namespace :server do
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
  desc "Start server"
  task :start do
    sh "bundle exec ruby start.rb"
  end
  desc "Console"
  task :console do
    sh "bundle exec irb -r ./app.rb" 
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

  task :zip do
    sh "git archive --format zip --output ../earthmapper-$(git describe --always --tag).zip master --prefix earthmapper/"
  end
end # namespace :build
