class Customer < ActiveRecord::Base
  # associations
  has_many :credit_cards


  def self.save_to_stripe(params, customer)
    if params[:customer][:stripe_card_token].present?
    Stripe::Customer.create(:card  => params[:customer][:stripe_card_token],
      :description => "New customer #{customer.first_name} #{customer.last_name} created",
       :email => "#{customer.email}"
        )
    end
  end

  def self.update_to_stripe(customer)
      cu = Stripe::Customer.retrieve(customer.stripe_customer_id)     
      cu.description = "Customer information updated"
      cu.email = "#{customer.email}"
      cu.save
  end

  def self.remove_from_stripe(customer)
    cu = Stripe::Customer.retrieve(customer.stripe_customer_id)
    cu.delete
  end
end