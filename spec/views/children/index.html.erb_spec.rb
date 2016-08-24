require 'rails_helper'
require 'spec_helper'

RSpec.describe "children/index.html.erb", type: :view, stub_kaminari: true do


  def paginate(children)
    allow(children).to receive(:total_pages).and_return(1)
    allow(children).to receive(:current_page).and_return(1)
    allow(children).to receive(:limit_value).and_return(1)
    assign(:children, children)
  end




  before(:each) do
    assign(:filter, {})
  end

  

  context 'when a child has a date of birth' do

    it 'displays the date using the format dd/mm/yyyy' do
      paginate([FactoryGirl.create(:default_child, :date_of_birth => Date.new(2016, 6, 3))])
      render
      expect(rendered).to have_css(".date-of-birth", text: "03/06/2016")
    end

    it "displays the child's age" do
      paginate([FactoryGirl.create(:default_child, :date_of_birth => Date.today - 4.years)])
      render
      expect(rendered).to have_css(".age", text: "4")
    end

  end

  context 'when a child has medical information' do

    before(:each) do
      paginate([FactoryGirl.create(:sick_child)])
      render
    end

    it 'displays a warning' do
      expect(rendered).to have_selector(".medical-warning")
    end

    it 'displays a tooltip describing the warning' do
      element = Capybara.string(rendered).find(".medical-warning")
      expect(element['data-toggle']).to eq("tooltip")
      expect(element['title']).to eq("Medical information available")
    end

  end

  context "when a child's details need to be updated" do

    before(:each) do
      paginate([FactoryGirl.create(:update_details_child)])
      render
    end

    it 'displays a warning' do
      expect(rendered).to have_selector(".update-details-warning")
    end

    it 'displays a tooltip describing the warning' do
      element = Capybara.string(rendered).find(".update-details-warning")
      expect(element['data-toggle']).to eq("tooltip")
      expect(element['title']).to eq("Update required")
    end

  end

end
