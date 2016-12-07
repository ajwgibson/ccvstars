class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.string  :first_name,           null: false
      t.string  :last_name,            null: false
      t.string  :ministry_tracker_id
      t.date    :date_of_birth
      t.boolean :update_required,      default: false
      t.string  :medical_information

      t.timestamps null: false
      t.datetime   :deleted_at
    end
    add_index :children, :deleted_at
  end
end
