# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :image

      t.timestamps

      t.index :created_at
      t.index :updated_at
    end
  end
end
