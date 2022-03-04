class AddStorageSizeToPins < ActiveRecord::Migration[6.1]
  def change
    add_column :pins, :storage_size, :bigint, null: true
  end
end
