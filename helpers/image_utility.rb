#
# ImageUtility module that handles the various methods for interfacing with
# rmagick and amazon S3 to save and retrieve files
#

require 'aws-sdk'

module ImageUtility

	class ImageHelper

		@aws_s3 = nil
		@bucket = nil

		def initialize
			#create the aws connection
			@aws_s3 = AWS::S3.new(
				:access_key_id => ENV['aws_access_key'],
				:secret_access_key => ENV['aws_access_secret'])
			# Get the aws bucket where files to use later
			unless @aws_s3.nil?
				@bucket = @aws_s3.buckets[ENV['aws_bucket']]
			end
		end

		# Perform the conversion on the image and then pass it back
		def resizeImage(img_path)
			unless img_path.nil?
				img_stream = Magick::Image.read(img_path)[0]
				img_stream.minify
			end
		end

		# Get all the information for the tempfile that was uploaded
		def getFile(html_params)
			unless html_params.nil?
				file = html_params[:tempfile]
			end
		end

		#save the image to amazon s3 (only for individual files	)
		def saveFile(img_name,img_file)
			unless img_file.nil? && img_name.nil?
				if !@bucket.nil? && @bucket.exists?
					@bucket.objects[img_name].write(:data => img_file.to_blob)
				end
			end
		end

		#get the file from s3
		def retrieveFile(key)
			unless key.nil?
				if !@bucket.nil? && @bucket.exists?
					aws_obj = @bucket.objects[key].read
				end
				return aws_obj
			end
		end

		#delete the file after processing
		def deleteFile(key)
			unless key.nil?
				if @bucket.exists? && !@bucket.nil?
					@bucket.objects[key].delete()
				end
			end
		end

	end
end
