class AddPermissionToImage < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :public, :boolean, :default => true
  end
end
