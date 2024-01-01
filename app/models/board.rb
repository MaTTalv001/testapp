class Board < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  validates :body, length: { maximum: 140 }, presence: true
end
