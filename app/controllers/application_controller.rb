# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_session_key
  before_action :check_logged_in

  def set_session_key
    session[:session_key] ||= OpenSSL::BN.rand(256).to_i.to_s(16)
  end

  def check_logged_in
    return if current_user

    redirect_to root_path
  end
end
