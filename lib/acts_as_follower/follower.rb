module ActsAsFollower #:nodoc:
  module Follower

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_follower
        has_many :follows, as: :follower, dependent: :destroy
        include ActsAsFollower::Follower::InstanceMethods
        include ActsAsFollower::FollowerLib
      end
    end

    module InstanceMethods

      # Returns true if this instance is following the object passed as an argument.
      def following?(followable)
        0 < Follow.for_follower(self).for_followable(followable).count
      end

      # Returns the number of objects this instance is following.
      def follow_count
        Follow.for_follower(self).count
      end

      # Creates a new follow record for this instance to follow the passed object.
      # Does not allow duplicate records to be created.
      def follow(followable)
        if self != followable
          params = {
          	followable: followable,
          	follower:self}
          self.follows.find_or_create_by(params)
        end
      end

      # Deletes the follow record if it exists.
      def unfollow(followable)
        if follow = get_follow(followable)
          follow.destroy
        end
      end

      # returns the follows records to the current instance
      def follows_scoped
        self.follows.to_a.collect{|f| f.followable }
      end

      # Returns the follow records related to this instance with the followable included.
      def all_follows(options={})
        follows_scope = follows_scoped
        follows_scope = apply_options_to_scope(follows_scope, options)
      end

      # Returns the actual records which this instance is following.
      def all_following(options={})
        all_follows(options).collect{ |f| f.followable }
      end

      def respond_to?(m, include_private = false)
        super || m.to_s[/following_(.+)_count/] || m.to_s[/following_(.+)/]
      end

      # Returns a follow record for the current instance and followable object.
      def get_follow(followable)
        self.follows.for_followable(followable).first
      end

    end
  end
end
