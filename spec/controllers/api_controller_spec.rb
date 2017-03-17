require 'rails_helper'

RSpec.describe ApiController, type: :controller do


  def setup_auth_token
    user = FactoryGirl.create(:user, email: 'joe@dummy.com', password: 'password123')
    auth_token = JsonWebToken.encode({user_id: user.id})
    request.headers["Authorization"] = "Bearer #{auth_token}"
  end

  let(:parsed_response) { JSON.parse(response.body) }

  #
  # GET #authenticate_user
  #
  describe "POST #authenticate_user" do
    context "with valid login details" do
      it "returns a JSON web token" do
        user = FactoryGirl.create(:user, email: 'joe@dummy.com', password: 'password123')
        post :authenticate_user, { email: 'joe@dummy.com', password: 'password123'  }
        expect(parsed_response).to have_key("auth_token")
        auth_token = JsonWebToken.decode(parsed_response['auth_token'])
        expect(auth_token[:user_id].to_i).to eq(user.id)
      end
    end
    context "with invalid login details" do
      it "returns an error" do
        post :authenticate_user, { email: 'joe@dummy.com', password: 'password123'  }
        expect(response).to have_http_status(:unauthorized)
        expect(parsed_response).to have_key("errors")
      end
    end
  end

  #
  # GET #children
  #
  describe "GET #children" do

    context "with a valid token" do

      before(:each) do
        setup_auth_token
      end

      it "returns a JSON list of children" do
        child_1 = FactoryGirl.create(:default_child, first_name: 'a', last_name: 'a')
        child_2 = FactoryGirl.create(:default_child, first_name: 'b', last_name: 'b')
        get :children
        expect(response.header['Content-Type']).to include("application/json")
        expect(parsed_response.size).to eq(2)
      end

      it "orders the children by first and last name" do
        FactoryGirl.create(:default_child, first_name: 'b', last_name: 'a')
        FactoryGirl.create(:default_child, first_name: 'b', last_name: 'b')
        FactoryGirl.create(:default_child, first_name: 'a', last_name: 'b')
        FactoryGirl.create(:default_child, first_name: 'a', last_name: 'a')
        get :children
        names = parsed_response.map { |c| "#{c['first_name']} #{c['last_name']}"  }
        expect(names).to eq(["a a", "a b", "b a", "b b"])
      end

    end

    context "with an invalid token" do
      it "returns an error" do
        get :children
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end

  #
  # POST #create_sign_in
  #
  describe "POST #create_sign_in" do

    context "with valid token" do

      before(:each) do
        setup_auth_token
      end

      context "for a newcomer" do

        let(:newcomer_attrs) {
          FactoryGirl.attributes_for(:newcomer_sign_in)
        }

        def post_sign_in_newcomer
          post :create_sign_in, newcomer_attrs
        end

        before(:each) do
          post_sign_in_newcomer
        end

        it "returns success" do
          expect(response).to have_http_status(:success)
        end

        it "creates a new record" do
          expect {
            post_sign_in_newcomer
          }.to change(SignIn, :count).by(1)
        end

        it "returns the id of the new record" do
          expect(parsed_response["id"]).to eq(SignIn.first.id)
        end

        it "sets the newcomer flag to true" do
          expect(SignIn.first.newcomer).to eq(true)
        end

        it "sets the child_id to nil" do
          expect(SignIn.first.child_id).to eq(nil)
        end

        it "stores the supplied first_name" do
          expect(SignIn.first.first_name).to eq(newcomer_attrs[:first_name])
        end

        it "stores the supplied last_name" do
          expect(SignIn.first.last_name).to eq(newcomer_attrs[:last_name])
        end

        it "stores the supplied room" do
          expect(SignIn.first.room).to eq(newcomer_attrs[:room])
        end

        it "stores the supplied label" do
          expect(SignIn.first.label).to eq(newcomer_attrs[:label])
        end

        it "stores the supplied sign in time" do
          expect(SignIn.first.sign_in_time).to eq(newcomer_attrs[:sign_in_time])
        end

      end

      context "for an existing child" do

        let(:child) {
          FactoryGirl.create(
            :default_child,
            :first_name => 'Existing',
            :last_name => 'Name'
          )
        }

        def post_sign_in_existing
          attrs = FactoryGirl.attributes_for(
            :default_sign_in,
            :first_name => 'Something', :last_name => 'Different')
          attrs[:child_id] = child.id
          post :create_sign_in, attrs
        end

        it "links the new record to an existing child" do
          post_sign_in_existing
          expect(Child.first.sign_ins.first.id).to eq(SignIn.first.id)
        end

        it "sets the newcomer flag to false" do
          post_sign_in_existing
          expect(SignIn.first.newcomer).to eq(false)
        end

        it "ignores the supplied first_name" do
          post_sign_in_existing
          expect(SignIn.first.first_name).to eq('Existing')
        end

        it "ignores the supplied last_name" do
          post_sign_in_existing
          expect(SignIn.first.last_name).to eq('Name')
        end

      end

      context "with invalid data" do

        def post_sign_in
          attrs = FactoryGirl.attributes_for(:newcomer_sign_in, :label => nil)
          post :create_sign_in, attrs
        end

        it "returns an error" do
          post_sign_in
          expect(response).to have_http_status(500)
        end

        it "does not create a new record" do
          expect {
            post_sign_in
          }.to_not change(SignIn, :count)
        end

      end

    end

    context "with an invalid token" do
      it "returns an error" do
        post :create_sign_in, FactoryGirl.attributes_for(:newcomer_sign_in)
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end

  #
  # GET #sign_ins
  #
  describe "GET #sign_ins" do

    context "with a valid token" do

      before(:each) do
        setup_auth_token
      end

      it "returns a JSON list of sign_ins" do
        FactoryGirl.create(:default_sign_in, label: 'A')
        get :sign_ins
        expect(response.header['Content-Type']).to include("application/json")
        expect(parsed_response.size).to eq(1)
        expect(parsed_response[0]["label"]).to eq('A')
      end

      it "only returns sign_ins for today" do
        FactoryGirl.create(:default_sign_in, label: "A", sign_in_time: 1.days.ago)
        FactoryGirl.create(:default_sign_in, label: "B", sign_in_time: DateTime.now)
        FactoryGirl.create(:default_sign_in, label: "C", sign_in_time: 1.days.from_now)
        get :sign_ins
        expect(parsed_response.size).to eq(1)
        expect(parsed_response[0]["label"]).to eq('B')
      end

      it "orders the sign_ins by time oldest first" do
        FactoryGirl.create(:default_sign_in, label: "A", sign_in_time: 5.minutes.from_now)
        FactoryGirl.create(:default_sign_in, label: "B", sign_in_time: 5.minutes.ago)
        FactoryGirl.create(:default_sign_in, label: "C", sign_in_time: DateTime.now)
        get :sign_ins
        result = parsed_response.map { |s| s["label"] }
        expect(result).to eq(['B', 'C', 'A'])
      end

    end

    context "with an invalid token" do
      it "returns an error" do
        get :sign_ins
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end

end
