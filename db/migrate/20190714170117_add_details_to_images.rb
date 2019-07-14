class AddDetailsToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :price, :integer, :default => 0
    add_column :images, :discount, :integer, :default => 0
    add_column :images, :purchased, :boolean, :default => false
  end
end
