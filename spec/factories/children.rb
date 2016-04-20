FactoryGirl.define do
  factory :child do
    first_name          "First"
    last_name           "Last"
    ministry_tracker_id "12345"
    date_of_birth       "2016-04-20"
    update_required     false
    medical_information "Medical details"
  end
end
