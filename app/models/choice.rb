# frozen_string_literal: true

class Choice < ApplicationRecord
  belongs_to :word
  has_many :votes, dependent: :destroy
end
