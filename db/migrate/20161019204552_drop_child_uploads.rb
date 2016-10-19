class DropChildUploads < ActiveRecord::Migration
  def up
    drop_table :child_uploads
  end
  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
