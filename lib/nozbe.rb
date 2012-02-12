# coding:utf-8

require 'yaml'

module NozbeWrapper

  class NozbeException < StandardError; end

  SETTING = {}

  #
  # Setting to use Nozbe
  #
  def self.setting
    config_file = File.join( File.dirname( __FILE__ ), '..', 'config', 'config.yaml' )

    YAML.load_file( config_file ).each do |key,val|
      SETTING[ key.to_sym ] = val
    end

    required_items = [:api_key]
    raise NozbeException, "Settings should not include nil." if required_items.index {|t| !SETTING[t] }
  end

end

NozbeWrapper.setting

# gems
require 'nozbe'

# require all
def require_all( path )
  glob = File.join( File.dirname(__FILE__), path, '*.rb' )
  Dir[glob].each do |f|
    require f
  end
end

require_all( 'nozbe' )


