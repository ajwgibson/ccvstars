class CreateChildUploads < ActiveRecord::Migration
  def change
    create_table :child_uploads do |t|
      t.string   :filename,       null: false
      t.string   :status
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps null: false
    end
  end
end
