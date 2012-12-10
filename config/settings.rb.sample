module EarthMapper
  include Ramaze::Optioned

  options.dsl do
    o 'The base application URL', :myurl, 'http://localhost:7000/'
    o 'Cache directory', :cache_dir, File.join(File.expand_path('~'),'.earthmapper')
    o 'Backend list', :backends, [ { :name =>  'france', :description => 'France' } ]
    o 'User-Agent for web requests', :user_agent, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.14 Safari/537.17'
    o 'Referer for web requests', :referrer, 'localhost'
    o 'Grabbing workers', :grabbers, 8
  end
end
