class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :choice, null: false, foreign_key: true
      t.boolean :authenticated, null: false
      t.references :user, foreign_key: true
      t.text :session

      t.timestamps
    end
  end
end
