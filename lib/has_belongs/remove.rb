module HasBelongs
  class Remove

    def find_add_foreign_key(file = "db/schema.rb")
      foreign_keys = []
      File.open(file) do |file|
        file.find_all do |line|
          if line.include?("add_foreign_key")
            foreign_keys << line.strip
          end
        end
        foreign_keys
      end
    end

    def find_models_in_schema(file = "db/schema.rb")
      child_parent_array = []
      words = find_add_foreign_key(file)
      words.each do |word|
        word_array = word.split('"')
        child_parent = word_array.values_at(* word_array.each_index.select { |item| item.odd? })
        child_parent_array << child_parent
      end
      child_parent_array
    end

    def set_parent_file(filepath = 'app/models/', file = "db/schema.rb")
      files_hash = {}
      relationships = find_models_in_schema(file)
      relationships.each do |relationship|
        singularized_parent = ActiveSupport::Inflector.singularize(relationship[1])
        file_path = filepath + singularized_parent + '.rb'
        files_hash[file_path] = relationship[0]
      end
      files_hash
    end

    def non_existing_relationships(filepath = 'app/models/', file = "db/schema.rb")
      deleted_relationships = []
      model_files = set_parent_file(filepath, file)
      model_files.each do |file, child|
        if !File.open(file).each_line.any? do |line|
          line.include?("has_many :#{child}")
          end
          deleted_relationships << [file, child]
        end
      end
      deleted_relationships
    end

    def generate_migration(filepath = 'app/models/', file = "db/schema.rb")
      output = []
      remove_relationships = non_existing_relationships(filepath, file)
      remove_relationships.each do |relationship|
        file_string = relationship[0].split("/").last
        parent = file_string.slice(0, (file_string.length - 3))
        output << "bin/rails g migration Remove#{parent.capitalize}RefFrom#{relationship[1].capitalize} #{parent}:references"
      end
      output
    end

  end
end
