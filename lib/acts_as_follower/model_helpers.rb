module Mongoid
	module Document
		def self.included(base)
			base.extend(ClassMethods)
		end

		 module ClassMethods
      def acts_as_follower
        has_many :follows, as: :follower, dependent: :destroy
        include ActsAsFollower::Follower::InstanceMethods
        include ActsAsFollower::FollowerLib
      end
      def acts_as_followable
        has_many :followings, as: :followable, dependent: :destroy, class_name: 'Follow'
        include ActsAsFollower::Followable::InstanceMethods
        include ActsAsFollower::FollowerLib
      end
    end
	end
end