require 'digest/sha1'

class User < ActiveRecord::Base

  has_one :profile, :dependent => :destroy

  has_many :statuses, :order => 'created_at DESC', :dependent => :destroy

  # friend
  has_many :friendships, :dependent => :destroy

  has_many :pending_friendships, :class_name => 'Friendship', :conditions => {:status => 0}, :dependent => :destroy

  has_many :accepted_friendships, :class_name => 'Friendship', :conditions => {:status => 1}, :dependent => :destroy

  has_many :intimate_friendships, :class_name => 'Friendship', :conditions => {:status => 2}, :dependent => :destroy

  has_many :pending_friends, :class_name => 'User', :through => :pending_friendships, :source => 'friend'

  has_many :friends, :class_name => 'User', :through => :accepted_friendships, :source => 'friend'

  has_many :intimate_friends, :class_name => 'User', :through => :intimate_friendships, :source => 'friend'

  def has_friend? user
    accepted_friendships.find_by_friend_id user.id
  end

  def wait_for? user
    pending_friendships.find_by_friend_id user.id
  end

  # profile
  has_one :profile, :dependent => :destroy

  # settings
  has_one :privacy_setting, :dependent => :destroy

  has_one :mail_setting, :dependent => :destroy

  has_one :application_setting, :dependent => :destroy

  # game
  has_many :characters, :class_name => 'GameCharacter', :dependent => :destroy

  has_many :games, :through => :characters, :uniq => true

  # album
  belongs_to :avatar

  has_one :avatar_album, :foreign_key => 'owner_id'

  has_many :albums, :class_name => 'PersonalAlbum', :foreign_key => 'owner_id', :order => 'created_at DESC'

  # blogs
  has_many :blogs, :conditions => {:draft => false}, :order => 'created_at DESC', :dependent => :destroy, :foreign_key => :poster_id

  has_many :drafts, :class_name => 'Blog', :conditions => {:draft => true}, :order => 'created_at DESC', :dependent => :destroy, :foreign_key => :poster_id

  # videos
  has_many :videos, :order => 'created_at DESC', :dependent => :destroy, :foreign_key => :poster_id

  # events
  has_many :participations, :foreign_key => 'participant_id', :conditions => "status = 3 or status = 4 or status = 5"

  has_many :event_requests, :foreign_key => 'participant_id', :conditions => {:status => 1}

  has_many :event_invitations, :foreign_key => 'participant_id', :conditions => {:stauts => 0}

  has_many :events, :foreign_key => 'poster_id', :order => 'created_at DESC'

  has_many :upcoming_events, :order => 'created_at DESC', :through => :participations, :source => :event, 
           :conditions => ["events.start_time >= ?", Time.now.to_s(:db)]

  has_many :participated_events, :order => 'created_at DESC', :through => :participations, :source => :event, 
           :conditions => ["events.start_time < ?", Time.now.to_s(:db)]

  # polls
  has_many :votes, :foreign_key => 'subscriber_id'

  has_many :polls, :foreign_key => 'poster_id', :order => 'created_at DESC'

  has_many :participated_polls, :through => :votes, :uniq => true, :source => 'poll', :order => 'created_at DESC'

  attr_accessor :password, :password_confirmation

  # following methods are about privilege

  def has_friend? user
    return true
  end


  # following methods are about authentication

  # callbacks
  before_save :encrypt_password
  before_create :make_activation_code

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :qq, :mobile, :country, :city, :birthday, :gender

  attr_reader :enabled

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token = nil
    save(false)
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end

  def has_role?(name)
    self.roles.find_by_name(name) ? true : false
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def recently_forgot_password?
    @forgotten_password
  end

  def recently_reset_password?
    @reset_password
  end

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = BetaInvitation.find_by_token(token)
  end

protected
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def set_invitation_limit
    self.invitation_limit = 5
  end   
 
end
