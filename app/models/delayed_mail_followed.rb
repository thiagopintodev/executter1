class DelayedMailFollowed < ActiveRecord::Base
  belongs_to :follower_user, :class_name => "User"
end
