class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongo::Followable::Follower
  include Mongoid::Autoinc
  field :user_id, type: Integer
  increments :user_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :initials
  after_find :set_initials
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_and_belongs_to_many :projects, inverse_of: :members, class_name: "Project"
  has_many :tasks
  has_many :projects_created, class_name:"Project", inverse_of: :creator
  has_many :posts
  has_many :comments
  has_many :notifications, foreign_key: :recipient_id

  field :name, type: String
  validates :name, presence: true
  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  def set_initials
		self.initials = self.name.split(' ').first[0] + self.name.split(' ').last[0]
  end
  def tasks_due_soon
  	Task.where('user_id = ? AND due_date >= ?',id,Time.now)
  	.where.not(status:"complete").order(:due_date)
  end
  def all_projects
  	Project.any_of(member_ids: self.id)
  end
end
