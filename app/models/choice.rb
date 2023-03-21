# frozen_string_literal: true

# == Schema Information
#
# Table name: choices
#
#  id         :bigint           not null, primary key
#  auth_count :integer
#  count      :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  word_id    :bigint           not null
#
# Indexes
#
#  index_choices_on_created_at        (created_at)
#  index_choices_on_updated_at        (updated_at)
#  index_choices_on_word_id           (word_id)
#  index_choices_on_word_id_and_name  (word_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (word_id => words.id)
#
class Choice < ApplicationRecord
  MAX_CHOICES_COUNT = 30

  belongs_to :word
  has_many :votes, -> { order(:id) }, dependent: :destroy, inverse_of: :choice

  # ダミーデータ対応のため一旦 on: :create を指定する。name を後から変更する機能が実装された場合はまた考える。
  validates :name, format: { with: /\A[\u30A1-\u30FC]+\z/ }, length: { maximum: 100 }, on: :create
  validate :limit_choices_count, on: :create

  def self.create_percentage(choices)
    @total_count = choices.sum { |choice| choice.count + choice.auth_count }

    choices.map do |choice|
      choice_count = (choice&.count || 0) + (choice&.auth_count || 0)

      {
        id: choice.id,
        total_choice_count: choice_count,
        percentage: "#{(choice_count * 100.0 / @total_count).round(1)}%",
      }
    end
  end

  private

    def limit_choices_count
      # create! 時にはまだ新しいレコードが INSERT されていないため、validation を行う時点では等号を含めて比較する。
      # この場合、選択肢が MAX_CHOICES_COUNT 個あると save! 時にエラーになってしまうため、
      # on: :create を指定して、更新時にバリデーションを行わないようにする。
      errors.add(:base, 'choices limit exceeded.') if word.choices.count >= MAX_CHOICES_COUNT
    end
end
