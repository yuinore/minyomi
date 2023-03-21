# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :choice
  belongs_to :user, optional: true

  def self.save_annonymous_choice(choice, session_key)
    # word.rb で inverse_of: :word が指定されていることで、choice.word を読んでも DB に query されない
    # word = choice.word
    choice_ids = choice.word.choices.pluck(:id)
    vote = Vote.find_by(session: session_key, choice: choice_ids) || Vote.new

    # 選択肢が変わっていない場合はreturn
    # vote.choice を DB に問い合わせないようにするため vote.choice_id を使用する
    return if !vote.new_record? && choice.id == vote.choice_id

    old_choice = vote.new_record? ? nil : choice.word.choices.detect { |c| c.id == vote.choice_id }
    if old_choice
      old_choice.count -= 1
      old_choice.save!
    end
    choice.count += 1
    choice.save!

    vote.session = session_key
    vote.choice = choice
    vote.authenticated = false
    vote.save!

    choice.word.last_voted_at = Time.zone.now
    choice.word.save!

    nil
  end
end
