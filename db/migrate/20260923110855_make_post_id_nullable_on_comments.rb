class MakePostIdNullableOnComments < ActiveRecord::Migration[8.1]
  def change
    change_column_null :comments, :post_id, true
  end
end
