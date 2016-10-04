require 'rails_helper'

RSpec.describe ChildUploadsController, type: :controller do

  login_user

  #
  # GET #index
  #
  describe "GET #index" do
    
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end

    it "populates an array of uploads" do
      upload = FactoryGirl.create(:default_child_upload)
      get :index
      expect(assigns(:uploads)).to eq([upload])
    end

    it "orders the uploads by created_at descending" do

      upload_1 = FactoryGirl.create(:default_child_upload, :created_at => 2.days.ago)
      upload_2 = FactoryGirl.create(:default_child_upload, :created_at => 1.days.ago)

      get :index

      expect(assigns(:uploads)).to eq([upload_2, upload_1])
    end

  end


  #
  # GET #new
  #
  describe "GET #new" do

    it "renders a blank form with title 'New upload'" do
      get :new
      expect(assigns(:upload).id).to be_nil
      expect(assigns(:heading)).to eq('New upload')
    end

  end


  #
  # GET #show
  #
  describe "GET #show" do
    
    let(:upload) { FactoryGirl.create(:default_child_upload) }

    it "shows a child upload" do
      get :show, {id: upload.id}
      expect(response).to render_template :show
      expect(response).to have_http_status(:success) 
      expect(assigns(:upload).id).to eq(upload.id)
    end

    it "raises an exception for a missing child upload" do
      assert_raises(ActiveRecord::RecordNotFound) do
        get :show, {id: 99}
      end
    end

  end

end