# frozen_string_literal: true

class WordsController < ApplicationController
  def index
    @words = Word.all.to_a
  end

  def show
    @word = Word.includes(:choices).find_by(slug: params[:slug])

    render plain: '404 error', status: :not_found if @word.nil?
  end
end
