require __DIR__('earth_mapper/init')
Ramaze.options.views.push(File.join("modules", "earth_mapper", 'view'))

EarthMapper.options.backends.each do |b, content|
  Ramaze::Log.info("Loading backend #{b} (#{content[:description]})")
  require File.join(__DIR__("#{b}"),"init")

  viewpath = File.join("modules", b, 'view')  
  Ramaze.options.views.push(viewpath)
end

Ramaze::Log.info Ramaze.options.views.inspect