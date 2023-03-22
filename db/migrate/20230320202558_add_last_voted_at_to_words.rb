# frozen_string_literal: true

class AddLastVotedAtToWords < ActiveRecord::Migration[7.0]
  def change
    change_table :words, bulk: true do |t|
      t.column :last_voted_at, :datetime

      t.index :last_voted_at
    end
  end
end
