require 'ostruct'
require 'yaml'

module EarthMapper
  Conf =  OpenStruct.new ({
    "myurl"      => 'http://localhost:7000/',
    "cache_dir"  => File.join(File.expand_path('~'),'.earthmapper','cache'),
    "user_agent" => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.14 Safari/537.17',
    "referrer"   => 'localhost',
    "grabbers"   => 8,
    "backends"   => { "france" => { :description => "France" }},
  })

  def self.read_config(file)
    custom = ""
    open(file) { |f| custom = YAML.load(f) }

     Conf.marshal_load(Conf.marshal_dump.merge!(custom.inject({ }) { |h, (k,v)| h[k.to_sym] = v; h }))
  end

  def self.options
    Conf
  end


end
