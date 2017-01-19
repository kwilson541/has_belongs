class Remove

  def find_add_foreign_key
    foreign_keys = []
    File.open("db/schema.rb") do |file|
      file.find_all do |line|
        if line.include?("add_foreign_key")
          foreign_keys << line.strip
        end
      end
      foreign_keys
    end
  end

  def find_models_in_schema
    child_parent_array = []
    words = find_add_foreign_key
    words.each do |word|
      word_array = word.split('"')
      child_parent = word_array.values_at(* word_array.each_index.select { |item| item.odd? })
      child_parent_array << child_parent
    end
    child_parent_array
  end

  def set_parent_file(filepath = 'app/models/')
    files_hash = {}
    relationships = find_models_in_schema
    relationships.each do |relationship|
      singularized_parent = ActiveSupport::Inflector.singularize(relationship[1])
      file_path = filepath + singularized_parent + '.rb'
      files_hash[file_path] = relationship[0]
    end
    files_hash
  end

  def non_existing_relationships(filepath = 'app/models/')
    deleted_relationships = []
    model_files = set_parent_file(filepath)
    model_files.each do |file, child|
      if !File.open(file).each_line.any? do |line|
        line.include?("has_many :#{child}")
        end
        deleted_relationships << [file, child]
      end
    end
    deleted_relationships
  end

end
