require 'rails_helper'

RSpec.describe Child, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:default_child)).to be_valid
  end

  it "is invalid without a first name" do
    expect(FactoryGirl.build(:default_child, :first_name => "")).not_to be_valid
  end

  it "is invalid without a last name" do
    expect(FactoryGirl.build(:default_child, :last_name => "")).not_to be_valid
  end


  describe '#age' do
    it 'returns nil if there is no date_of_birth' do
      child = FactoryGirl.build(:default_child)
      expect(child.age).to be_nil
    end
    it 'returns the age in years' do
      child = FactoryGirl.build(:default_child, :date_of_birth => Date.today - 4.years)
      expect(child.age).to eq(4)
    end
    it 'returns the correct age for a child with a birthday in the future' do
      child = FactoryGirl.build(:default_child, :date_of_birth => Date.today + 1.day - 4.years)
      expect(child.age).to eq(3)
    end
  end

  describe '#name' do
    it 'returns last_name, first_name' do
      child = FactoryGirl.build(:child, :first_name => 'John', :last_name => 'Watson')
      expect(child.name).to eq('Watson, John')
    end
    context 'when there is no last_name' do
      it 'returns the first_name' do
        child = FactoryGirl.build(:child, :first_name => 'John')
        expect(child.name).to eq('John')
      end
    end
    context 'when there is no first_name' do
      it 'returns the last_name' do
        child = FactoryGirl.build(:child, :last_name => 'Watson')
        expect(child.name).to eq('Watson')
      end
    end
    context 'when there is no first_name or last_name' do
      it 'returns an empty string' do
        child = FactoryGirl.build(:child)
        expect(child.name).to eq('')
      end
    end
  end

end
