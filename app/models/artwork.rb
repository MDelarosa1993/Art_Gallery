class Artwork < ApplicationRecord
  belongs_to :user
  has_many :order_items
end
