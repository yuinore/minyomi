# frozen_string_literal: true

class ChoicesController < ApplicationController
  def index
    @choices = Choice.includes(:votes).all.to_a
  end

  def create
    @word = Word.find(params[:word_id])

    # TODO: 403を返す
    return '403' if @word.slug != params[:word_slug]

    if params[:confirmed].nil? || params[:confirmed] != 'true'
      render 'new'
      return # これいる？
    end

    @word.with_lock do
      # TODO: ひらがなのみで構成されているかチェック（カタカナでも良いけど平仮名のほうが好きかも）
      # TODO: 重複チェック

      authenticated = !current_user.nil?

      choice = Choice.create!(
        word: @word,
        name: params[:new_choice],
        count: 0, # authenticated ? 0 : 1,
        auth_count: 0 # authenticated ? 1 : 0,
      )

      if authenticated
        # Vote.create!(choice: choice, authenticated: authenticated, user: current_user, session: nil)
        current_user.save_choice(choice)
      else
        # Vote.create!(choice: choice, authenticated: authenticated, user: nil, session: session[:session_key])
        # choice を 2回 save することになるが一旦許容
        Vote.save_annonymous_choice(choice, session[:session_key])
      end
    end

    redirect_to word_path(@word.slug)
  end
end
