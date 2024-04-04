class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.string :department
      t.string :emp_status
      t.boolean :admin_status

      t.timestamps
    end
  end
end
