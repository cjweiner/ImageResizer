require 'rubygems'
require 'sinatra'
require 'RMagick'
require 'tempfile'
require 'aws-sdk'

include Magick


configure do
    enable :sessions
    set :static, true
	set :public_dir, 'public'
end

before do
	@image_helper = ImageUtility::ImageHelper.new
end

get '/' do
	erb :index
end

post '/upload' do
	content  = params['content']['file']
	file = content
	session[:type] = file[:type]
	session[:filename] = file[:filename]
	img = @image_helper.getFile(file)
	smallImg = @image_helper.resizeImage(img.path)
	#do this to avoid off chance someone uploads the same file name for two diff files
	session[:generatedname] = SecureRandom.urlsafe_base64
	puts session[:generatedname]
	@image_helper.saveFile(
		session[:generatedname],
		smallImg
	)
	redirect '/'
end

get '/download' do
	#retrieve by the random file name but make new file the original name
	file = @image_helper.retrieveFile(session[:generatedname])
	#cleanup the temp location of the file
	@image_helper.deleteFile(session[:generatedname])
	file_name = session[:filename].insert(session[:filename].rindex('.'),'(small)')
	response.headers['Content-Disposition'] = 'attachment; filename=' + file_name
	response.headers['Content-Type'] = session[:type]
	response.write(file)
end

require_relative './helpers/image_utility'
require_relative './env'
