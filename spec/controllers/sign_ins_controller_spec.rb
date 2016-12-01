require 'rails_helper'

RSpec.describe SignInsController, type: :controller do

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

    it "populates an array of sign_ins" do
      sign_in = FactoryGirl.create(:default_sign_in)
      get :index
      expect(assigns(:sign_ins)).to eq([sign_in])
    end

    it "populates an array of rooms from existing sign_ins" do
      a  = FactoryGirl.create(:default_sign_in, :room => "A")
      c  = FactoryGirl.create(:default_sign_in, :room => "C")
      aa = FactoryGirl.create(:default_sign_in, :room => "A")
      b  = FactoryGirl.create(:default_sign_in, :room => "B")
      get :index
      expect(assigns(:rooms)).to eq(["A","B","C"])
    end

    it "orders the sign_ins by sign_in_time" do

      yesterday = FactoryGirl.create(:default_sign_in, :sign_in_time => 1.days.ago)
      today     = FactoryGirl.create(:default_sign_in, :sign_in_time => 0.days.ago)

      get :index

      expect(assigns(:sign_ins)).to eq([today, yesterday])
    end

    it "applies the 'with_first_name' filter" do
      a = FactoryGirl.create(:default_sign_in, :first_name => 'a')
      b = FactoryGirl.create(:default_sign_in, :first_name => 'b')

      get :index, :with_first_name => 'a'

      expect(assigns(:sign_ins)).to eq([a])
    end

    it "applies the 'with_last_name' filter" do
      a = FactoryGirl.create(:default_sign_in, :last_name => 'a')
      b = FactoryGirl.create(:default_sign_in, :last_name => 'b')

      get :index, :with_last_name => 'a'

      expect(assigns(:sign_ins)).to eq([a])
    end

    it "applies the 'is_newcomer' filter" do
      a = FactoryGirl.create(:default_sign_in, :newcomer => true)
      b = FactoryGirl.create(:default_sign_in, :newcomer => false)

      get :index, :is_newcomer => true

      expect(assigns(:sign_ins)).to eq([a])
    end

    it "applies the 'in_room' filter" do
      a = FactoryGirl.create(:default_sign_in, :room => 'a')
      b = FactoryGirl.create(:default_sign_in, :room => 'b')

      get :index, :in_room => 'a'

      expect(assigns(:sign_ins)).to eq([a])
    end

    it "applies the 'on_or_after' filter" do
      a = FactoryGirl.create(:default_sign_in, :sign_in_time => 3.days.ago)
      b = FactoryGirl.create(:default_sign_in, :sign_in_time => 1.days.ago)

      get :index, :on_or_after => 2.days.ago

      expect(assigns(:sign_ins)).to eq([b])
    end

    it "applies the 'on_or_before' filter" do
      a = FactoryGirl.create(:default_sign_in, :sign_in_time => 3.days.ago)
      b = FactoryGirl.create(:default_sign_in, :sign_in_time => 1.days.ago)

      get :index, :on_or_before => 2.days.ago

      expect(assigns(:sign_ins)).to eq([a])
    end

    it "stores filters to the session" do
      get :index, :with_first_name => 'a', :with_last_name => 'a'
      expect(session[:filter_sign_ins]).to eq({'with_first_name' => 'a', 'with_last_name' => 'a'})
    end

    it "removes blank filter values" do
      get :index, :with_first_name => 'a', :with_last_name => ''
      expect(assigns(:filter)).to eq({'with_first_name' => 'a'})
    end

    it "retrieves filters from the session if none have been supplied" do

      a = FactoryGirl.create(:default_sign_in, :first_name => 'a')
      b = FactoryGirl.create(:default_sign_in, :first_name => 'b')

      get :index, { }, { :filter_sign_ins => {'with_first_name' => 'a'} }

      expect(assigns(:sign_ins)).to eq([a])
    end

  end


  #
  # GET #clear_filter
  #
  describe "GET #clear_filter" do
    it "redirects to #index" do
      get :clear_filter
      expect(response).to redirect_to(:sign_ins)
    end
    it "clears the session entry" do
      session[:filter_sign_ins] = {'with_first_name' => 'a'}
      get :clear_filter
      expect(session.key?(:filter_sign_ins)).to be false
    end
  end


  #
  # GET #import
  #
  describe "GET #import" do

    it "renders a file_upload form" do
      get :import
      expect(assigns(:file_upload).filename).to be_nil
    end

  end


  #
  # GET #new
  #
  describe "GET #new" do

    it "renders a blank form" do
      get :new
      expect(assigns(:sign_in).id).to be_nil
    end

    it "sets the heading to 'Add a sign in record'" do
      get :new
      expect(assigns(:heading)).to eq('Add a sign in record')
    end

  end


  #
  # POST #create
  #
  describe "POST #create" do

    context "with valid data" do

      def post_sign_in
        attrs = FactoryGirl.attributes_for(:newcomer_sign_in)
        sign_in_time = attrs.delete(:sign_in_time)
        post :create, { sign_in: attrs, the_date: sign_in_time.to_date, the_time: sign_in_time.to_time  }
      end

      it "creates a new record" do
        expect {
          post_sign_in
        }.to change(SignIn, :count).by(1)
      end

      it "redirects to the index action" do
        post_sign_in
        expect(response).to redirect_to(sign_ins_path())
      end

      it "set a flash message" do
        post_sign_in
        expect(flash[:notice]).to eq('Sign in record was created successfully.')
      end

    end

    context "for an existing child" do

      let(:child) { FactoryGirl.create(:default_child, :first_name => 'c', :last_name => 'd') }

      def post_sign_in
        attrs = FactoryGirl.attributes_for(:default_sign_in,
                                           :first_name => 'a', :last_name => 'b')
        sign_in_time = attrs.delete(:sign_in_time)
        attrs[:child_id] = child.id
        post :create, { sign_in: attrs, the_date: sign_in_time.to_date, the_time: sign_in_time.to_time  }
      end

      it "gets the first and last names from the child record" do
        post_sign_in
        sign_in = SignIn.first
        expect(sign_in.first_name).to eq('c')
        expect(sign_in.last_name).to eq('d')
      end

    end

    context "with invalid data" do

      def post_sign_in
        attrs = FactoryGirl.attributes_for(:sign_in, :label => 'A label')
        post :create, { sign_in: attrs, the_date: "2016-11-11", the_time: "17:45:59"  }
      end

      it "does not create a new record" do
        expect {
          post_sign_in
        }.to_not change(SignIn, :count)
      end

      it "re-renders the form with the posted data" do
        post_sign_in
        expect(response).to render_template(:form)
        expect(assigns(:sign_in).label).to eq('A label')
        expect(assigns(:the_date)).to eq('2016-11-11')
        expect(assigns(:the_time)).to eq('17:45:59')
      end

    end

  end

end
