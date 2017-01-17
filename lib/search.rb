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

end