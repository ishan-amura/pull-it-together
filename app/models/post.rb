class Post
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Autoinc
	include ActsAsFollower::Follower
  include ActsAsFollower::Followable
  field :post_id, type: Integer
  increments :post_id
 	
 	field :title, type: String 
	field :body, type: String 

  belongs_to :project
  belongs_to :user
  has_many :comments, as: :commentable

  after_save :set_creator_as_follower, if: :user_id_changed?
  validates :title,  presence: true, length: {maximum: 200}
  validates :body,length: {maximum: 600}, allow_blank: true
  validates :user_id, presence: true
  acts_as_followable


  def set_creator_as_follower
  	unless self.user.following?(self)
  		self.user.follow(self)
  	end
  end
end
