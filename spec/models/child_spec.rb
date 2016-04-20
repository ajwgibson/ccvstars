require 'rails_helper'

RSpec.describe Child, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:child)).to be_valid
  end

  it "is invalid without a first name" do
    expect(FactoryGirl.build(:child, :first_name => "")).not_to be_valid
  end

  it "is invalid without a last name" do
    expect(FactoryGirl.build(:child, :last_name => "")).not_to be_valid
  end

end
