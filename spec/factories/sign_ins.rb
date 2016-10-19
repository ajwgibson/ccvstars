FactoryGirl.define do

  factory :sign_in do
    first_name          nil
    last_name           nil
    room                nil
    sign_in_time        nil
    newcomer            false
    label               nil
    child_id            nil
  end

  factory :default_sign_in, parent: :sign_in do
    first_name          "First"
    last_name           "Last"
    room                "Allstars"
    sign_in_time        DateTime.now
    label               "A1"
  end

end