class WordsController < ApplicationController
  def index
    @words = Word.all.to_a
  end
end
