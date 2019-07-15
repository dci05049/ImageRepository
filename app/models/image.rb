class Image < ApplicationRecord
    # validation for discount (not negative , < 100)
    # validation for price (not negative)
    # validate link is present, starts with 'cloudinary with hash'
    # validate the size of url
    validates :link, presence: true
    validates :price, numericality: { greater_than: 0 }
    validate :validate_discount_range

    belongs_to :user

    def price_after_discount 
        price = self.price - self.price * self.discount / 100.00
    end

    def validate_discount_range
        if self.discount < 0 or self.discount > 100
            self.errors.add(:discount , "discount must be in between 0 and 100")
        end
    end
end
