class AddCoachContentToComments < ActiveRecord::Migration[8.1]
  def change
    add_reference :comments,
                  :coach_content,
                  null: true,
                  foreign_key: true
  end
end
