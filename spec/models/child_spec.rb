require 'rails_helper'

RSpec.describe Child, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:default_child)).to be_valid
  end


  #
  # Scope tests
  #

  describe 'scope:with_first_name' do
    it 'includes children whose first name matches the value' do

      aaa       = FactoryGirl.create(:default_child, :first_name => 'aaa')
      bbbaaa    = FactoryGirl.create(:default_child, :first_name => 'bbbaaa')
      bbbaaaccc = FactoryGirl.create(:default_child, :first_name => 'bbbaaaccc')
      zzz       = FactoryGirl.create(:default_child, :first_name => 'zzz')

      filtered = Child.with_first_name('aaa')

      expect(filtered).to include(aaa, bbbaaa, bbbaaaccc)
      expect(filtered).not_to include(zzz)
    end

    it 'ignores case' do
      aAa       = FactoryGirl.create(:default_child, :first_name => 'aAa')

      filtered = Child.with_first_name('aaa')

      expect(filtered).to include(aAa)
    end
  end

  describe 'scope:with_last_name' do
    it 'includes children whose last name matches the value' do

      aaa       = FactoryGirl.create(:default_child, :last_name => 'aaa')
      bbbaaa    = FactoryGirl.create(:default_child, :last_name => 'bbbaaa')
      bbbaaaccc = FactoryGirl.create(:default_child, :last_name => 'bbbaaaccc')
      zzz       = FactoryGirl.create(:default_child, :last_name => 'zzz')

      filtered = Child.with_last_name('aaa')

      expect(filtered).to include(aaa, bbbaaa, bbbaaaccc)
      expect(filtered).not_to include(zzz)
    end

    it 'ignores case' do
      aAa       = FactoryGirl.create(:default_child, :last_name => 'aAa')

      filtered = Child.with_last_name('aaa')

      expect(filtered).to include(aAa)
    end
  end

  describe 'scope:with_ministry_tracker_id' do
    it 'includes children whose ministry tracker id matches the value' do

      a = FactoryGirl.create(:default_child, :ministry_tracker_id => '1111')
      b = FactoryGirl.create(:default_child, :ministry_tracker_id => '2222')

      filtered = Child.with_ministry_tracker_id('1111')

      expect(filtered).to include(a)
      expect(filtered).not_to include(b)
    end
  end

  describe 'scope:with_update_required' do
    it 'includes children with the update_required flag set to true' do

      a = FactoryGirl.create(:default_child, :update_required => true)
      b = FactoryGirl.create(:default_child, :update_required => false)

      filtered = Child.with_update_required(1)

      expect(filtered).to include(a)
      expect(filtered).not_to include(b)
    end
  end

  describe 'scope:with_medical_information' do
    it 'includes children with medical details' do

      a = FactoryGirl.create(:default_child, :medical_information => 'Something to note')
      b = FactoryGirl.create(:default_child)

      filtered = Child.with_medical_information(1)

      expect(filtered).to include(a)
      expect(filtered).not_to include(b)
    end
  end

  describe 'scope:with_age' do
    it 'includes children of the correct age' do

      a = FactoryGirl.create(:default_child, :date_of_birth => Date.today - 1.year)
      b = FactoryGirl.create(:default_child, :date_of_birth => Date.today - 1.year + 1.day)
      c = FactoryGirl.create(:default_child, :date_of_birth => Date.today - 2.years)
      d = FactoryGirl.create(:default_child, :date_of_birth => Date.today - 2.years + 1.day)

      filtered = Child.with_age(1)

      expect(filtered).to include(a, d)
      expect(filtered).not_to include(b, c)
    end
  end


  #
  # Validation tests
  #

  it "is invalid without a first name" do
    expect(FactoryGirl.build(:default_child, :first_name => "")).not_to be_valid
  end

  it "is invalid without a last name" do
    expect(FactoryGirl.build(:default_child, :last_name => "")).not_to be_valid
  end


  #
  # age tests
  #

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


end
