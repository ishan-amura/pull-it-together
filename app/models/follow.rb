class Follow
	include Mongoid::Document
	include Mongoid::Timestamps

	belongs_to :followable, polymorphic: true
	belongs_to :follower, polymorphic: true

	def follow(model)
		
	end	
end