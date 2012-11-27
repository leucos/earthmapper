# encoding: utf-8

require 'rgeo'

module Geoportail    
  class Controller < Ramaze::Controller
    map '/geoportail'

    layout do |path|
      if path === 'index'
        :default
      else
        :kml
      end
    end

    before_all do
      response['Content-Type'] = 'application/vnd.google-earth.kml+xml' 
    end

    # provide(:kml, :engine => :etanni, :type => 'application/vnd.google-earth.kml+xml') do |action, value|
    #   Ramaze::Log.info "In provide kml"
    #   @content = value
    # end

    def index
      # Returns mail KML with territories/layer list
      @title = 'Geoportail area'
      # TODO: create a KML view
      Ramaze::Log.info "In provide index"

      #render_view(:indexkml)
    end

    def kml
      # Returns main KML with territories/layer list
      @title = 'Geoportail area'
      @key = request.params["key"]
    end

    ## 
    # Returns an overlay KML with a tile list
    #
    def overlay
      @tileset = Array.new
      @key = request.params["key"]

      # TODO: complain unless key

      args = request.subset(:BBOX, :territory, :layer, :key)
      # We need to compute best zoom level here and return tile list
      # BBOX is WSEN
      w,s,e,n = args["BBOX"].split(/,/).map {|x| x.to_f }

      # TODO : find best zoom level
      zoom = Geoportail::find_zoom(n,w,s,e)
      Ramaze::Log.info "computed best zoom : #{zoom}"

      # TODO : find row, col for top left tile
      # TODO : find row col for bottom right tile
      nw = Geoportail::coords2tile(n,w,zoom)
      se = Geoportail::coords2tile(s,e,zoom)

      # TODO : loop and add all tiles
      Ramaze::Log.info "%s %s %s %s => (%s,%s) -> (%s,%s)" % [ w,s,e,n,nw[0],nw[1],se[0],se[1] ]


      nw[0].upto(se[0]) do |r|
        nw[1].upto(se[1]) do |c|
          Ramaze::Log.info "fetching %s %s %s %s %s" % [args['key'], args['layer'], r, c, zoom]
          @tileset << Geoportail::Tile.new(args['key'], args['layer'], r, c, zoom)
        end
      end
    end

    ##
    # Returns tile for specific territory, layer, and position
    #
    # @param [String] territory Set which territory to use
    # @param [String] later Set layer to use
    # @param [Int] x x coordinate for tile
    # @param [Int] y y coordinate for tile
    # @param [Int] z z zoom level for tile
    #
    # @returns [String] URL for tile
    def tile(territory, layer, x, y, z)
      t = CACHE.fetch()
    end

    private

  end
end