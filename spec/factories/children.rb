FactoryGirl.define do

  factory :child do
    first_name          nil
    last_name           nil
    ministry_tracker_id nil
    date_of_birth       nil
    update_required     false
    medical_information nil
  end

  factory :default_child, parent: :child do
    first_name          "First"
    last_name           "Last"
  end

  factory :sick_child, parent: :default_child do
    medical_information "Something to worry about"
  end

  factory :update_details_child, parent: :default_child do
    update_required true
  end

end
