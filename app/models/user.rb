class User < ActiveRecord::Base
  ROLES = %w[systems elder crew crewbie]

  attr_accessible :email, :name, :role
  validates :email, :name, presence: true, uniqueness: true
  validates :role, inclusion: ROLES

  has_merit

  scope :ranked, order('points DESC')
  scope :top_five, ranked.limit(5)

  # The user's % score against everyone else
  def ranked_points
    points.to_f/User.top_ranked.points.to_f * 100
  end

  # Check to see if a user has a certain role
  def is?(rololo)
    role == rololo
  end

  # Get the top-ranked user
  def self.top_ranked
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
      user.role = 'crewbie'
    end
  end
end
