class WordsController < ApplicationController
  def index
    @words = Word.all.to_a
  end

  def show
    @word = Word.includes(:choices).find_by(slug: params[:slug])

    render plain: '404 error', status: 404 if @word.nil?
  end
end
