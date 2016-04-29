class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_one :character

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.image_url = auth.info.image

      # For spawning zone
      # location = auth.info.location
      # spawn_zone = Geocoder.search(location).first.data['geometry']['bounds']

      # For starting skills
      # work_positions = auth.extra.raw_info.work.map(&:position).map(&:name)
      # education = auth.extra.raw_info.education.map(&:concentration).compact.flatten.map(&:name)

      user.character = Character.create(
        name: user.name,
        lat: Settings['character']['spawn']['lat'],
        lon: Settings['character']['spawn']['lon']
      )
    end
  end
end
