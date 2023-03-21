# frozen_string_literal: true

class Word < ApplicationRecord
  has_many :choices, -> { order(:id) }, dependent: :destroy, inverse_of: :word

  # 許容する文字種は要検討
  validates :name, format: { with: /\A[A-Za-z0-9 _-]+\z/ }, length: { maximum: 100 }
end
