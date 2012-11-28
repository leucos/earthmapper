# encoding: utf-8

require 'rgeo'

module France    
  class Controller < Ramaze::Controller
    map '/france'
    helper :xhtml

    layout do |path|
      if path === 'index'
        :default
      else
        :kml
      end
    end

    before(:kml, :overlay, :tile) do
      response['Content-Type'] = 'application/vnd.google-earth.kml+xml' 
    end

    # provide(:kml, :engine => :etanni, :type => 'application/vnd.google-earth.kml+xml') do |action, value|
    #   Ramaze::Log.info "In provide kml"
    #   @content = value
    # end

    def index
      # Returns mail KML with territories/layer list
      @title = 'France area'
      # TODO: create a KML view
      Ramaze::Log.info "In provide index"

      #render_view(:indexkml)
    end

    def kml
      # Returns main KML with territories/layer list
      @title = 'France area'
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

      # find best zoom level
      zoom = France::find_zoom(n,w,s,e)
      Ramaze::Log.info "computed best zoom : #{zoom}"

      # find row, col for top left tile
      # find row col for bottom right tile
      nw = France::coords2tile(n,w,zoom)
      se = France::coords2tile(s,e,zoom)

      # loop and add all tiles
      nw[0].upto(se[0]) do |r|
        nw[1].upto(se[1]) do |c|
          @tileset << France::Tile.new(args['key'], args['layer'], r, c, zoom)
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