require 'rails_helper'

RSpec.describe ChartsController, type: :controller do

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

  end

end
