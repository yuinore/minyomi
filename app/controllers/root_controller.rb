# frozen_string_literal: true

class RootController < ApplicationController
  skip_before_action :check_logged_in, only: :index

  def index
  end
end
