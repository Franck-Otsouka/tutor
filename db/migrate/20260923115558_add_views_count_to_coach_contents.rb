class AddViewsCountToCoachContents < ActiveRecord::Migration[8.1]
  def change
    add_column :coach_contents, :views_count, :integer
  end
end
