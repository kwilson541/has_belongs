require 'spec_helper'


describe 'search' do

		let(:search) { HasBelongs::Search.new }


	it 'raises an error when filepath does not exist' do

		expect{search.return_files}.to raise_error("app/models does not exist")
	end

	it 'raises an error when it cannot find any files in the directory' do
		expect{search.return_files("spec/test_models_empty")}.to raise_error("Could not find any files in spec/test_models_empty")
	end

	it 'raises an error if appropriate files do not contains "has_many"' do
		expect{search.return_has_many("spec/test_models_without_associations")}.to raise_error("No associations found")
	end

	it 'returns an array of all ruby files in app/models' do
		expect(search.return_files("spec/test_models")).to eq ["spec/test_models/bacon.rb", "spec/test_models/piggy.rb"]
	end

	it 'returns an array of all ruby files containing "has_many" keyword' do
		expect(search.return_has_many("spec/test_models")).to eq ["spec/test_models/piggy.rb"]
	end

	it 'returns the Rails generate method for files with "has_many" keyword' do
		expect(search.generate_migration("spec/test_models")).to eq ["bin/rails g migration AddPiggyRefToBacon piggy:references"]
	end

	it 'returns true if migration exists' do
		expect(search.relationship_exist?("AddUserRefToComments", "*/test_migration_files/*.rb")).to be true
	end

	it 'returns false if migration does not exist' do
		expect(search.relationship_exist?("AddUserRefToComments", "*/test_models_empty/*.rb")).to be false
	end

end
