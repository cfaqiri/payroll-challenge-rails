class AddEmployeeToTimekeepingRecords < ActiveRecord::Migration[7.0]
  def change
    add_reference :timekeeping_records, :employee, null: false, foreign_key: true
  end
end
