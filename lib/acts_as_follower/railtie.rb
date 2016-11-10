require 'rails'

module ActsAsFollower
  class Railtie < Rails::Railtie

    initializer "acts_as_follower.active_model" do |app|
      ActiveSupport.on_load :active_model do
      	puts "==============="
      	puts "ActiveModel Gets Initialized"
      	puts "==============="
        include ActsAsFollower::Follower
        include ActsAsFollower::Followable
      end
    end

  end
end
