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
  #   '+' => C++ を単語名やタグに使いたい
  #   '#' => C# を単語名やタグに使いたいが、タグは混乱を招く可能性がある（要検討）
  #   '/' =?> TCP/IP を単語名やタグに使いたい
  NAME_REGEX = /\A[A-Za-z0-9., _-]+\z/
  TAG_CHARS_REGEX = /[A-Za-z0-9_ぁ-んァ-ヶー一-龠]+/
  TAGS_REGEX = /\A(|(##{TAG_CHARS_REGEX})( ##{TAG_CHARS_REGEX})*)\z/
  validates :name, format: { with: NAME_REGEX }, length: { maximum: 100 }, on: :create
  validates :tags, format: { with: TAGS_REGEX }, length: { maximum: 100 }
end
