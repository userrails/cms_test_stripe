class AddPaymentStatusAndAmountToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :amount, :float
    add_column :customers, :payment_status, :string
  end
end
