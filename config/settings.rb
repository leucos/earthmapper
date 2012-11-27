module EarthMapper
  include Ramaze::Optioned

  options.dsl do
    o 'The base application URL', :myurl, 'http://localhost:7000/'
    o 'Cache path', :cachedir, '/home/leucos/.earthmapper/cache/'
    o 'Backend list', :backends, [ { :name =>  'geoportail',
                                     :description => 'France' } ]
  end
end
