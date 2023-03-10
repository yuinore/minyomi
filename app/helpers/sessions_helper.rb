# frozen_string_literal: true

module SessionsHelper
  def current_user
    return unless (user_id = session[:user_id])

    @current_user ||= User.find_by(id: user_id)
  end

  def login(user)
    # renew session_key to avoid session fixation attack
    session.delete(:session_key)

    session[:user_id] = user.id
  end

  def logout
    session.delete(:session_key)
    session.delete(:user_id)
    @current_user = nil
  end
end
