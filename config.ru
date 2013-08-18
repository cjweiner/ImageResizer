require './main.rb'
require './helpers/image_utility.rb'
require './env' if File.exists?('env.rb')

run Sinatra::Application
