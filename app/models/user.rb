# frozen_string_literal: true

class User < ApplicationRecord
  has_many :votes, -> { order(:id) }, dependent: :destroy, inverse_of: :user

  def save_choice(choice)
    # inverse_of: :word が指定されていることによって、choice.word を呼び出しても DB に問い合わせされない
    # word = choice.word
    choice_ids = choice.word.choices.pluck(:id)
    vote = Vote.find_by(user: self, choice: choice_ids) || Vote.new

    # 選択肢が変わっていない場合はreturn
    # vote.choice を DB に問い合わせないようにするため vote.choice_id を使用する
    return if !vote.new_record? && choice.id == vote.choice_id

    old_choice = vote.new_record? ? nil : choice.word.choices.detect { |c| c.id == vote.choice_id }
    if old_choice
      old_choice.auth_count -= 1
      old_choice.save!
    end
    choice.auth_count += 1
    choice.save!

    vote.user = self
    vote.choice = choice
    vote.authenticated = true
    vote.save!

    nil
  end

  class << self
    def find_or_create_from_auth_hash(auth_hash)
      user_params = user_params_from_auth_hash(auth_hash)
      find_or_create_by(email: user_params[:email]) do |user|
        user.update(user_params)
      end
    end

    private

      def user_params_from_auth_hash(auth_hash)
        {
          name: auth_hash.info.name,
          email: auth_hash.info.email,
          image: auth_hash.info.image,
        }
      end
  end
end
