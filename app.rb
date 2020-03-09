require 'sinatra'
require 'httparty'
require 'pry'

API_URL = "https://accounts.api.playstation.com/api/v1/accounts/onlineIds"
HOST_URL = "accounts.api.playstation.com"

get '/' do
  erb :check
end

get '/check/:name' do
    resp = HTTParty.post(API_URL, 
      body: { onlineId: params['name'], reserveIfAvailable: false }.to_json,
      headers: { 'Content-Type' => 'application/json', 'Host' => HOST_URL })
    logger.info resp
    return { body: resp.body, status: resp.code }.to_json
end

get '/mask' do
  erb :mask
end

get '/success' do
  session_id = params['session_id']
  Stripe.api_key = 'sk_test_fiZBn45RMaphyBNwGDqTG3OB'
  session = Stripe::Checkout::Session.retrieve(session_id)
  erb :success, locals: { session_id: session.id }
end

post '/upsell' do
  session_id = params['session_id']
  Stripe.api_key = 'sk_test_fiZBn45RMaphyBNwGDqTG3OB'
  session = Stripe::Checkout::Session.retrieve(session_id)
  payment_list = Stripe::PaymentMethod.list({
    customer: session.customer,
    type: 'card',
  })
  payment_method = payment_list.data.first.id
  payment_intent = Stripe::PaymentIntent.create({
    amount: 1499,
    customer: session.customer,
    payment_method: payment_method,
    currency: 'usd',
    payment_method_types: ['card'],
    confirm: true
  })
  redirect '/thank_you'
end

get '/thank_you' do
  erb :thank_you
end

get '/payment' do
  require 'stripe'
  Stripe.api_key = 'sk_test_fiZBn45RMaphyBNwGDqTG3OB'

  session = Stripe::Checkout::Session.create({
    payment_intent_data: {
      setup_future_usage: 'off_session',
    },
    # billing_address_collection: 'required',
    payment_method_types: ['card'],
    line_items: [
      {
        name: 'Anti-Virus Mask',
        description: 'Face Mask to prevent Viruses in air',
        images: ['mask.jpg'],
        amount: 995,
        currency: 'usd',
        quantity: 1,
      }
    ],
    success_url: 'http://localhost:9292/success?session_id={CHECKOUT_SESSION_ID}',
    cancel_url: 'http://localhost:9292/mask'
  })

  erb :payment, locals: { session: session }
end
