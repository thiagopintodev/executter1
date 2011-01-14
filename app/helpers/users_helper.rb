module UsersHelper

  def profile_field(user, title, field, value=nil)
    value = user.attributes[field] unless value
    raw "<p><strong>#{h title} </strong> #{h value}</p>" unless value.blank?
  end

end
