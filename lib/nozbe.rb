# coding:utf-8
require 'yaml'

module Nozbe

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

Nozbe.setting
