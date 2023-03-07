class VotesController < ApplicationController
  def index
    @votes = Vote.all.to_a
  end
end
