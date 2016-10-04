require 'roo'

class ChildUpload < ActiveRecord::Base

  include Filterable

  validates :filename, :presence => true


  def process(io)
      
    file = upload_file(io)

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

    self.finished_at = DateTime.now
    self.status = 'Complete'
    self.save

  end

private

  def upload_file(io)

    folder = Rails.root.join('public', 'uploads')
    Dir.mkdir(folder) unless Dir.exist?(folder)
    
    destination = folder.join(self.filename)

    File.open(destination, 'wb') do |file|
      file.write(io.read)
    end

    destination.to_s
  end

  def parse_date_of_birth(dob)
    if !dob.blank? 
      begin
        return Date.strptime(dob, '%m/%d/%Y')
      rescue ArgumentError
      end
    end
    return nil
  end

end