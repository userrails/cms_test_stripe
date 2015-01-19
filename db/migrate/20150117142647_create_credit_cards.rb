class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.references :customer, index: true
      t.string :stripe_charge_id
      t.timestamps
    end
  end
end
