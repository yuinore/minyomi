# frozen_string_literal: true

class WordsController < ApplicationController
  skip_before_action :check_logged_in, only: [:show]

  def index
    @words = Word.includes(:choices).order(:id).to_a
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
    # vote.choice を DB に問い合わせないようにするため vote&.choice_id を使用する
    @checked_choice_id = vote&.choice_id

    # votes まで取得したい場合は以下のようにする
    # @word = Word.includes(:choices, choices: :votes).find_by(slug: params[:slug])

    @sorted_choices = @word.choices.sort_by { |c| [-@percentage[c.id][:total_choice_count], c.id] }
    @can_add_new_choice = (@sorted_choices.size < Choice::MAX_CHOICES_COUNT)
  end
end
