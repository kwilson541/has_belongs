require 'active_support'
require 'active_support/inflector'

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
				if File.open(file).each_line.any?{|line| line.include?("has_many") || line.include?("has_one") || line.include?("has_and_belongs_to_many")}
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
			@parent_model = ""
			@child_models = []
			@has_and_belongs_child_models = []
			migrations = []
			files.each do |file|
				File.open(file).each_line { |line|
					class_has(line)
					class_belongs(line)
				}
				@child_models.each do |model|
					relationship = "Add#{@parent_model}RefTo#{model.capitalize}"
					if !relationship_exist?(relationship)
						migrations << "bin/rails g migration #{relationship} #{@parent_model.downcase}:references"
					end
				@child_models = []
				end
				@has_and_belongs_child_models.each do |model|
					relationship = "CreateJoinTable "
			@parent_model = ""
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
				@parent_model = line.gsub(/(class)|( < ApplicationRecord)/, "").strip
			end
		end

		def class_belongs(line)
			if line =~ /(has_many :|has_one :)/
				words = line.scan(/\w+/)
				@child_models << ActiveSupport::Inflector.singularize(words[1])
			elsif line =~ /(has_and_belongs_to_many :)/
				words = line.scan(/\w+/)
				@has_and_belongs_child_models << ActiveSupport::Inflector.singularize(words[1])
			end
		end

	end
end
