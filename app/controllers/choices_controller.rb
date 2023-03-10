# frozen_string_literal: true

class ChoicesController < ApplicationController
  def index
    @choices = Choice.all.to_a
  end

  def create
    @word = Word.find(params[:word_id])

    # TODO: 403を返す
    return '403' if @word.slug != params[:word_slug]

    if params[:confirmed].nil? || params[:confirmed] != 'true'
      render 'new'
      return # これいる？
    end

    # TODO: ひらがなのみで構成されているかチェック（カタカナでも良いけど平仮名のほうが好きかも）
    # TODO: 重複チェック

    authenticated = !current_user.nil?

    choice = Choice.create!(
      word: @word,
      name: params[:new_choice],
      count: authenticated ? 0 : 1,
      auth_count: authenticated ? 1 : 0
    )

    if authenticated
      # TODO:
    else
      Vote.create!(choice:, authenticated:, user: nil, session: session[:session_key])
    end

    redirect_to word_path(@word.slug)
  end
end
