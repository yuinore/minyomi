class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.text :name
      t.text :slug
      t.text :tags

      t.timestamps
    end
  end
end
