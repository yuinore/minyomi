# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :choice, null: false, foreign_key: true
      t.boolean :authenticated, null: false
      t.references :user, foreign_key: true
      t.string :session

      t.timestamps

      t.index [:user_id, :choice_id], unique: true
      t.index [:session, :choice_id], unique: true
      t.index :created_at
      t.index :updated_at
    end
  end
end
