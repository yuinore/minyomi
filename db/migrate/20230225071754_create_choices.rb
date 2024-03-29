# frozen_string_literal: true

class CreateChoices < ActiveRecord::Migration[7.0]
  def change
    create_table :choices do |t|
      t.string :name
      t.integer :count
      t.integer :auth_count
      t.references :word, null: false, foreign_key: true

      t.timestamps

      t.index [:word_id, :name], unique: true
      t.index :created_at
      t.index :updated_at
    end
  end
end
