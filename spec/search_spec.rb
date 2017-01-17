require 'spec_helper'

describe 'search' do

	it 'raises an error when filepath does not exist' do
		search = Search.new
		expect{search.return_files}.to raise_error("Filepath does not exist")
	end

	it 'returns an array of all ruby files in app/models' do
		search = Search.new
		expect(search.return_files("spec/test_models")).to eq ["spec/test_models/bacon.rb", "spec/test_models/piggy.rb"]
	end

	it 'returns an array of all ruby files containing "has_many" keyword' do 
		search = Search.new
		expect(search.return_has_many("spec/test_models")).to eq ["spec/test_models/piggy.rb"]
	end

end