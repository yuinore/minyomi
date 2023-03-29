# frozen_string_literal: true

class WordsController < ApplicationController
  skip_before_action :check_logged_in, only: [:index, :show]

  def index
    @words_index = Word.order(:id).pluck(:name, :slug).group_by { |name, _slug| name[0].downcase }.sort
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

  def new
    @confirming = false
    @confirmed = false
  end

  def create
    @new_word = params[:new_word].strip.squeeze(' ')

    @slug = @new_word
            .downcase
            .tr(' ', '_')
            .tr('/', '_')
            .gsub(/#/, 'sharp')
            .gsub(/\+/, 'plus')
            .gsub(/@/, 'at')
            .gsub(/[^0-9a-zA-Z_-]+/, '')

    if @slug == ''
      # name に '.' などを入力すると @slug が空文字列になることがある
      return redirect_to new_word_path, alert: "単語「#{@new_word}」は短すぎる可能性があります。別の単語をお試しください。"
    end

    if Word.where(slug: @slug).count != 0
      # 単語が異なっていて slug だけ一致する場合のことはおいおい考える
      return redirect_to new_word_path, alert: "単語「#{@new_word}」はすでに存在している可能性があります。別の単語をお試しください。"
    end

    word_active_record = Word.new(
      name: @new_word,
      slug: @slug,
      tags: params[:tags]
    )

    unless word_active_record.valid?
      # '#' を100個つなげた単語などを入力した場合
      return redirect_to new_word_path, alert: "単語「#{@new_word}」は登録できない可能性があります。別の単語をお試しください。"
    end

    if params[:confirmed].nil? || params[:confirmed] != 'true'
      @confirming = true
      @confirmed = false
      return render 'new'
    end
    @confirming = true
    @confirmed = true

    word_active_record.save!

    # render json: params
    redirect_to word_path(@slug), notice: '単語を追加しました。'
  end
end
