# frozen_string_literal: true

# == Schema Information
#
# Table name: words
#
#  id            :bigint           not null, primary key
#  last_voted_at :datetime
#  name          :string(255)
#  slug          :string(255)
#  tags          :text(65535)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_words_on_created_at     (created_at)
#  index_words_on_last_voted_at  (last_voted_at)
#  index_words_on_name           (name) UNIQUE
#  index_words_on_slug           (slug) UNIQUE
#  index_words_on_updated_at     (updated_at)
#
class Word < ApplicationRecord
  has_many :choices, -> { order(:id) }, dependent: :destroy, inverse_of: :word

  # 許容する文字種は要検討
  validates :name, format: { with: /\A[A-Za-z0-9., _-]+\z/ }, length: { maximum: 100 }
  validates :tags, format: { with: /\A(|(#[A-Za-z0-9_ぁ-んァ-ヶー一-龠]+)( #[A-Za-z0-9_ぁ-んァ-ヶー一-龠]+)*)\z/ }, length: { maximum: 100 }
end
