require 'rails_helper'
require 'support/controller_macros'

RSpec.describe HomeController, type: :controller do

  login_user

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
