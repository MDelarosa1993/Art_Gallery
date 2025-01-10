require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /create" do
    it "successfully creates a user" do
      user_params = {
        user: {
          name: "Melchor",
          email: "mel@example.com",
          password: "paswword",
          role: :artist
        }
      }

      post "/api/v1/users", params: user_params
      
      expect(response).to be_successful
      
      user = JSON.parse(response.body, symbolize_names: true)
      
      expect(user[:message]).to eq("User created!!")
      expect(user[:user][:data]).to be_a(Hash)
      expect(user[:user][:data][:id]).to be_a(String)
      expect(user[:user][:data][:type]).to be_a(String)
      expect(user[:user][:data][:attributes][:name]).to be_a(String)
      expect(user[:user][:data][:attributes][:email]).to be_a(String)
      expect(user[:user][:data][:attributes][:password]).to be_a(String)
      expect(user[:user][:data][:attributes][:role]).to be_a(String)
    end

    it "returns an error for missing params" do
      user_params = {
        user: {
          name: "",
          email: "mel@example.com",
          password: "paswword",
          role: :artist
        }
      }

      post "/api/v1/users", params: user_params
      
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message[:message]).to include("Name can't be blank")
      expect(error_message[:status]).to eq(422)
    end
  end
end
