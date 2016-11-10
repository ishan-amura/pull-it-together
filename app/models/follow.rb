class Follow
	include Mongoid::Document
	include Mongoid::Timestamps
  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  # NOTE: Follows belong to the "followable" and "follower" interface
  belongs_to :followable, :polymorphic => true
  belongs_to :follower,   :polymorphic => true
  

  index({follower_id:1, follower_type: 1},{name: "fk_follows", unique: true})
  index({followable_id:1, followable_type: 1},{name: "fk_followables", unique: true})

end
