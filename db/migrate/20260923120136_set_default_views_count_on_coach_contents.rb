class SetDefaultViewsCountOnCoachContents < ActiveRecord::Migration[8.1]
  def change
    change_column_default :coach_contents,
                          :views_count,
                          from: nil,
                          to: 0

    change_column_null :coach_contents,
                        :views_count,
                        false,
                        0
  end
end
