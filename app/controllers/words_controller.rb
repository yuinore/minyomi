# frozen_string_literal: true

class WordsController < ApplicationController
  def index
    @words = Word.all.to_a
  end

  def show
    @word = Word.includes(:choices).find_by(slug: params[:slug])

    @total_count = @word.choices.sum { |choice| choice.count + choice.auth_count }

    # votes まで取得したい場合は以下のようにする
    # @word = Word.includes(:choices, choices: :votes).find_by(slug: params[:slug])

    render plain: '404 error', status: :not_found if @word.nil?
  end
end
