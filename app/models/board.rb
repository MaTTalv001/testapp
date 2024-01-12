class Board < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :majors, dependent: :destroy
  has_many :minors, dependent: :destroy
  has_many :guest_majors, dependent: :destroy
  validates :body, length: { maximum: 140 }, presence: true
  validates :category, presence: true

  def majors_count
    majors.count
  end
  def minors_count
    minors.count
  end
  def self.ransackable_attributes(auth_object = nil)
    %w[body category created_at majors_count minors_count guest_majors_count total_majors] 
  end
  def self.ransackable_associations(auth_object = nil)
    %w[user majors minors guest_majors] # 検索可能な関連付けをここにリストアップ
  end
  def guest_majors_count
    guest_majors.count
  end
  # 仮想属性の定義
  def total_majors
    majors_count + guest_majors_count
  end

  #ransacker :majors_count do
    #query = '(SELECT COUNT(majors.id) FROM majors WHERE majors.board_id = boards.id GROUP BY majors.board_id)'
    #Arel.sql(query)
  #end
  #
  ransacker :total_majors do
    Arel.sql('majors_count + guest_majors_count')
  end

end
