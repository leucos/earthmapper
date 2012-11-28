module EarthMapper
  include Ramaze::Optioned

  options.dsl do
    o 'The base application URL', :myurl, 'http://localhost:7000/'
    o 'Cache directory', :cache_dir, '/home/leucos/.earthmapper/cache/'
    o 'Data diretory path', :data_dir, '/home/leucos/.earthmapper/'    
    o 'Backend list', :backends, [ { :name =>  'france', :description => 'France' } ]
  end
end
