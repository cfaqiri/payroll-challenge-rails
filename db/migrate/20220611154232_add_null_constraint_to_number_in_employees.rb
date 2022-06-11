class AddNullConstraintToNumberInEmployees < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:employees, :number, false, 1)
  end
end
