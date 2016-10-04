require 'rails_helper'

RSpec.describe ChildUpload, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:default_child_upload)).to be_valid
  end


  #
  # Validation tests
  #

  it "is invalid without a filename" do
    expect(FactoryGirl.build(:default_child_upload, :filename => "")).not_to be_valid
  end


  #
  # Process tests
  #

  describe "#process" do

    def clear_uploads
      FileUtils.rm Dir.glob(Rails.root.join('public', 'uploads', '*'))
    end

    def upload_file(filename)
      extend ActionDispatch::TestProcess
      fixture_file_upload(
        'files/child_uploads/' + filename, 
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    end

    def process_upload(filename)
      file = upload_file(filename)
      FactoryGirl.build(:default_child_upload, :filename => filename).process(file)
    end


    before(:each) do
      clear_uploads
    end

    after(:each) do
      clear_uploads
    end


    context "when a new ministry tracker id is found" do

      before do 
        process_upload 'one_new_child.xlsx'
        @child = Child.first
        @upload = ChildUpload.first
      end

      it "creates a new child" do
        expect(Child.count).to eq(1)
      end

      it "maps the child's ministry_tracker_id from the PID column" do
        expect(@child.ministry_tracker_id).to eq('1001')
      end

      it "maps the child's last_name from the Person_Lastname column" do
        expect(@child.last_name).to eq('Doe')
      end

      it "maps the child's first_name from the Person_Firstname column" do
        expect(@child.first_name).to eq('John')
      end

      it "maps the child's date_of_birth from the Birthdate column" do
        expect(@child.date_of_birth).to eq(Date.parse('2010-01-21'))
      end

      it "sets ChildUpload finished_at" do
        expect(@upload.finished_at).to_not be(nil)
      end

      it "sets ChildUpload status to be 'Complete'" do
        expect(@upload.status).to eq('Complete')
      end

    end


    context "when a child has no address" do

      before do 
        process_upload 'update_required.xlsx'
        @child = Child.first
      end

      it "sets the child's update_required flag to true" do
        expect(@child.update_required).to be(true)
      end

    end


    context "when a child has an invalid date of birth" do

      before do 
        process_upload 'invalid_date_of_birth.xlsx'
        @child = Child.first
      end

      it "sets the child's date_of_birth to nil" do
        expect(@child.date_of_birth).to be(nil)
      end

    end


    context "when an existing ministry tracker id is found" do

      before do 
        FactoryGirl.create(:default_child, :ministry_tracker_id => '1001')
        process_upload 'one_updated_child.xlsx'
        @child = Child.find_by ministry_tracker_id: '1001'
      end

      it "does not create a new child" do
        expect(Child.count).to eq(1)
      end

      it "updates the child's last_name from the Person_Lastname column" do
        expect(@child.last_name).to eq('Doe')
      end

      it "updates the child's first_name from the Person_Firstname column" do
        expect(@child.first_name).to eq('John')
      end

      it "updates the child's date_of_birth from the Birthdate column" do
        expect(@child.date_of_birth).to eq(Date.parse('2010-01-21'))
      end

      it "updates the child's update_required flag" do
        expect(@child.update_required).to be(true)
      end

    end

  end

end