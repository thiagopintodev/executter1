class Hostness < ActiveRecord::Base
  #TYPES = ['normal','universal','escape']
  TYPES = ['normal']
  validates :user_id, :presence=>true
  validates :hostness_type, :presence=>true
  belongs_to :user
end
