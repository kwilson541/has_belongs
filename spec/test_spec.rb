require 'spec_helper'

describe Test do

  it 'should output Hello' do
    expect(Test.hi).to eq('Hello')
  end

end
