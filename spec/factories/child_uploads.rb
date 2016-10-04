FactoryGirl.define do

  factory :child_upload do
    filename    nil
    status      nil
    started_at  nil
    finished_at nil
  end

  factory :default_child_upload, parent: :child_upload do
    filename          "filename.xslx"
  end

end