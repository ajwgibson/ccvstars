class Child < ActiveRecord::Base

  acts_as_paranoid
  
  include Filterable
  include HasSortableName


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


  def self.import(file)
      
    xlsx = Roo::Excelx.new(file)

    xlsx.each(
        ministry_tracker_id: 'PID', 
        last_name:           'Person_Lastname', 
        first_name:          'Person_Firstname', 
        address:             'street_address', 
        dob:                 'Birthdate'
      ) do |hash|
      
      ministry_tracker_id = hash[:ministry_tracker_id]

      if (!ministry_tracker_id.eql?('PID'))

        hash['date_of_birth']   = parse_date_of_birth hash[:dob]
        hash['update_required'] = hash[:address].blank? || hash[:dob].blank?
        
        hash.delete :dob
        hash.delete :address
        
        Child.where(ministry_tracker_id: ministry_tracker_id).first_or_initialize.tap do |child|
          child.attributes = hash
          child.save
        end
      end

    end

  end


private

  def self.parse_date_of_birth(dob)
    if !dob.blank? 
      begin
        return Date.strptime(dob, '%m/%d/%Y')
      rescue ArgumentError
      end
    end
    return nil
  end

end
