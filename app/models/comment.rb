class Comment
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Autoinc
	field :comment_id, type: Integer
  increments :comment_id
	field :body, type: String
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true, length: {maximum: 300}
  validates :user, presence: true
end
