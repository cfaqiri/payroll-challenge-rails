class AddHoursToTimekeepingRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :timekeeping_records, :hours, :float
  end
end
