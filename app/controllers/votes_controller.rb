# frozen_string_literal: true

class VotesController < ApplicationController
  def index
    @votes = Vote.all.to_a
  end
end
