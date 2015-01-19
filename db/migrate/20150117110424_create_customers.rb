class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :dob
      t.text   :address
      t.string :stripe_card_token
      t.string :stripe_customer_id
      t.timestamps
    end
  end
end
