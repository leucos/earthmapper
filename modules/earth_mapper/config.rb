require 'ostruct'
require 'yaml'
require 'json'

module EarthMapper
  # Default config location
  Location = File.join(File.expand_path('~'),'.earthmapper')

  Conf =  OpenStruct.new ({
    "myurl"      => 'http://localhost:7000/',
    "cache_dir"  => File.join(File.expand_path('~'),'.earthmapper','cache'),
    "user_agent" => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.14 Safari/537.17',
    "referrer"   => 'localhost',
    "grabbers"   => 8,
    "backends"   => { "france" => { :description => "France" }}
  })

  def self.read_config
    custom = nil
    
    begin
      open(File.join(Location, 'config.cfg')) { |f| custom = YAML.load(f) }
    rescue
      FileUtils.mkdir_p Location, :mode => 0755
    end

    # "Symbolification" of keys
    if custom
      Conf.marshal_load(Conf.marshal_dump.merge!(custom.inject({ }) { |h, (k,v)| h[k.to_sym] = v; h })) 
    end
  end

  def self.options
    Conf
  end

  def self.write_config
    File.open(File.join(Location, 'config.cfg'), "w"){ |f| YAML.dump(Conf.marshal_dump, f) }
  end

end

