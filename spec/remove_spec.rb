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
    expect(remove.set_parent_file('spec/test_models/with_associations/', "spec/db_test/schema.rb")).to eq [["spec/test_models/with_associations/author.rb", "books"], ["spec/test_models/with_associations/book.rb", "pages"]]
  end

  it 'checks if file no longer contains a "has_many" relationship' do
    expect(remove.non_existing_relationships('spec/test_models/with_and_without_associations/', "spec/db_test/schema.rb")).to eq [['spec/test_models/with_and_without_associations/author.rb', "books"]]
  end

  it 'checks if file no longer contains multiple associations' do
    expect(remove.non_existing_relationships('spec/test_models/remove_many_and_one/', "spec/db_test/schema2.rb")).to eq [['spec/test_models/remove_many_and_one/author.rb', "books"], ['spec/test_models/remove_many_and_one/author.rb', "pages"]]
  end

  it 'should raise an error if unmigration is not needed' do
    expect{remove.remove_migrations('spec/test_models/with_associations/', "spec/db_test/schema.rb")}.to raise_error("All files still contain relationships")
  end

  it "will generate the remove commands" do
    expect(remove.generate_has_and_one_remove_migrations('spec/test_models/with_and_without_associations/', "spec/db_test/schema.rb")).to eq(["bin/rails g migration RemoveAuthorRefFromBooks author:references"])
  end

  pending it 'can find join table models' do
    expect(remove.find_join_tables("spec/db_test/schema.rb")).to eq [["book", "page"]]
  end

  pending it 'can generate remove commands for removing habtm association' do
    expect(remove.generate_habtm_remove_migrations("spec/test_models/remove_habtm/", "spec/db_test/schema.rb")).to eq ["bin/rails g migration RemoveJoinTable book page"]
  end

end
