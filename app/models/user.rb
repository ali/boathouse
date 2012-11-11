class User < ActiveRecord::Base
  attr_accessible :email, :name
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  has_merit

  scope :ranked, order('points DESC')
  scope :top_five, ranked.limit(5)

  # The user's % score against everyone else
  def ranked_points
    points/User.koth.points * 100
  end

  def self.koth
    User.ranked.limit(1).first
  end

  def self.from_omniauth(auth)
    where(auth.slice('provider', 'uid')).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.handle = auth['info']['nickname']
      user.name = auth['info']['name']
      user.email = auth['info']['email']
    end
  end
end
