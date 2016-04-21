FactoryGirl.define do

  factory :child do
    first_name          "First"
    last_name           "Last"
    ministry_tracker_id nil
    date_of_birth       nil
    update_required     false
    medical_information nil
  end

  factory :sick_child, parent: :child do
    medical_information "Something to worry about"
  end

  factory :update_details_child, parent: :child do
    update_required true
  end


end
