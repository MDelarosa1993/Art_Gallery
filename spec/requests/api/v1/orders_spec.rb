require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  describe "GET /create" do
    it "creates a order for a buyer" do
      user = User.create!(name: "Mel", email: "mel@example.com", password: "melchor08", role: :buyer)

      post "/api/v1/auth", params: { email: user.email, password: user.password }
      
      expect(response).to be_successful

      token = JSON.parse(response.body)["token"]
      
      expect(token).to_not be_nil
      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3)
      artwork = Artwork.create!(title: "Painting", description: "Beautiful artwork", price: 600000, user_id: user.id)
      order_params = {
        order: {
          total_price: 3000000,
          order_items_attributes: [{
            artwork_id: artwork.id,
            quantity: 5, 
            price: 600000
          }]
        }
      }

      post "/api/v1/users/#{user.id}/orders", params: order_params, headers: { "Authorization" => "Bearer #{token}" }, as: :json
      
      order = JSON.parse(response.body, symbolize_names: true)
      
      expect(order[:id]).to be_an(Integer)
      expect(order[:user_id]).to be_an(Integer)
      expect(order[:total_price]).to be_a(String)
      expect(order[:created_at]).to be_a(String)
      expect(order[:updated_at]).to be_a(String)
      expect(order[:order_items][0][:id]).to be_an(Integer)
      expect(order[:order_items][0][:order_id]).to be_an(Integer)
      expect(order[:order_items][0][:artwork_id]).to be_an(Integer)
      expect(order[:order_items][0][:quantity]).to be_an(Integer)
      expect(order[:order_items][0][:price]).to be_an(String)
      expect(order[:order_items][0][:created_at]).to be_a(String)
      expect(order[:order_items][0][:updated_at]).to be_a(String)
    end
  end
end
