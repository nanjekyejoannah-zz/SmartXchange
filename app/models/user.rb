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
#  latitude        :float
#  longitude       :float
#  nationality     :string           default("Spanish"), not null
#

#active is for instantaneous feature Tati talked about

class User < ApplicationRecord
  validates_presence_of :email, :name, :age, :language, :language_level, :title, :password_digest, :session_token, :nationality
  validates :email, uniqueness: true, length: {maximum: 255}, format: {:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/i, on: :create}
  validates :password, length: { minimum: 5, maximum: 50, allow_nil: true }
  validates :title, length: {minimum: 5, maximum: 255}
  validates :name, length: {minimum: 2, maximum: 255}
  validates :age, numericality: { only_integer: true }
  validates :language_level, numericality: {only_integer: true} #may change this since it's a dropdown
  mount_uploader :image, AvatarUploader

  has_many :notifications, :foreign_key => :notified_id, dependent: :destroy
  has_many :created_notifications, :foreign_key => :notifier_id, class_name: 'Notification', dependent: :destroy
  has_many :posts_notifications, -> { where read: false, notifiable_type: 'Post'}, :foreign_key => :notified_id, class_name: 'Notification'
  has_many :chat_rooms_notifications, -> { where read: false, notifiable_type: 'ChatRoom'}, :foreign_key => :notified_id, class_name: 'Notification'
  # may want to refactor these into one so you can call .chat_rooms for each user
  has_many :initiated_chat_rooms, :foreign_key => :initiator_id, class_name: 'ChatRoom', dependent: :destroy
  has_many :received_chat_rooms, :foreign_key => :recipient_id, class_name: 'ChatRoom', dependent: :destroy
  has_many :sent_messages, :foreign_key => :sender_id, class_name: 'Message', dependent: :destroy
  has_one :linkedin, dependent: :destroy
  has_many :posts, :foreign_key => :owner_id, class_name: 'Post', dependent: :destroy
  has_many :comments, :foreign_key => :owner_id, class_name: 'Comment', dependent: :destroy
  has_many :votes, :foreign_key => :owner_id, class_name: 'Vote', dependent: :destroy
  has_many :follows, :foreign_key => :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followed_posts, through: :follows, source: :followable, source_type: 'Post'
  has_many :reads, dependent: :destroy
  has_many :read_boards, through: :reads, source: :readable, source_type: 'Board'

  geocoded_by :location

  before_save :downcase_email
  after_validation :geocode, if: :location_present_and_changed

  default_scope -> { order(created_at: :asc) } #may refactor take this out, asc want longest users around first

  attr_reader :password
  after_initialize :ensure_session_token

  def self.find_by_credentials(user_params)
    user = User.find_by_email(user_params[:email].downcase)
    user.try(:is_password?, user_params[:password]) ? user : nil
  end

  def self.create_with_omniauth(auth)
    # ensures email uniqueness validation through if statement in previous method
    # will set password as uid, hack job need to refactor
    # taking the first public Url image, assuming this is the most recent, not working at moment refactor
    user = User.create!(
      email: auth['info']['email'],
      password: auth['uid'],
      name: auth['info']['name'],
      title: auth['info']['description'],
      image: auth['extra']['raw_info']['pictureUrls'].values.second[0],
      provider: auth['provider'],
      uid: auth['uid'],
      location: auth['info']['location']['name']
    )
    # may implement positions, specialties and more once these start working
    Linkedin.create!(
      user_id: user.id,
      public_url: auth['info']['urls'].public_profile,
      industry: auth['extra']['raw_info']['industry'],
      summary: auth['extra']['raw_info']['summary']
    )
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
      provider: auth['provider'],
      uid: auth['uid'],
      location: auth['info']['location']['name']
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
      provider: auth['provider'],
      uid: auth['uid'],
      location: auth['info']['location']['name']
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

  def downcase_email
    self.email = self.email.downcase
  end

  def location_present_and_changed
    return true if (self.location.present? && self.location_changed?)
    false
  end


end
