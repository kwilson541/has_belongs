require 'spec_helper'

describe HasBelongs::Test do

  it 'should output Hello' do
    expect(HasBelongs::Test.hi).to eq('Hello')
  end
end

RSpec.describe "first run", :type => :aruba do
let(:file) { 'file.txt' }
# file2 = File.open("../LICENSE.txt")
before(:each) do
  touch("../" + file)
  cd ".."
end

it {expect(file).to be_an_existing_file}

end
