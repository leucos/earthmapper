# This file contains your application, it requires dependencies and necessary parts of 
# the application.
#
# It will be required from either `config.ru` or `start.rb`
require 'rubygems'
require 'ramaze'
require 'redis'

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [__DIR__]

# Load modules
require __DIR__('modules/init')

EarthMapper.read_config

# Create cache
CACHE  = EarthMapper::Cache.new

# Create queue to distribute work to grabbers pool
#Grabber.new

EarthMapper.write_config
