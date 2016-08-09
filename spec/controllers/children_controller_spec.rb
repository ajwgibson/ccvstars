require 'rails_helper'

RSpec.describe ChildrenController, type: :controller do

  login_user

  describe "GET #index" do
    
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end

    it "populates an array of children" do
      child = FactoryGirl.create(:child)
      get :index
      expect(assigns(:children)).to eq([child])
    end

    it "orders the children by last_name then first_name" do

      riley_gibson = FactoryGirl.create(:child, :last_name => 'Gibson', :first_name => 'Riley')
      daniel_pavey = FactoryGirl.create(:child, :last_name => 'Pavey',  :first_name => 'Daniel')
      erin_gibson  = FactoryGirl.create(:child, :last_name => 'Gibson', :first_name => 'Erin')

      get :index

      expect(assigns(:children)).to eq([erin_gibson, riley_gibson, daniel_pavey])
    end

  end

  describe "GET #show" do
    
    let(:child) { FactoryGirl.create(:child) }

    it "shows a child" do
      get :show, {id: child.id}
      expect(response).to render_template :show
      expect(response).to have_http_status(:success) 
      expect(assigns(:child).id).to eq(child.id)
    end

    it "raises an exception for a missing child" do
      assert_raises(ActiveRecord::RecordNotFound) do
        get :show, {id: 99}
      end
    end

  end

end
