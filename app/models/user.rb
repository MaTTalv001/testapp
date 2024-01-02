class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :boards, dependent: :destroy
  has_many :majors
  has_many :minors
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :first_name, length: { maximum: 32 }, presence: true
  validates :last_name, length: { maximum: 32 }, presence: true
  validates :email, uniqueness: true, presence: true
  validates :displayname,length: { maximum: 32 }, presence: true

  def own?(object)
    object.user_id == id
  end

  def total_majors_received
    boards.joins(:majors).count
  end
  def total_minors_received
    boards.joins(:minors).count
  end
end
