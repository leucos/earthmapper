
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

    # the index action is called automatically when no other action is specified
    def index
      @backends = EarthMapper.options.backends
    end
    alias :kml :index

  end
end
