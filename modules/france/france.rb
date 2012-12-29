# coding: utf-8

require 'rgeo'

module France

  Territory = { 
    # "ANF" => { :name => "Antilles Françaises",      :kx => 6160807.2519099, :ky => 6378137.0000000, :north => 18.18, :south => 11.7, :west => -64, :east => -59},
    # "ASP" => { :name => "Saint Paul Amsterdam",     :kx => 5026040.5439769, :ky => 6378137.0000000, :north => -36, :south => -40, :west => 76, :east => 79},
    # "CRZ" => { :name => "Ile Crozet",               :kx => 4430626.2549842, :ky => 6378137.0000000, :north => -44, :south => -48, :west => 47, :east => 55},
    "FXX" => { :name => "France métropolitaine",    :kx => 4390419.7883516, :ky => 6378137.0000000, :north => 51.1443875274589686, :south => 40.867596209619862, :west => -6.2453997412196181, :east => 10.864590140082749 },
    # "GUF" => { :name => "Guyane Française",         :kx => 6362600.1788320, :ky => 6378137.0000000, :north => 11.5, :south => -4.3, :west => -62.1, :east => -46},
    # "KER" => { :name => "Iles Kerguelen",           :kx => 4142268.6266325, :ky => 6378137.0000000, :north => -45, :south => -53, :west => 62, :east => 76},
    # "MYT" => { :name => "Mayotte",                  :kx => 6238759.4037015, :ky => 6378137.0000000, :north => 3, :south => -17.5, :west => 40, :east => 56},
    # "NCL" => { :name => "Nouvelle Calédonie",       :kx => 5913705.6486150, :ky => 6378137.0000000, :north => -17.1, :south => -24.3, :west => 160, :east => 170},
    # "PYF" => { :name => "Polynésie Française",      :kx => 6160807.2519099, :ky => 6378137.0000000, :north => 11, :south => -28.2, :west => -160, :east => -108 },
    # "REU" => { :name => "Réunion",                  :kx => 5954503.8607176, :ky => 6378137.0000000, :north => -20.782659, :south => -21.482416, :west => 55.167777, :east => 55.929337 },
    # "SPM" => { :name => "Saint Pierre et Miquelon", :kx => 4349878.9742539, :ky => 6378137.0000000, :north => 47.177344798969699, :south => 46.724584912620614, :west => -56.437241274288482, :east => -56.041481070053059},
    # "WLF" => { :name => "Wallis et Futuna",         :kx => 6188679.0727028, :ky => 6378137.0000000, :north => -12.8, :south => -14.6, :west => -178.5, :east => -175.8 },
  }

  Layers = { 
    "maps"      => { :name => "GEOGRAPHICALGRIDSYSTEMS.MAPS", :description => "Maps" },
    #"aerial"    => { :name => "ORTHOIMAGERY.ORTHOPHOTOS", :description => "Aerial photo" },
    #"elevation" => { :name => "ELEVATION.SLOPS", :description => "Elevation" }
  }

  Zoom = [ 156543.0339280410, 78271.5169640205, 39135.7584820102, 19567.8792410051, 9783.9396205026, 
            4891.9698102513, 2445.9849051256, 1222.9924525628, 611.4962262814, 305.7481131407, 
            152.8740565704, 76.4370282852, 38.2185141426, 19.1092570713, 9.5546285356, 4.7773142678, 
            2.3886571339, 1.1943285670, 0.5971642835, 0.2985821417, 0.1492910709, 0.0746455354 ]

  SourceSystem = RGeo::Cartesian.factory(:proj4 => '+init=epsg:4326')

  Parameters = { :x0 => -20037508, :y0 => 20037508 }

  MaxTiles = 9

  def France.coords2tile(lat, lon, z)
    destination = RGeo::Cartesian.factory(:proj4 => '+init=epsg:3857')
    spoint = SourceSystem.point(lon, lat)
    dpoint = RGeo::Feature.cast(spoint, :factory => destination, :project => true)

    x = dpoint.x-Parameters[:x0]
    y = Parameters[:y0]-dpoint.y

    f = 256 * France::Zoom[z]
    row = (y / f).to_i
    col = (x / f).to_i

    [row, col]
  end

  def France.tile2coords(row, col, z)
    destination = RGeo::Cartesian.factory(:proj4 => '+init=epsg:3857')
    
    f = 256 * France::Zoom[z]
   
    y = row * f
    x = col * f

    x = x + Parameters[:x0]
    y = Parameters[:y0] - y

    dpoint = destination.point(x, y)
    spoint = RGeo::Feature.cast(dpoint, :factory => SourceSystem, :project => true)

    [spoint.x, spoint.y]
  end

  def France.find_zoom(north, west, south, east)
    sqrmaxtiles = France::MaxTiles
    pixpertile = 256

    #factory = RGeo::Geographic.spherical_factory(:srid => 4326)

    # Find horizontal/vertical distances
    hdist = EarthMapper.distance(north,west,north,east)
    vdist = EarthMapper.distance(north,west,south,west)

    # Find biggest distance
    dist = (hdist > vdist ? hdist : vdist)

    # calculer zoom
    z = dist / (pixpertile * sqrmaxtiles)

    Ramaze::Log.info "distance : #{dist}, z = #{z}"

    # Find the index of the best zoom in Zoom array
    Zoom.index(Zoom.reject { |x| x < z }.last) 
  end
end
