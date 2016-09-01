require 'rails_helper'

RSpec.describe ChildrenController, type: :controller do

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

    it "populates an array of children" do
      child = FactoryGirl.create(:default_child)
      get :index
      expect(assigns(:children)).to eq([child])
    end

    it "orders the children by last_name then first_name" do

      riley_gibson = FactoryGirl.create(:default_child, :last_name => 'Gibson', :first_name => 'Riley')
      daniel_pavey = FactoryGirl.create(:default_child, :last_name => 'Pavey',  :first_name => 'Daniel')
      erin_gibson  = FactoryGirl.create(:default_child, :last_name => 'Gibson', :first_name => 'Erin')

      get :index

      expect(assigns(:children)).to eq([erin_gibson, riley_gibson, daniel_pavey])
    end

    it "applies the 'with_first_name' filter" do
      a = FactoryGirl.create(:default_child, :first_name => 'a')
      b = FactoryGirl.create(:default_child, :first_name => 'b')

      get :index, :with_first_name => 'a'

      expect(assigns(:children)).to eq([a])
    end

    it "applies the 'with_last_name' filter" do
      a = FactoryGirl.create(:default_child, :last_name => 'a')
      b = FactoryGirl.create(:default_child, :last_name => 'b')

      get :index, :with_last_name => 'a'

      expect(assigns(:children)).to eq([a])
    end

    it "applies the 'with_ministry_tracker_id' filter" do
      a = FactoryGirl.create(:default_child, :ministry_tracker_id => '1')
      b = FactoryGirl.create(:default_child, :ministry_tracker_id => '2')

      get :index, :with_ministry_tracker_id => '1'

      expect(assigns(:children)).to eq([a])
    end

    it "applies the 'with_update_required' filter" do
      a = FactoryGirl.create(:default_child, :update_required => true)
      b = FactoryGirl.create(:default_child, :update_required => false)

      get :index, :with_update_required => '1'

      expect(assigns(:children)).to eq([a])
    end

    it "applies the 'with_medical_information' filter" do
      a = FactoryGirl.create(:default_child, :medical_information => 'Something')
      b = FactoryGirl.create(:default_child)

      get :index, :with_medical_information => '1'

      expect(assigns(:children)).to eq([a])
    end

    it "applies the 'with_age' filter" do
      a = FactoryGirl.create(:default_child, :date_of_birth => Date.today - 1.year)
      b = FactoryGirl.create(:default_child, :date_of_birth => Date.today - 2.years)

      get :index, :with_age => 1

      expect(assigns(:children)).to eq([a])
    end

    it "applies multiple filters using 'AND'" do
      aa = FactoryGirl.create(:default_child, :first_name => 'a', :last_name => 'a')
      ab = FactoryGirl.create(:default_child, :first_name => 'a', :last_name => 'b')
      ba = FactoryGirl.create(:default_child, :first_name => 'b', :last_name => 'a')

      get :index, :with_first_name => 'a', :with_last_name => 'a'

      expect(assigns(:children)).to eq([aa])
    end

    it "stores filters to the session" do
      get :index, :with_first_name => 'a', :with_last_name => 'a'
      expect(session[:filter_children]).to eq({'with_first_name' => 'a', 'with_last_name' => 'a'})
    end

    it "retrieves filters from the session if none have been supplied" do
      
      a = FactoryGirl.create(:default_child, :first_name => 'a')
      b = FactoryGirl.create(:default_child, :first_name => 'b')

      get :index, { }, { :filter_children => {'with_first_name' => 'a'} }
      
      expect(assigns(:children)).to eq([a])
    end

  end


  #
  # GET #index
  #
  describe "GET #clear_filter" do
    it "redirects to #index" do
      get :clear_filter
      expect(response).to redirect_to(:children)
    end
    it "clears the 'filter_children' session entry" do
      session[:filter_children] = {'with_first_name' => 'a'}
      get :clear_filter
      expect(session.key?(:filter_children)).to be false
    end
  end

  #
  # GET #show
  #
  describe "GET #show" do
    
    let(:child) { FactoryGirl.create(:default_child) }

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


  #
  # GET #new
  #
  describe "GET #new" do

    it "renders a blank form" do
      get :new
      expect(assigns(:child).id).to be_nil
    end

  end


  #
  # POST #create
  #
  describe "POST #create" do

    context "with valid data" do

      def post_child
        post :create, { child: FactoryGirl.attributes_for(:default_child) }
      end

      it "creates a new child" do
        expect {
          post_child
        }.to change(Child, :count).by(1)
      end

      it "redirects to the show action" do
        post_child
        expect(response).to redirect_to(child_path(assigns(:child)))
      end

      it "set a flash message" do
        post_child
        expect(flash[:notice]).to eq('Child was created successfully.')
      end

    end

    context "with invalid data" do

      def post_child
        post :create, { child: FactoryGirl.attributes_for(:child, :first_name => 'Riley') }
      end

      it "does not create a new child" do
        expect {
          post_child
        }.to_not change(Child, :count)
      end

      it "re-renders the form with the posted data" do
        post_child
        expect(response).to render_template(:form)
        expect(assigns(:child).first_name).to eq('Riley')
      end

    end

  end


  #
  # GET #edit
  #
  describe "GET #edit" do
    
    let(:child) { FactoryGirl.create(:default_child) }

    it "shows a child" do
      get :edit, {id: child.id}
      expect(response).to render_template :form
      expect(response).to have_http_status(:success) 
      expect(assigns(:child).id).to eq(child.id)
    end

    it "raises an exception for a missing child" do
      assert_raises(ActiveRecord::RecordNotFound) do
        get :edit, {id: 99}
      end
    end

  end


  #
  # PUT #update
  #
  describe "PUT #update" do

    context "with valid data" do

      let(:child) { FactoryGirl.create(:default_child) }

      def post_child
        put :update, :id => child.id, :child => { :first_name => 'Changed' }
        child.reload
      end

      it "updates the child's details" do
        post_child
        expect(child.first_name).to eq('Changed')
      end

      it "redirects to the show action" do
        post_child
        expect(response).to redirect_to(child_path(assigns(:child)))
      end

      it "set a flash message" do
        post_child
        expect(flash[:notice]).to eq('Child was updated successfully.')
      end

    end

    context "with invalid data" do

      let(:child) { FactoryGirl.create(:default_child) }

      def post_child
        put :update, :id => child.id, :child => { :first_name => nil }
        child.reload
      end

      it "does not update the child's details" do
        expect(child.first_name).to eq('First')
      end

      it "re-renders the form with the posted data" do
        post_child
        expect(response).to render_template(:form)
        expect(assigns(:child).first_name).to be_nil
      end

    end

  end

  #
  # DELETE #destroy
  #
  describe "DELETE #destroy" do

    let!(:child) { FactoryGirl.create(:default_child) }

    it "soft deletes the child" do
      expect {
        delete :destroy, :id => child.id
      }.to change(Child, :count).by(-1)
      expect(Child.only_deleted.count).to eq(1)
    end

    it "redirects to #index" do
      delete :destroy, :id => child.id
      expect(response).to redirect_to(:children)
    end

  end

end
