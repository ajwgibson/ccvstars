class AddDeletedAtToChildren < ActiveRecord::Migration
  def change
    add_column :children, :deleted_at, :datetime
    add_index :children, :deleted_at
  end
end
