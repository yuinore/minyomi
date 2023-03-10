# frozen_string_literal: true

class Word < ApplicationRecord
  has_many :choices, dependent: :destroy
end
