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


  #
  # Import tests
  #

  describe "#import" do

    def clear_uploads
      FileUtils.rm Dir.glob(Rails.root.join('public', 'uploads', '*'))
    end

    def file_fixture(file)
      Rails.root.join('spec', 'fixtures', 'files', file)
    end

    before(:each) do
      clear_uploads
    end

    after(:each) do
      clear_uploads
    end


    context "when a new ministry tracker id is found" do

      before do 
        Child.import(file_fixture('child_imports/one_new_child.xlsx'))
        @child = Child.first
      end

      it "creates a new child" do
        expect(Child.count).to eq(1)
      end

      it "maps the child's ministry_tracker_id from the PID column" do
        expect(@child.ministry_tracker_id).to eq('1001')
      end

      it "maps the child's last_name from the Person_Lastname column" do
        expect(@child.last_name).to eq('Doe')
      end

      it "maps the child's first_name from the Person_Firstname column" do
        expect(@child.first_name).to eq('John')
      end

      it "maps the child's date_of_birth from the Birthdate column" do
        expect(@child.date_of_birth).to eq(Date.parse('2010-01-21'))
      end

    end


    context "when a child has no address" do

      before do 
        Child.import(file_fixture('child_imports/update_required.xlsx'))
        @child = Child.first
      end

      it "sets the child's update_required flag to true" do
        expect(@child.update_required).to be(true)
      end

    end


    context "when a child has an invalid date of birth" do

      before do 
        Child.import(file_fixture('child_imports/invalid_date_of_birth.xlsx'))
        @child = Child.first
      end

      it "sets the child's date_of_birth to nil" do
        expect(@child.date_of_birth).to be(nil)
      end

    end


    context "when an existing ministry tracker id is found" do

      before do 
        FactoryGirl.create(:default_child, :ministry_tracker_id => '1001')
        Child.import(file_fixture('child_imports/one_updated_child.xlsx'))
        @child = Child.find_by ministry_tracker_id: '1001'
      end

      it "does not create a new child" do
        expect(Child.count).to eq(1)
      end

      it "updates the child's last_name from the Person_Lastname column" do
        expect(@child.last_name).to eq('Doe')
      end

      it "updates the child's first_name from the Person_Firstname column" do
        expect(@child.first_name).to eq('John')
      end

      it "updates the child's date_of_birth from the Birthdate column" do
        expect(@child.date_of_birth).to eq(Date.parse('2010-01-21'))
      end

      it "updates the child's update_required flag" do
        expect(@child.update_required).to be(true)
      end

    end

  end

end
