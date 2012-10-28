class User < ActiveRecord::Base
  has_merit

  attr_accessible :email, :name
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

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

    create_sash_if_none
  end
end
