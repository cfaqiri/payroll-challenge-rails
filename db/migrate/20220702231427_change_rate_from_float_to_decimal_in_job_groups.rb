class ChangeRateFromFloatToDecimalInJobGroups < ActiveRecord::Migration[7.0]
  def change
    change_column :job_groups, :rate, :decimal, precision: 8, scale: 2
  end
end
