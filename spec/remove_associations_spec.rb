require 'spec_helper'

describe 'remove_assocations' do

  let(:remove) { HasBelongs::Remove.new }

  it 'searches through the schema.rb file for add_foreign_key' do
    expect(remove.find_add_foreign_key("spec/db_test/schema.rb")).to eq ['add_foreign_key "books", "authors"', 'add_foreign_key "pages", "books"']
  end

  it 'returns the model and associated model from the relevant schema.rb line' do
    expect(remove.find_models_in_schema("spec/db_test/schema.rb")).to eq [['books', 'authors'], ['pages', 'books']]
  end

  it 'finds the related model file' do
    expect(remove.set_parent_file('spec/test_models/', "spec/db_test/schema.rb")).to eq "spec/test_models/author.rb"=>"books", "spec/test_models/book.rb"=>"pages"
  end

  it 'checks if file no longer contains a "has_many" relationship' do
    expect(remove.non_existing_relationships('spec/test_models_with_and_without_associations/', "spec/db_test/schema.rb")). to eq [['spec/test_models_with_and_without_associations/author.rb', "books"]]
  end


  it "will generate the remove commands" do
    expect(remove.generate_migration('spec/test_models_with_and_without_associations/', "spec/db_test/schema.rb")).to eq(["bin/rails g migration RemoveAuthorRefFromBooks author:references"])
  end

end
