class User < ApplicationRecord
  has_many :images
  has_one :inventory
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def add_balance(amount)
    new_balance = balance + amount
    self.update_attribute(:balance, new_balance)
  end

  def subtract_balance(amount)
    new_balance = balance - amount
    self.update_attribute(:balance, new_balance)
  end
end
