require 'yaml'
require 'erb'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

CONFIG = YAML.load(ERB.new(File.read(File.expand_path('config/config.yml'))).result)
