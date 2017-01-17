class Search

	def return_files(filepath = "app/models")
		if Dir.exist?(filepath)
			search_path = filepath + "/*.rb"
			search_result = Dir.glob(search_path)
			if search_result.empty?
				raise "Could not find any files in #{filepath}"		
			else
				search_result		
			end
		else
			raise "#{filepath} does not exist"
		end
	end

	def return_has_many(filepath = "app/models")
		all_files = return_files(filepath)
		files_with_has_many = []
		all_files.each do |file|
			if File.open(file).each_line.any?{|line| line.include?("has_many")}
				files_with_has_many << file
			end
		end
		if files_with_has_many.empty?
			raise "No associations found"
		else
			files_with_has_many
		end
	end

	def generate_migration(filepath = "apps/models")
		files = return_has_many(filepath)
		@class_variable1 = ""
		@class_variable2 = ""
		migrations = []
		files.each do |file|
			File.open(file).each_line { |line|
				class_has(line)
				class_belongs(line)
			}
			migrations << "bin/rails g migration Add#{@class_variable1}RefTo#{@class_variable2.capitalize} #{@class_variable1.downcase}:references"
		end		
		migrations
	end


	private

	def class_has(line)		
		if line =~ /(class).*( < ApplicationRecord)/
			@class_variable1 = line.gsub(/(class)|( < ApplicationRecord)/, "").strip
		end
	end

	def class_belongs(line)
		if line =~ /(has_many :)/
			@class_variable2 = line.gsub(/(has_many :)|(s( |,)*.*)/, "").strip
		end
	end

end