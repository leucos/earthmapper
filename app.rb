# This file contains your application, it requires dependencies and necessary parts of 
# the application.
#
# It will be required from either `config.ru` or `start.rb`
require 'rubygems'
require 'ramaze'

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [__DIR__]

# Get setings
require __DIR__('config/settings.rb')

# Initialize controllers and modules
#require __DIR__('controller/init')
require __DIR__('modules/init')

CACHE = EarthMapper::Cache.new
