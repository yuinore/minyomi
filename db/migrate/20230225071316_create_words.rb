# frozen_string_literal: true

class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.string :name
      t.string :slug
      t.text :tags

      t.timestamps

      t.index :name, unique: true
      t.index :slug, unique: true
      t.index :created_at
      t.index :updated_at
    end
  end
end
