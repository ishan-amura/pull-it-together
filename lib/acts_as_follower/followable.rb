module ActsAsFollower #:nodoc:
  module Followable

    module InstanceMethods

      # Returns the number of followers a record has.
      def followers_count
        self.followings.count
      end

      # Allows magic names on followers_by_type
      # e.g. user_followers == followers_by_type('User')
      # Allows magic names on followers_by_type_count
      # e.g. count_user_followers == followers_by_type_count('User')
     

      def respond_to?(m, include_private = false)
        super || m.to_s[/count_(.+)_followers/] || m.to_s[/(.+)_followers/]
      end

 

      # Returns the followings records scoped
      def followers_scoped
        self.followings.to_a.collect{|f| f.follower}
      end

      def followers(options={})
        followers_scope = followers_scoped
        followers_scope = apply_options_to_scope(followers_scope, options)
      end

      # Returns true if the current instance is followed by the passed record
      # Returns false if the current instance is blocked by the passed record or no follow is found
      def followed_by?(follower)
        self.followings.for_follower(follower).first.present?
      end

      def get_follow_for(follower)
        self.followings.for_follower(follower).first
      end

    end
  end
end
