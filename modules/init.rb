require __DIR__('earth_mapper')

EarthMapper.options.backends.each do |b|
  Ramaze::Log.info("Loading backend #{b}")
  require __DIR__("#{b[:name]}")
end
