require 'rails_helper'

RSpec.describe "Api::V1::Admin::Orders", type: :request do
  describe "GET/index" do
    it "if admin retrieve all orders" do 
      admin = User.create!(name: "Mel", email: "mel@example.com", password: "melchor08", role: :admin)

      post "/api/v1/auth", params: { email: admin.email, password: admin.password }
      
      expect(response).to be_successful

      token = JSON.parse(response.body)["token"]
      
      expect(token).to_not be_nil
      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3)

      buyer = User.create(name: "Buyer", email: "buyer@example.com", password: "password", role: :buyer)
      artist = User.create(name: "Artist", email: "artist@example.com", password: "password", role: :artist)
      artwork = artist.artworks.create(title: "Painting", description: "Beautiful", price: 500)
      buyer.orders.create(total_price: 500, order_items_attributes: [{ artwork_id: artwork.id, quantity: 1, price: 500 }])

      get "/api/v1/admin/orders", headers: { Authorization: "Bearer #{token}" }
      
      expect(response).to be_successful

      details = JSON.parse(response.body, symbolize_names: true)
      
      expect(details).to be_an(Array)
      expect(details.size).to eq(1) 

      order = details.first
      expect(order[:id]).to be_an(Integer) 
      expect(order[:user_id]).to be_an(Integer) 
      expect(order[:total_price]).to be_a(String)
      expect(order[:created_at]).to be_a(String)
      expect(order[:updated_at]).to be_a(String)

      expect(order[:order_items]).to be_an(Array)
      expect(order[:order_items].size).to eq(1)

      order_item = order[:order_items].first
      expect(order_item[:id]).to be_an(Integer) 
      expect(order_item[:order_id]).to be_an(Integer) 
      expect(order_item[:artwork_id]).to be_an(Integer) 
      expect(order_item[:quantity]).to be_an(Integer)
      expect(order_item[:price]).to be_a(String)

      artwork_details = order_item[:artwork]
      expect(artwork_details[:id]).to be_an(Integer) 
      expect(artwork_details[:title]).to be_a(String)
      expect(artwork_details[:description]).to be_a(String)
      expect(artwork_details[:price]).to be_a(String)
      expect(artwork_details[:user_id]).to be_an(Integer) 

      user_details = order[:user]
      expect(user_details[:name]).to be_a(String)
      expect(user_details[:email]).to be_a(String)
    end
  end
end
