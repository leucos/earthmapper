require __DIR__('earth_mapper/init')
Ramaze.options.views.push(File.join("modules", "earth_mapper", 'view'))

EarthMapper.options.backends.each do |b|
  Ramaze::Log.info("Loading backend #{b[:name]} (#{b[:description]})")
  require File.join(__DIR__("#{b[:name]}"),"init")

  viewpath = File.join("modules", b[:name], 'view')  
  Ramaze.options.views.push(viewpath)
end

Ramaze::Log.info Ramaze.options.views.inspect