class Subject < ActiveRecord::Base
  belongs_to :user, :counter_cache=>true
  has_many :posts
end
