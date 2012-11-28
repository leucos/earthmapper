require __DIR__('earth_mapper/init')

EarthMapper.options.backends.each do |b|
  Ramaze::Log.info("Loading backend #{b[:name]} (#{b[:description]})")
  require File.join(__DIR__("#{b[:name]}"),"init")

  viewpath = File.join("modules", b[:name], 'view')
  Ramaze::Log.info("Pushing view path #{viewpath}")
  Ramaze.options.views.push(viewpath)
  Ramaze::Log.info(Ramaze.options.views.inspect)

end
