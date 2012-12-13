
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

    # the index action is called automatically when no other action is specified
    def index
      @backends = EarthMapper.options.backends
    end

    def kml
      @backends = EarthMapper.options.backends
    end
  end
end
