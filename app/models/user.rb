# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  name            :string           default("New User"), not null
#  age             :integer          default(25), not null
#  language        :string           default("Spanish"), not null
#  language_level  :integer          default(3), not null
#  password_digest :string           not null
#  session_token   :string           not null
#  image           :string
#  active          :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string           default("Please fill in your profession"), not null
#  provider        :string
#  uid             :string
#  location        :string
#

#active is for instantaneous feature Tati talked about

class User < ApplicationRecord
  validates :email, :session_token, :age, :language, presence: true
  validates :email, uniqueness: true
  validates :email, length: {maximum: 255}
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :password, length: { minimum: 5, maximum: 50, allow_nil: true }
  validates :title, length: {minimum: 5, maximum: 255}
  validates :name, length: {minimum: 2, maximum: 255}
  validates :age, numericality: { only_integer: true }
  validates :language_level, numericality: {only_integer: true} #may change this since it's a dropdown
  has_secure_password
  mount_uploader :image, AvatarUploader
  has_many :notifications, :foreign_key => :notified_id, dependent: :destroy
  has_many :created_notifications, :foreign_key => :notifier_id, class_name: 'Notification', dependent: :destroy
  has_many :initiated_chat_rooms, :foreign_key => :initiator_id, class_name: 'ChatRoom', dependent: :destroy
  has_many :received_chat_rooms, :foreign_key => :recipient_id, class_name: 'ChatRoom', dependent: :destroy
  has_many :sent_messages, :foreign_key => :sender_id, class_name: 'Message', dependent: :destroy
  has_one :linkedin, dependent: :destroy

  attr_reader :password
  after_initialize :ensure_session_token

  def self.find_by_credentials(user_params)
    user = User.find_by_email(user_params[:email])
    user.try(:is_password?, user_params[:password]) ? user : nil
  end

  def self.create_with_omniauth(auth)
    # ensures email uniqueness validation through if statement in previous method
    # will set password as uid, hack job need to refactor
    # taking the first public Url image, assuming this is the most recent
    user = User.create!(
      email: auth['info']['email'],
      password: auth['uid'],
      name: auth['info']['name'],
      title: auth['info']['description'],
      image: auth['extra']['raw_info']['pictureUrls'].values.second[0],
      location: auth['info']['location']['name'],
      provider: auth['provider'],
      uid: auth['uid']
    )
    # may implement positions, specialties and more once these start working
    Linkedin.create!(
      user_id: user.id,
      public_url: auth['info']['urls'].public_profile,
      industry: auth['extra']['raw_info']['industry'],
      summary: auth['extra']['raw_info']['summary']
    )
    # flast[:success] = "Welcome to smartXchange!"
    user
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  def appear
    p "appear called in user"
    self.active = true
    self.save!
  end

  def disappear
    p "disappear called in user"
    self.active = false
    self.save!
  end

  def add_with_omniauth(auth)
    # doesn't need error messages because fields can be blank (except Linkedin user_id which should not throw error unless there is no current_user in which case there would be an error earlier on)
    self.update(
      location: auth['info']['location']['name'],
      provider: auth['provider'],
      uid: auth['uid']
    )
    Linkedin.create!(
      user_id: self.id,
      public_url: auth['info']['urls'].public_profile,
      industry: auth['extra']['raw_info']['industry'],
      summary: auth['extra']['raw_info']['summary']
    )
  end

  def update_with_omniauth(auth)
    # doesn't need error messages because fields can be blank
    # keeping provider and uid there because maybe the person has a new linkedin account
    # not updating password if uid changes because user might have sign in without linkedin
    self.update(
      location: auth['info']['location']['name'],
      provider: auth['provider'],
      uid: auth['uid']
    )
    self.linkedin.update(
      public_url: auth['info']['urls'].public_profile,
      industry: auth['extra']['raw_info']['industry'],
      summary: auth['extra']['raw_info']['summary']
    )
  end

  protected

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end


end
