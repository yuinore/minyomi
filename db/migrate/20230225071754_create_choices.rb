class CreateChoices < ActiveRecord::Migration[7.0]
  def change
    create_table :choices do |t|
      t.text :name
      t.integer :count
      t.integer :auth_count
      t.references :word, null: false, foreign_key: true

      t.timestamps
    end
  end
end
