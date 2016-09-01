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


  describe "sortable" do

    it "creates a hyperlink using the children path" do
      output = helper.sortable("column", { })
      expect(output).to include('<a href="/children')
    end

    it "uses a titleized version of the column name as the link text by default" do
      output = helper.sortable("column_name", { })
      expect(output).to include('Column Name')
    end

    it "uses an explicit title as the link text if specified" do
      output = helper.sortable("column_name", { }, 'Something different')
      expect(output).to include('Something different')
    end

    context "with no current order_by" do
      it "creates a link with a order_by based on the specified column" do
        output = helper.sortable("column", { }, "Column name")
        expect(output).to include("order_by=column")
      end
    end

    context "with a different current order_by" do
      it "creates a link with a order_by based on the specified column" do
        output = helper.sortable("column", { :order_by => 'other_column' }, "Column name")
        expect(output).to include("order_by=column")
      end
    end

    context "with current order_by" do
      it "creates a link with a order_by based on the specified column descending" do
        output = helper.sortable("column", { :order_by => 'column' })
        expect(output).to include("order_by=column+desc")
      end
    end

    context "with current order_by descending" do
      it "creates a link with a order_by based on the specified column" do
        output = helper.sortable("column", { :order_by => 'column desc' })
        expect(output).to include("order_by=column")
        expect(output).not_to include("+desc")
      end
    end

    context "with multiple, comma-separated, order_by criteria" do
      it "still works!" do
        output = helper.sortable("column1,column2", { :order_by => 'column1,column2' })
        expect(output).to include("order_by=column1+desc%2Ccolumn2+desc")
      end
    end

  end

end
