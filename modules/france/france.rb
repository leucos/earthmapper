# coding: utf-8

# require 'rgeo'

module France

  Territory = { 
    # "ANF" => { :name => "Antilles Françaises",      :kx => 6160807.2519099, :ky => 6378137.0000000, :north => , :south =>, :west => , :east => },
    # "ASP" => { :name => "Saint Paul Amsterdam",     :kx => 5026040.5439769, :ky => 6378137.0000000, :north => , :south =>, :west => , :east => },
    # "CRZ" => { :name => "Ile Crozet",               :kx => 4430626.2549842, :ky => 6378137.0000000, :north => , :south =>, :west => , :east => },
    "FXX" => { :name => "France métropolitaine",    :kx => 4390419.7883516, :ky => 6378137.0000000, :north => 51.1443875274589686, :south => 40.867596209619862, :west => -6.2453997412196181, :east => 10.864590140082749 },
    # "GUF" => { :name => "Guyane Française",         :kx => 6362600.1788320, :ky => 6378137.0000000, :north => , :south =>, :west => , :east => },
    # "KER" => { :name => "Iles Kerguelen",           :kx => 4142268.6266325, :ky => 6378137.0000000, :north => , :south =>, :west => , :east => },
    # "MYT" => { :name => "Mayotte",                  :kx => 6238759.4037015, :ky => 6378137.0000000, :north => , :south =>, :west => , :east => },
    # "NCL" => { :name => "Nouvelle Calédonie",       :kx => 5913705.6486150, :ky => 6378137.0000000, :north => , :south =>, :west => , :east => },
    # "PYF" => { :name => "Polynésie Française",      :kx => 6160807.2519099, :ky => 6378137.0000000, :north => , :south =>, :west => , :east => },
    "REU" => { :name => "Réunion",                  :kx => 5954503.8607176, :ky => 6378137.0000000, :north => -20.85, :south => -21.40, :west => 55.20, :east => 55.90},
    # "SPM" => { :name => "Saint Pierre et Miquelon", :kx => 4349878.9742539, :ky => 6378137.0000000, :north => , :south =>, :west => , :east => },
    # "WLF" => { :name => "Wallis et Futuna",         :kx => 6188679.0727028, :ky => 6378137.0000000, :north => , :south =>, :west => , :east => },
  }

  Layers = { 
    "maps"      => { :name => "GEOGRAPHICALGRIDSYSTEMS.MAPS", :description => "Maps" },
    "aerial"    => { :name => "ORTHOIMAGERY.ORTHOPHOTOS", :description => "Aerial photo" },
    #"elevation" => { :name => "ELEVATION.SLOPS", :description => "Elevation" }
  }

  # Zoom = [ 156543.033928, 78271.516964, 39135.758482, 19567.879241, 9783.939621, 
  #          4891.969810, 2445.984905, 1222.992453, 611.496226, 305.748113, 
  #          152.874057, 76.437028, 38.218514, 19.109257, 9.554629, 4.7773142678, 
  #          2.388657, 1.194329, 0.597164, 0.298582, 0.149291, 0.074646 ]


  Zoom = [ 156543.0339280410, 78271.5169640205, 39135.7584820102, 19567.8792410051, 9783.9396205026, 
            4891.9698102513, 2445.9849051256, 1222.9924525628, 611.4962262814, 305.7481131407, 
            152.8740565704, 76.4370282852, 38.2185141426, 19.1092570713, 9.5546285356, 4.7773142678, 
            2.3886571339, 1.1943285670, 0.5971642835, 0.2985821417, 0.1492910709, 0.0746455354 ]

  #SourceSystem = RGeo::Cartesian.factory(:proj4 => '+init=epsg:4326')

  Parameters = { :x0 => -20037508, :y0 => 20037508 }

  MaxTiles = 9

  def France.coords2tile(lat, lon, z)
    lon = lon * Math::PI / 180
    lat = lat * Math::PI / 180

    x = EarthMapper::Radius * lon
    y = EarthMapper::Radius * Math.log(Math.tan(lat/2 + Math::PI/4))
    
    x = x-Parameters[:x0]
    y = Parameters[:y0]-y

    f = 256 * France::Zoom[z]
    row = (y / f).to_i
    col = (x / f).to_i

    [row, col]
  end

  def France.tile2coords(row, col, z)    
    f = 256 * France::Zoom[z]
   
    y = row * f
    x = col * f

    x = x + Parameters[:x0]
    y = Parameters[:y0] - y

    lon = x/EarthMapper::Radius
    lon = lon*180/Math::PI
    lat = 2 * Math.atan(Math.exp(y/EarthMapper::Radius)) - Math::PI/2
    lat = lat*180/Math::PI

    [lon, lat]
  end

  def France.check(lat, lon, z)
    res = Array.new
    res = coords2tile(lat,lon,z)

    puts "t2c(%s,%s,%s) => %s %s " % [lat, lon, z, *res]
    puts "c2t(%s,%s,%s) => %s %s " % [res[0], res[1], z, *tile2coords(*res, z)]
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