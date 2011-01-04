class Hostness < ActiveRecord::Base
  TYPE_NORMAL = 'normal'
  TYPE_UNIVERSAL = 'universal'
  TYPE_ESCAPE = 'escape'
  TYPES = [TYPE_NORMAL, TYPE_UNIVERSAL, TYPE_ESCAPE]
  validates :user_id, :presence=>true
  validates :hostness_type, :presence=>true
  belongs_to :user
end
