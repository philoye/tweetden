$LOAD_PATH << File.dirname(__FILE__)

require 'application'

App.set :run, false

run App
