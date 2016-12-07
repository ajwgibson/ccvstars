class CreateSignIns < ActiveRecord::Migration
  def change
    create_table :sign_ins do |t|
      t.string     :first_name,   null: false
      t.string     :last_name,    null: false
      t.string     :room,         null: false
      t.datetime   :sign_in_time, null: false
      t.string     :label,        null: false
      t.boolean    :newcomer,     default: false
      t.references :child,        index: true, foreign_key: true

      t.timestamps null: false
      t.datetime   :deleted_at
    end
    add_index :sign_ins, :deleted_at
  end
end
