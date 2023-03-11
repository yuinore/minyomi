# frozen_string_literal: true

class Choice < ApplicationRecord
  belongs_to :word
  has_many :votes, dependent: :destroy

  def self.create_percentage(choices)
    @total_count = choices.sum { |choice| choice.count + choice.auth_count }

    choices.map do |choice|
      choice_count = (choice&.count || 0) + (choice&.auth_count || 0)

      {
        id: choice.id,
        percentage: "#{(choice_count * 100.0 / @total_count).round(1)}%",
      }
    end
  end
end
