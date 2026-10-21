class CreateCoachContents < ActiveRecord::Migration[8.1]
  def change
    create_table :coach_contents do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.integer :visibility
      t.integer :content_type

      t.timestamps
    end
  end
end
