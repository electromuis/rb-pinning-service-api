class AddStorageLimitAndUsedStorageToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :storage_limit, :bigint, default: 0
    add_column :users, :used_storage, :bigint, default: 0
  end
end
