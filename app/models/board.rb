class Board < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :majors
  has_many :minors
  validates :body, length: { maximum: 140 }, presence: true
  validates :category, presence: true

  def majors_count
    majors.count
  end
  def minors_count
    minors.count
  end
end
