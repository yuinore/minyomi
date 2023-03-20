# frozen_string_literal: true

class VotesController < ApplicationController
  skip_before_action :check_logged_in, only: [:create]

  def index
    @votes = Vote.all.to_a
  end

  def create
    choice_id_string = params[:choice_id].split('_')[1]
    return render json: { choices: [] } if choice_id_string == 'others'

    choice_id_integer = choice_id_string.to_i

    word = Word.find(params[:word_id].to_i)
    return if word.nil?

    # ロックは必ず Word モデルで行うことにする
    word.with_lock do
      choice = word.choices.detect { |c| c.id == choice_id_integer }
      raise StandardError if word.id != choice.word_id

      if current_user
        current_user.save_choice(choice, word)
      else
        Vote.save_annonymous_choice(choice, word, session[:session_key])
      end
      # vote = Vote.find_or_initialize_by(user: current_user, choice: choice.word.choices.pluck(:id))
      # vote.choice = choice
      # vote.authenticated = true
      # vote.save!
      # Vote.create(authenticated: true, user: current_user, choice: choice)
    end

    percentage = Choice.create_percentage(word.choices)

    render json: { choices: percentage }
  end
end
