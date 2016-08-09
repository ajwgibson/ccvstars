class Child < ActiveRecord::Base

    validates :first_name, :presence => true
    validates :last_name,  :presence => true

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
