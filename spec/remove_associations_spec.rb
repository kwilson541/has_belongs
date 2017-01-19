require 'spec_helper'
# require 'lib/has_belongs/remove'

describe 'remove_assocations' do

  it 'searches through the schema.rb file for add_foreign_key' do
    remove = Remove.new
    expect(remove.find_add_foreign_key).to eq ['add_foreign_key "books", "authors"', 'add_foreign_key "pages", "books"']
  end

  it 'returns the model and associated model from the relevant schema.rb line' do
    remove = Remove.new
    expect(remove.find_models_in_schema).to eq [['books', 'authors'], ['pages', 'books']]
  end

  it 'finds the related model file' do
    remove = Remove.new
    expect(remove.set_parent_file('spec/test_models/')).to eq "spec/test_models/author.rb"=>"books", "spec/test_models/book.rb"=>"pages"
  end

  it 'checks if file no longer contains a "has_many" relationship' do
    remove = Remove.new
    expect(remove.non_existing_relationships('spec/test_models_with_and_without_associations/')). to eq [['spec/test_models_with_and_without_associations/author.rb', "books"]]
  end


  it "will generate the remove commands" do
    remove = Remove.new
    expect(remove.generate_migration('spec/test_models_with_and_without_associations/')).to eq(["bin/rails g migration RemoveAuthorRefFromBooks author:references"])
  end

end
