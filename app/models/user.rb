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
#

#active is for instantaneous feature Tati talked about

class User < ActiveRecord::Base
  validates :email, :session_token, :age, :language, presence: true
  validates :email, uniqueness: true
  validates :email, length: {maximum: 255}
  validates :password, length: { minimum: 5, maximum: 50, allow_nil: true }
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :title, length: {minimum: 5, maximum: 255}
  validates :name, length: {minimum: 2, maximum: 255}
  validates :age, numericality: { only_integer: true }
  validates :language_level, numericality: {only_integer: true} #may change this since it's a dropdown
  has_secure_password
  mount_uploader :image, AvatarUploader
  has_many :initiated_chats, :foreign_key => :sender_id, class_name: 'Chat', dependent: :destroy
  has_many :received_chats, :foreign_key => :recipient_id, class_name: 'Chat', dependent: :destroy
  has_many :notifications, :foreign_key => :notified_id, dependent: :destroy
  has_many :created_notifications, :foreign_key => :notifier_id, class_name: 'Notification', dependent: :destroy

  attr_reader :password
  after_initialize :ensure_session_token

  def self.find_by_credentials(user_params)
    user = User.find_by_email(user_params[:email])
    user.try(:is_password?, user_params[:password]) ? user : nil
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

  protected

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

end
