
# coding: utf-8

module EarthMapper
  class Controller < Ramaze::Controller
    include Ramaze::Traited
    layout :default
    helper :xhtml
    engine :etanni

    map '/'

    layout do |path|
      if path === 'index'
        :default
      else
        :kml
      end
    end

    before(:kml) do
      response['Content-Type'] = 'application/vnd.google-earth.kml+xml'
      response['Content-Disposition'] = 'attachment; filename="earthmapper.kml"'
    end

    def index
      @title = "EarthMapper"
      @backends = EarthMapper.options.backends

      if request.params.count > 0
        form = request.subset(:myurl, :cache_dir, :user_agent, :referrer, :grabbers)
        puts form.inspect
        [:myurl, :cache_dir, :user_agent, :referrer, :grabbers].each do |k|
          EarthMapper.options.send("#{k.to_s}=", form[k.to_s])
        end
      end
      
      EarthMapper.write_config
    end    

    def kml
      @backends = EarthMapper.options.backends
      @title = "EarthMapper"
    end
  end
end
