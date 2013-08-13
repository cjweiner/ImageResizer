require 'rubygems'
require 'sinatra'

set :static, true
set :public_dir, 'public'


def resizeImage(tmpfile)
	unless tmpfile
		file.open()
	end
end

get '/' do
	erb :index
end

post '/upload' do
	content  = params['content']['file']
	@file = content
	puts @file
	erb:index
end
