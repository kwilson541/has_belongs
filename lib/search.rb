class Search

	def return_files(filepath = "app/models")
		if Dir.exist?(filepath)
			search_path = filepath + "/*.rb"
			Dir.glob(search_path)
		else
			raise "Filepath does not exist"
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
		files_with_has_many
	end

end