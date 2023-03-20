# frozen_string_literal: true

class ChoicesController < ApplicationController
  def index
    @choices = Choice.includes(:votes).order(:id).to_a
  end

  def create
    @word = Word.find(params[:word_id])

    return render plain: '403', status: :forbidden if @word.slug != params[:word_slug]

    if params[:confirmed].nil? || params[:confirmed] != 'true'
      if @word.choices.map(&:name).include?(params[:new_choice])
        return render plain: 'エラー：選択肢がすでに存在しています。', status: :forbidden
      end

      return render 'new'
    end

    # ロックは必ず controller で行い、Word モデルに対して行うことにする
    @word.with_lock do
      authenticated = !current_user.nil?

      # choice を 2回 save することになるが、バグ混入リスク回避のため一旦許容
      choice = Choice.create!(
        word: @word,
        name: params[:new_choice],
        count: 0,
        auth_count: 0
      )

      if authenticated
        current_user.save_choice(choice)
      else
        Vote.save_annonymous_choice(choice, session[:session_key])
      end
    end

    redirect_to word_path(@word.slug)
  end
end
