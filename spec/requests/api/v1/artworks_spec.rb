require 'rails_helper'

RSpec.describe "Api::V1::Artworks", type: :request do
  describe "GET/index" do 
    it "retreives a list of artwork" do 
      user = User.create!(name: "Mel", email: "mel@example.com", password: "melchor08", role: :artist)

      post "/api/v1/auth", params: { email: user.email, password: user.password }
      
      expect(response).to be_successful

      token = JSON.parse(response.body)["token"]
      
      expect(token).to_not be_nil
      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3)

      Artwork.create(title: "Paint Dry", description: "Watching paint dry", price: 100000.00, user_id: user.id)
      Artwork.create(title: "Paint", description: "Watching paint", price: 500000.00, user_id: user.id)

      get "/api/v1/users/#{user.id}/artworks", headers: { "Authorization" => "Bearer #{token}" }, as: :json

      expect(response).to be_successful

      user_artworks = JSON.parse(response.body, symbolize_names: true)
      
      user_artworks.each do |user_artwork|
        expect(user_artwork).to be_a(Hash)
        expect(user_artwork[:id]).to be_an(Integer)
        expect(user_artwork[:title]).to be_an(String)
        expect(user_artwork[:description]).to be_an(String)
        expect(user_artwork[:price]).to be_a(String)
        expect(user_artwork[:user_id]).to be_an(Integer)
        expect(user_artwork[:created_at]).to be_an(String)
        expect(user_artwork[:updated_at]).to be_an(String)
      end
    end
  end

  describe "POST/create" do 
    it "creates artwork for a user" do 
      user = User.create!(name: "Mel", email: "mel@example.com", password: "melchor08", role: :artist)

      post "/api/v1/auth", params: { email: user.email, password: user.password }
      
      expect(response).to be_successful

      token = JSON.parse(response.body)["token"]
      
      expect(token).to_not be_nil
      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3)

      artwork_params = {
        artwork: {
          title: "More Paint",
          description: "Ughhh",
          price: 2000000000.00
        }
      }

      post "/api/v1/users/#{user.id}/artworks", params: artwork_params, headers: { "Authorization" => "Bearer #{token}" }, as: :json

      expect(response).to be_successful
      
      new_art = JSON.parse(response.body, symbolize_names: true)
      
      expect(new_art[:id]).to be_an(Integer)
      expect(new_art[:title]).to be_a(String)
      expect(new_art[:description]).to be_a(String)
      expect(new_art[:price]).to be_a(String)
      expect(new_art[:user_id]).to be_an(Integer)
      expect(new_art[:created_at]).to be_an(String)
      expect(new_art[:updated_at]).to be_an(String)
    end
  end
end
