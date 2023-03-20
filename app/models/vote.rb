# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :choice
  belongs_to :user, optional: true

  def self.save_annonymous_choice(choice, word = nil, session_key)
    word ||= choice.word
    choice_ids = word.choices.pluck(:id)
    vote = Vote.find_by(session: session_key, choice: choice_ids) || Vote.new

    # 選択肢が変わっていない場合はreturn
    return if !vote.new_record? && choice.id == vote.choice_id

    old_choice = vote.new_record? ? nil : word.choices.detect { |c| c.id == vote.choice_id }
    if old_choice
      old_choice.auth_count -= 1
      old_choice.save!
    end
    choice.auth_count += 1
    choice.save!

    vote.session = session_key
    vote.choice = choice
    vote.authenticated = false
    vote.save!

    nil
  end
end
