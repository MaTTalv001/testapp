class Board < ApplicationRecord
  belongs_to :user
  validates :body, length: { maximum: 140 }, presence: true
end
