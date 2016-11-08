class Post
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Autoinc
  field :post_id, type: Integer
  increments :post_id
 	
 	field :title, type: String 
	field :body, type: String 

  belongs_to :project
  belongs_to :user
  has_many :comments, as: :commentable
  include Mongo::Followable::Followed
  after_save :set_creator_as_follower, if: :user_id_changed?
  validates :title,  presence: true, length: {maximum: 200}
  validates :body,length: {maximum: 600}, allow_blank: true
  validates :user_id, presence: true

  def set_creator_as_follower
  	unless self.user.follower_of?(self)
  		self.user.follow(self)
  	end
  end
end
