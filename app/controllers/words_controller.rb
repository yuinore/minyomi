# frozen_string_literal: true

class WordsController < ApplicationController
  skip_before_action :check_logged_in, only: [:show]

  def index
    @words = Word.includes(:choices).all.to_a
  end

  def show
    @word = Word.includes(:choices).find_by(slug: params[:slug])
    return render plain: '404 error', status: :not_found if @word.nil?

    @percentage = Choice.create_percentage(@word.choices).index_by { |x| x[:id] }

    vote = if current_user
             current_user.votes.find_by(choice: @word.choices.pluck(:id))
           else
             Vote.find_by(choice: @word.choices.pluck(:id), session: session[:session_key])
           end
    @checked_choice_id = vote&.choice&.id

    # votes まで取得したい場合は以下のようにする
    # @word = Word.includes(:choices, choices: :votes).find_by(slug: params[:slug])
  end
end
