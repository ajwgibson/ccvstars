FactoryGirl.define do

  factory :sign_in do
    first_name          nil
    last_name           nil
    room                nil
    sign_in_time        nil
    newcomer            false
    label               nil
  end

  factory :default_sign_in, parent: :sign_in do
    first_name          "First"
    last_name           "Last"
    room                "Allstars"
    sign_in_time        DateTime.now.change(:sec => 0)
    label               "A1"

    association :child, factory: :default_child
  end

  factory :newcomer_sign_in, parent: :default_sign_in do
    newcomer true
    child nil
  end

end
