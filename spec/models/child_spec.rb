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


  describe '#age' do
    it 'returns nil if there is no date_of_birth' do
      child = FactoryGirl.build(:child)
      expect(child.age).to be_nil
    end
    it 'returns the age in years' do
      child = FactoryGirl.build(:child, :date_of_birth => Date.today - 4.years)
      expect(child.age).to eq(4)
    end
    it 'returns the correct age for a child with a birthday in the future' do
      child = FactoryGirl.build(:child, :date_of_birth => Date.today + 1.day - 4.years)
      expect(child.age).to eq(3)
    end
  end

end
