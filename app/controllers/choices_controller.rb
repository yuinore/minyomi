# frozen_string_literal: true

class ChoicesController < ApplicationController
  def index
    @choices = Choice.all.to_a
  end

  def create
    word = Word.find(params[:word_id])

    # TODO: 403を返す
    return "403" if word.slug != params[:word_slug]

    # TODO: ひらがなのみで構成されているかチェック（カタカナでも良いけど平仮名のほうが好きかも）
    # TODO: 重複チェック

    Choice.create!(
      word: word,
      name: params[:new_choice],
      count: 0,
      auth_count: 0,
    )

    # TODO: Vote.create!

    redirect_to word_path(word.slug)
  end
end
