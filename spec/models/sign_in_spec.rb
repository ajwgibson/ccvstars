require 'rails_helper'

RSpec.describe SignIn, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:default_sign_in)).to be_valid
  end


  #
  # Validation
  #

  context "for a newcomer" do
    it "is invalid without a first name" do
      expect(FactoryGirl.build(:newcomer_sign_in, :first_name => "")).not_to be_valid
    end

    it "is invalid without a last name" do
      expect(FactoryGirl.build(:newcomer_sign_in, :last_name => "")).not_to be_valid
    end
  end

  context "for an existing child" do
    it "is invalid without a linked child" do
      expect(FactoryGirl.build(:default_sign_in, :child => nil)).not_to be_valid
    end
    context "when the skip_child_validation flag is true" do
      it "is valid without a linked child" do
        expect(FactoryGirl.build(
          :default_sign_in,
          :child => nil,
          :skip_child_validation => true)).to be_valid
      end
    end
  end

  it "is invalid without a room" do
    expect(FactoryGirl.build(:default_sign_in, :room => "")).not_to be_valid
  end

  it "is invalid without a sign_in_time" do
    expect(FactoryGirl.build(:default_sign_in, :sign_in_time => nil)).not_to be_valid
  end

  it "is invalid without a label" do
    expect(FactoryGirl.build(:default_sign_in, :label => "")).not_to be_valid
  end




  #
  # Scopes
  #

  describe 'scope:with_first_name' do

    it 'includes records whose first name matches the value' do

      aaa       = FactoryGirl.create(:default_sign_in, :first_name => 'aaa')
      bbbaaa    = FactoryGirl.create(:default_sign_in, :first_name => 'bbbaaa')
      bbbaaaccc = FactoryGirl.create(:default_sign_in, :first_name => 'bbbaaaccc')
      zzz       = FactoryGirl.create(:default_sign_in, :first_name => 'zzz')

      filtered = SignIn.with_first_name('aaa')

      expect(filtered).to include(aaa, bbbaaa, bbbaaaccc)
      expect(filtered).not_to include(zzz)

    end


    it 'ignores case' do

      aAa       = FactoryGirl.create(:default_sign_in, :first_name => 'aAa')

      filtered = SignIn.with_first_name('aaa')

      expect(filtered).to include(aAa)

    end

  end

  describe 'scope:with_last_name' do


    it 'includes children whose last name matches the value' do

      aaa       = FactoryGirl.create(:default_sign_in, :last_name => 'aaa')
      bbbaaa    = FactoryGirl.create(:default_sign_in, :last_name => 'bbbaaa')
      bbbaaaccc = FactoryGirl.create(:default_sign_in, :last_name => 'bbbaaaccc')
      zzz       = FactoryGirl.create(:default_sign_in, :last_name => 'zzz')

      filtered = SignIn.with_last_name('aaa')

      expect(filtered).to include(aaa, bbbaaa, bbbaaaccc)
      expect(filtered).not_to include(zzz)

    end


    it 'ignores case' do
      aAa       = FactoryGirl.create(:default_sign_in, :last_name => 'aAa')

      filtered = SignIn.with_last_name('aaa')

      expect(filtered).to include(aAa)
    end

  end

  describe 'scope:is_newcomer' do
    it 'includes records that match the newcomer value' do
      a = FactoryGirl.create(:default_sign_in, :newcomer => true)
      b = FactoryGirl.create(:default_sign_in, :newcomer => false)

      filtered = SignIn.is_newcomer(true)

      expect(filtered).to include(a)
      expect(filtered).not_to include(b)
    end
  end

  describe 'scope:in_room' do
    it 'includes records that match the room value exactly' do
      a  = FactoryGirl.create(:default_sign_in, :room => 'A')
      aa = FactoryGirl.create(:default_sign_in, :room => 'AA')
      b  = FactoryGirl.create(:default_sign_in, :room => 'B')

      filtered = SignIn.in_room('A')

      expect(filtered).to include(a)
      expect(filtered).not_to include(aa, b)
    end
  end

  describe 'scope:on_or_after' do
    it 'includes records that fall on or after the date provided' do
      a  = FactoryGirl.create(:default_sign_in, :sign_in_time => 2.days.ago)
      b  = FactoryGirl.create(:default_sign_in, :sign_in_time => 3.days.ago)
      c  = FactoryGirl.create(:default_sign_in, :sign_in_time => 1.days.ago)

      filtered = SignIn.on_or_after(2.days.ago)

      expect(filtered).to include(a, c)
      expect(filtered).not_to include(b)
    end
  end

  describe 'scope:on_or_before' do
    it 'includes records that fall on or before the date provided' do
      a  = FactoryGirl.create(:default_sign_in, :sign_in_time => 2.days.ago)
      b  = FactoryGirl.create(:default_sign_in, :sign_in_time => 3.days.ago)
      c  = FactoryGirl.create(:default_sign_in, :sign_in_time => 1.days.ago)

      filtered = SignIn.on_or_before(2.days.ago)

      expect(filtered).to include(a, b)
      expect(filtered).not_to include(c)
    end
  end

  describe 'scope:for_today' do
    it 'includes records that fall on the current date' do
      a  = FactoryGirl.create(:default_sign_in, :sign_in_time => 1.days.ago)
      b  = FactoryGirl.create(:default_sign_in, :sign_in_time => 0.days.ago)
      c  = FactoryGirl.create(:default_sign_in, :sign_in_time => 1.days.from_now)

      filtered = SignIn.for_today()

      expect(filtered).to include(b)
      expect(filtered).not_to include(a, c)
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


    context "when a newcomer record is encountered" do

      before do
        SignIn.import(file_fixture('sign_in_imports/newcomer.csv'))
        @sign_in = SignIn.first
      end

      it "creates a new sign_in record" do
        expect(SignIn.count).to eq(1)
      end

      it "maps the label from the Id column" do
        expect(@sign_in.label).to eq('401')
      end

      it "maps the child's last_name from the 'Last' column" do
        expect(@sign_in.last_name).to eq('Smith')
      end

      it "maps the child's first_name from the 'First' column" do
        expect(@sign_in.first_name).to eq('John')
      end

      it "maps the sign in time" do
        expect(@sign_in.sign_in_time).to eq(DateTime.parse('2016-11-20 11:32:22'))
      end

      it "maps the room" do
        expect(@sign_in.room).to eq('Allstars')
      end

      it "maps the newcomer flag" do
        expect(@sign_in.newcomer).to be(true)
      end

    end


    context "when a record for an existing child is encountered" do

      before do
        SignIn.import(file_fixture('sign_in_imports/existing.csv'))
        @sign_in = SignIn.first
      end

      it "maps the newcomer flag" do
        expect(@sign_in.newcomer).to be(false)
      end

    end


    context "when a duplicate record is found" do

      before do
        SignIn.import(file_fixture('sign_in_imports/duplicate.csv'))
      end

      it "ignores the duplicate" do
        expect(SignIn.count).to eq(1)
      end
    end

    context "when a record with no sign_in information is found" do

      before do
        SignIn.import(file_fixture('sign_in_imports/not_signed_in.csv'))
      end

      it "ignores the record" do
        expect(SignIn.count).to eq(0)
      end

    end

  end

end
