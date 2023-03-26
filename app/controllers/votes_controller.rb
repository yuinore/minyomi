# frozen_string_literal: true

class VotesController < ApplicationController
  skip_before_action :check_logged_in, only: [:create]

  def index
    return render plain: '403', status: :forbidden unless current_user&.admin?

    @votes = Vote.order(:id).limit(10000).to_a
  end

  def create
    choice_id_string = params[:choice_id].split('_')[1]
    return render json: { choices: [] } if choice_id_string == 'others'

    choice_id_integer = choice_id_string.to_i

    word = Word.find(params[:word_id].to_i)
    return if word.nil?

    # ロックは必ず controller で行い、Word モデルに対して行うことにする
    word.with_lock do
      choice = word.choices.detect { |c| c.id == choice_id_integer }
      raise StandardError if word.id != choice.word_id

      if current_user
        current_user.save_choice(choice)
      else
        Vote.save_annonymous_choice(choice, session[:session_key])
      end
    end

    percentage = Choice.create_percentage(word.choices)

    render json: { choices: percentage }
  end
end
