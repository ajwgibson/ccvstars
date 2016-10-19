require 'rails_helper'

RSpec.describe SignIn, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:default_sign_in)).to be_valid
  end


  #
  # Validation
  #

  it "is invalid without a first name" do
    expect(FactoryGirl.build(:default_sign_in, :first_name => "")).not_to be_valid
  end

  it "is invalid without a last name" do
    expect(FactoryGirl.build(:default_sign_in, :last_name => "")).not_to be_valid
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
  

end