require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ChildrenHelper. For example:
#
# describe ChildrenHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ChildrenHelper, type: :helper do

  describe "date_of_birth" do
    
    it "outputs the date of birth in a short format" do
      child = FactoryGirl.build(:default_child, :date_of_birth => Date.new(2016, 6, 3))
      output = helper.date_of_birth(child)
      expect(output).to have_selector("span.date-of-birth", text: "03/06/2016")
    end

    context "when a record has no date of birth" do
      it "outputs nothing" do
        child = FactoryGirl.build(:default_child, :date_of_birth => nil)
        output = helper.date_of_birth(child)
        expect(output).to be_nil
      end
    end
  end

end
