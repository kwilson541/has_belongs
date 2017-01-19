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
          line.include?("has_many :#{child}") || line.include?("has_one :#{child}")
          end
          deleted_relationships << [file, child]
        end
      end
      if deleted_relationships.empty?
        raise "All files still contain relationships"
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

    def find_join_tables(file = "db/schema.rb")
      join_table_models = []
      File.open(file) do |file|
        count = -1
        file.each_line do |line|
          count += 1
          if line.include?("id: false")
            model_one_line = IO.readlines(file)[count+1]
            model_two_line = IO.readlines(file)[count+2]
            model_one = model_one_line.split("\"")[1].gsub(/(_id)/, "")
            model_two = model_two_line.split("\"")[1].gsub(/(_id)/, "")
            join_table_models << [model_one, model_two]
          end
        end
      end
      join_table_models
    end

    def generate_habtm_remove_migrations(filepath = 'app/models/', file = "db/schema.rb")
      output = []
      tables = find_join_tables(file)
      tables.each do |table|
        model_one = table[0]
        model_two = table[1]
        if habtm_check(model_one, model_two, filepath) && habtm_check(model_two, model_one, filepath)
          output << "bin/rails g migration RemoveJoinTable #{model_one} #{model_two}"
        end
      end
      output
    end

    private

    def habtm_check(first, second, filepath)
      path = filepath + first + '.rb'
      if File.open(path).each_line.any? do |line|
          return false if line.include?("has_and_belongs_to_many :#{second}")
        end
      end
      return true
    end

  end
end
