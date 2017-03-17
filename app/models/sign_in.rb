require 'csv'

class SignIn < ActiveRecord::Base

  acts_as_paranoid

  include Filterable
  include Uploadable
  include HasSortableName

  attr_accessor :skip_child_validation  # Only for import of legacy data

  validates :first_name,   presence: true, if: :newcomer?
  validates :last_name,    presence: true, if: :newcomer?
  validates :child,        presence: true, unless: [:newcomer?, :skip_child_validation?]
  validates :room,         presence: true
  validates :label,        presence: true
  validates :sign_in_time, presence: { message: "and date are required" }

  belongs_to :child

  scope :with_first_name, ->(value) { where("lower(first_name) like lower(?)", "%#{value}%") }
  scope :with_last_name,  ->(value) { where("lower(last_name)  like lower(?)", "%#{value}%") }
  scope :is_newcomer,     ->(value) { where newcomer: value }
  scope :in_room,         ->(value) { where room: value }
  scope :on_or_after,     ->(value) { where("sign_in_time >= ?",  value.beginning_of_day) }
  scope :on_or_before,    ->(value) { where("sign_in_time < ?",   value.end_of_day) }
  scope :for_today,       ->()      { where("date(sign_in_time) = ?", Date.today) }


  def skip_child_validation?
    skip_child_validation
  end


  def self.import(file)

    CSV::HeaderConverters[:sign_in] = lambda { |s|
      s = 'label'            if s == 'Id'
      s = 'first_name'       if s == 'First'
      s = 'last_name'        if s == 'Last'
      s = 'room'             if s == 'Room'
      s = 'sign_in_time'     if s == 'SignedInAt'
      s = 'newcomer'         if s == 'IsNewcomer'
      s = 'update_required'  if s == 'UpdateRequired'
      s
    }

    CSV.foreach(file, headers: true, header_converters: :sign_in, encoding: 'bom|utf-8') do |row|

      if (!row['sign_in_time'].blank?)

        row['sign_in_time']          = parse_sign_in_time row['sign_in_time']
        row['newcomer']              = row['newcomer'] == 'True'
        row['skip_child_validation'] = true

        SignIn.where(row.to_hash.except('update_required','skip_child_validation'))
              .first_or_create(row.to_hash.except('update_required'))

      end

    end

  end


private

  def self.parse_sign_in_time(sign_in_time)
    if !sign_in_time.blank?
      begin
        return DateTime.strptime(sign_in_time, '%d/%m/%Y %H:%M:%S')
      rescue ArgumentError
      end
    end
    return nil
  end

end
