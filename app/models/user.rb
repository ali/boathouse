class User < ActiveRecord::Base
  attr_accessible :email, :name
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    where(auth.slice('provider', 'uid')).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    logger.debug auth
    logger.debug auth['provider']
    logger.debug auth['uid']
    logger.debug auth['info']['nickname']
    logger.debug auth['info']['name']
    logger.debug auth['info']['email']

    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.handle = auth['info']['nickname']
      user.name = auth['info']['name']
      user.email = auth['info']['email']
    end
  end
end
