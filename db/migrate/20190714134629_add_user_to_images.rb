class AddUserToImages < ActiveRecord::Migration[5.2]
  def change
    add_reference :images, :user, foreign_key: true
  end
end
