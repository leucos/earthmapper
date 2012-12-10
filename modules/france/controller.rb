# encoding: utf-8

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
    end

    ## 
    # Returns an overlay KML with a tile list
    #
    def overlay
      @tileset = Array.new

      # TODO: complain unless key
      args = request.subset(:BBOX, :territory, :layer)

      # We need to compute best zoom level here and return tile list
      # BBOX is WSEN
      w,s,e,n = args["BBOX"].split(/,/).map {|x| x.to_f }

      # However, we want to restrict our search to the zone covered by the layer
      t = France::Territory[args["territory"]]

      Ramaze::Log.info("Requested NWSE bounds : %s %s %s %s" % [n,w,s,e] )
      n = [n, t[:north]].min 
      w = [w, t[:west]].max
      s = [s, t[:south]].max
      e = [e, t[:east]].min
      Ramaze::Log.info("Restricted NWSE bounds for territory %s : %s %s %s %s" % [args["territory"], n,w,s,e] )

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
          @tileset << France::Tile.new(France.options.key, args['layer'], r, c, zoom)
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