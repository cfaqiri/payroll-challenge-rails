class AddNullConstraintToAllColumnsInTimekeepingRecords < ActiveRecord::Migration[7.0]
  def change
    [:date, :hours].each do |column|
      change_column_null(:timekeeping_records, column, false)
    end
  end
end
