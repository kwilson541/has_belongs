require 'spec_helper'

describe HasBelongs::Cli do

  describe 'install' do
    it "should create a file" do
      file = "has_belongs/"
    end
  end

  it 'should create a file' do
    HasBelongs::Cli.start install
    # install
    file = File.open("/Users/jamesdix/Desktop/week9/has_belongs/spec/spec_helper.rb")
    content = file.read
    expect(content).to eq("$LOAD_PATH.unshift File.expand_path(\"../../lib\", __FILE__)\nrequire \"has_belongs\"\n")
  end

end
