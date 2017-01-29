require 'spec_helper'


describe 'add' do

		let(:add) { HasBelongs::Add.new }


	it 'raises an error when filepath does not exist' do

		expect{add.return_files}.to raise_error("app/models does not exist")
	end

	it 'raises an error when it cannot find any files in the directory' do
		expect{add.return_files("spec/test_models_empty")}.to raise_error("Could not find any files in spec/test_models_empty")
	end

	it 'raises an error if appropriate files do not contains "has_many"' do
		expect{add.return_has_many("spec/test_models_without_associations")}.to raise_error("No associations found")
	end

	it 'returns an array of all ruby files in app/models' do
		expect(add.return_files("spec/test_models")).to eq ["spec/test_models/bacon.rb", "spec/test_models/piggy.rb"]
	end

	it 'returns an array of all ruby files containing "has_many" keyword' do
		expect(add.return_has_many("spec/test_models")).to eq ["spec/test_models/piggy.rb"]
	end

	it 'returns an array of all ruby files containing "has_one" keyword' do
		expect(add.return_has_many("spec/test_models_has_one")).to eq ["spec/test_models_has_one/piggy3.rb"]
	end

	it 'returns the Rails generate method for files with "has_many" keyword' do
		expect(add.generate_migration("spec/test_models")).to eq ["bin/rails g migration AddPiggyRefToBacon piggy:references"]
	end

	it 'returns the Rails generate method for files with "has_one" keyword' do
		expect(add.generate_migration("spec/test_models_has_one")).to eq ["bin/rails g migration AddPiggyRefToTail piggy:references"]
	end

	it 'returns true if migration exists' do
		expect(add.relationship_exist?("AddUserRefToComments", "*/test_migration_files/*.rb")).to be true
	end

	it 'returns true if habtm migration exists' do
		expect(add.relationship_exist?("create_join_table :bacons, :piggies", "*/test_migration_files/*.rb")).to be true
	end

	it 'returns false if migration does not exist' do
		expect(add.relationship_exist?("AddUserRefToComments", "*/test_models_empty/*.rb")).to be false
	end

	it 'returns multiple generate methods for a single file with multiple "has_many" keywords' do
		expect(add.generate_migration("spec/test_models_multiple_associations")).to eq ["bin/rails g migration AddPiggyRefToBacon piggy:references", "bin/rails g migration AddPiggyRefToHam piggy:references"]
	end

	it 'returns a file with "has_and_belongs_to_many" keyword' do
		expect(add.return_has_many("spec/test_models_habtm")).to eq ["spec/test_models_habtm/bacon.rb"]
	end

	it 'returns migration method for a join table' do
		expect(add.generate_migration("spec/test_models_habtm")).to eq ["bin/rails g migration CreateJoinTable bacon piggy"]
	end

	it 'returns only one migration method for each join table' do
		expect(add.generate_migration("spec/test_models_multiple_habtm")).to eq ["bin/rails g migration CreateJoinTable bacon piggy"]
	end

end
