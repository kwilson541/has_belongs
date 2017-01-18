module HasBelongs
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

		def generate_migration(filepath = "app/models")
			files = return_has_many(filepath)
			@class_variable1 = ""
			@class_variable2 = []
			migrations = []
			files.each do |file|
				File.open(file).each_line { |line|
					class_has(line)
					class_belongs(line)
				}
				@class_variable2.each do |element| 
					relationship = "Add#{@class_variable1}RefTo#{element.capitalize}"
					if !relationship_exist?(relationship)
						migrations << "bin/rails g migration #{relationship} #{@class_variable1.downcase}:references"
					end
				@class_variable2 = []
				end
			@class_variable1 = ""
			end
			migrations
		end

		def relationship_exist?(relationship, filepath = "db/migrate/*.rb")
			migration_files = Dir.glob(filepath)
			migration_files.each do |file|
				File.open(file).each_line.any? {|line| return true if line.include?(relationship)}
			end
			return false
		end


		private

		def class_has(line)
			if line =~ /(class).*( < ApplicationRecord)/
				@class_variable1 = line.gsub(/(class)|( < ApplicationRecord)/, "").strip
			end
		end

		def class_belongs(line)
			if line =~ /(has_many :)/
				@class_variable2 << line.gsub(/(has_many :)|(s( |,)*.*)/, "").strip
			end
		end

	end
end
