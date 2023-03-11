# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :choice
  belongs_to :user, optional: true

  def self.save_annonymous_choice(choice, session_key)
    choice_ids = choice.word.choices.pluck(:id)
    vote = Vote.find_by(session: session_key, choice: choice_ids) || Vote.new

    return if vote.choice && choice.id == vote.choice.id

    if vote.choice
      vote.choice.auth_count -= 1
      vote.choice.save!
    end
    choice.auth_count += 1
    choice.save!

    vote.user = self
    vote.choice = choice
    vote.session = session_key
    vote.choice = choice
    vote.authenticated = false
    vote.save!

    nil
  end
end
