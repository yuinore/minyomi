# frozen_string_literal: true

class ChoicesController < ApplicationController
  def index
    @choices = Choice.all.to_a
  end
end
