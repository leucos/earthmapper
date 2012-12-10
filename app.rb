# This file contains your application, it requires dependencies and necessary parts of 
# the application.
#
# It will be required from either `config.ru` or `start.rb`
require 'rubygems'
require 'ramaze'

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [__DIR__]

# Get main setings
require __DIR__('config/settings.rb')

# Get backends settings
EarthMapper.options.backends.each do |b|
  Ramaze::Log.info("Loading settings for backend #{b[:name]} (#{b[:description]})")
  require File.join(__DIR__('config'), b[:name])
end


# Initialize controllers and modules
#require __DIR__('controller/init')
require __DIR__('modules/init')

CACHE = EarthMapper::Cache.new

GQUEUE = GrabPool.start(EarthMapper.options.grabbers)
