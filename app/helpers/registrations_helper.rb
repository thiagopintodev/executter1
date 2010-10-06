module RegistrationsHelper

  def my_error_msg(model, field)
    raw "<div class='alert'>#{model.errors[field].to_sentence}</div>" if model.errors[field].size > 0
  end

end
