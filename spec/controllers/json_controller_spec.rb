require 'rails_helper'

RSpec.describe JsonController, type: :controller do

  login_user

  #
  # GET #children
  #
  describe "GET #children" do

    it "sets the content type to json" do
      get :children, :name => ''
      expect(response.headers["Content-Type"]).to match /application\/json/
    end

    it "returns a list of children" do
      child_1 = FactoryGirl.create(:default_child, first_name: 'a', last_name: 'a')
      child_2 = FactoryGirl.create(:default_child, first_name: 'b', last_name: 'b')
      expected = [
        { id: child_1.id, full_name: 'a a' },
        { id: child_2.id, full_name: 'b b' },
      ].to_json
      get :children, :name => ''
      expect(response.body).to eq(expected)
    end

    it "orders the children by first and then last name" do
      child_1 = FactoryGirl.create(:default_child, first_name: 'b', last_name: 'b')
      child_2 = FactoryGirl.create(:default_child, first_name: 'a', last_name: 'b')
      child_3 = FactoryGirl.create(:default_child, first_name: 'b', last_name: 'a')
      child_4 = FactoryGirl.create(:default_child, first_name: 'a', last_name: 'a')
      expected = [
        { id: child_4.id, full_name: 'a a' },
        { id: child_2.id, full_name: 'a b' },
        { id: child_3.id, full_name: 'b a' },
        { id: child_1.id, full_name: 'b b' },
      ].to_json
      get :children, :name => ''
      expect(response.body).to eq(expected)
    end

    context "with a single word query parameter" do

      it "matches on first_name" do
        child_1 = FactoryGirl.create(:default_child, first_name: 'axa', last_name: 'aaa')
        child_2 = FactoryGirl.create(:default_child, first_name: 'bbb', last_name: 'bbb')
        expected = [
          { id: child_1.id, full_name: 'axa aaa' },
        ].to_json
        get :children, :name => 'x'
        expect(response.body).to eq(expected)
      end

      it "matches on last_name" do
        child_1 = FactoryGirl.create(:default_child, first_name: 'aaa', last_name: 'axa')
        child_2 = FactoryGirl.create(:default_child, first_name: 'bbb', last_name: 'bbb')
        expected = [
          { id: child_1.id, full_name: 'aaa axa' },
        ].to_json
        get :children, :name => 'x'
        expect(response.body).to eq(expected)
      end

    end

    context "with a two word query parameter" do
      it "matches first_name and last_name" do
        child_1 = FactoryGirl.create(:default_child, first_name: 'aaa', last_name: 'aaa')
        child_2 = FactoryGirl.create(:default_child, first_name: 'aaa', last_name: 'axa')
        child_3 = FactoryGirl.create(:default_child, first_name: 'axa', last_name: 'aaa')
        child_4 = FactoryGirl.create(:default_child, first_name: 'axa', last_name: 'axa')
        expected = [
          { id: child_4.id, full_name: 'axa axa' },
        ].to_json
        get :children, :name => 'x x'
        expect(response.body).to eq(expected)
      end
    end
  end

end
