class Child < ActiveRecord::Base

    include Filterable

    validates :first_name, :presence => true
    validates :last_name,  :presence => true

    scope :with_first_name, -> (name) { where("lower(first_name) like lower(?)", "%#{name}%") }
    scope :with_last_name, -> (name) { where("lower(last_name) like lower(?)", "%#{name}%") }
    scope :with_ministry_tracker_id, -> (id) { where ministry_tracker_id: id }
    scope :with_update_required, ->(value) { where("update_required", value)}
    scope :with_medical_information, ->(value) { where("medical_information <> ''")}
    scope :with_age, ->(value) { where(date_of_birth: (Date.today - (value.to_i + 1).years + 1.day) .. (Date.today - value.to_i.years)) }

    def age
      return nil unless date_of_birth
      result = Date.today.year - date_of_birth.year
      result = result - 1 if Date.today < date_of_birth + result.years
      result
    end

    def name
      result = "#{last_name}, #{first_name}"
      result = result.chomp(', ')
      result = result.reverse.chomp(',').reverse
      result.strip
    end
end
