class User < ApplicationRecord
  has_one_attached :profile_image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_rooms
  has_many :chats
  has_many :rooms, through: :user_rooms
  has_many :group_users 
  has_many :groups, through: :group_users

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed


  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }


  # ユーザーをフォローする
  def follow(user)
    relationships.create(followed_id: user.id)
  end
    # ユーザーのフォローを外す
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end
    # フォロー確認をおこなう
  def following?(user)
    followings.include?(user)
  end

  def get_profile_image
   (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

end
