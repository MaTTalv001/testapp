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
  def self.ransackable_attributes(auth_object = nil)
    %w[body category created_at majors_count minors_count] 
  end
  def self.ransackable_associations(auth_object = nil)
    %w[user majors minors] # 検索可能な関連付けをここにリストアップ
  end

  #ransacker :majors_count do
    #query = '(SELECT COUNT(majors.id) FROM majors WHERE majors.board_id = boards.id GROUP BY majors.board_id)'
    #Arel.sql(query)
  #end


end
