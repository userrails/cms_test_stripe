class CustomersController < ApplicationController
  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    unless params[:customer][:stripe_card_token].blank?        
    if @customer.save
      customer = Customer.save_to_stripe(params, @customer)     
      @customer.update(:stripe_customer_id => customer.id, :stripe_card_token => params[:customer][:stripe_card_token] )
         charge = Stripe::Charge.create(
          :customer    => customer.id,
           :amount      => (@customer.amount.to_i * 100),
           :description => "Charge created successfully",
           :currency    => 'cad'
         )
        @customer.credit_cards.create!(:stripe_charge_id => charge.id)
        redirect_to customers_path
    else
      render :action => :new
    end
  else
    flash[:notice] = "Card token is nil. Please refresh the page and try again!" 
    render :action => :new
  end
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      if @customer.stripe_customer_id.present?
        Customer.update_to_stripe(@customer)
      end
        redirect_to customers_path
      else
        render :action => :edit
      end
  end

  def destroy
    @customer = Customer.find(params[:id])
    if @customer.stripe_customer_id.present?
        Customer.remove_from_stripe(@customer)
    end
    if @customer.destroy
      redirect_to customers_path
    end
  end

  private
  def customer_params
    params.require(:customer).permit!
  end
end