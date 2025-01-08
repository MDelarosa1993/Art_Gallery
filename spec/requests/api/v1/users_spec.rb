require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /create" do
    it "successfully creates a user" do
      user_params = {
        user: {
          name: "Melchor",
          email: "melchor@example.com",
          password: "paswword",
          role: :artist
        }
      }

      post "/api/v1/users", params: user_params
      
      expect(response).to be_successful
      
      user = JSON.parse(response.body, symbolize_names: true)
      
      expect(user[:message]).to eq("User created!!")
      expect(user[:user]).to be_a(Hash)
      expect(user[:user][:id]).to be_an(Integer)
      expect(user[:user][:name]).to be_a(String)
      expect(user[:user][:email]).to be_a(String)
      expect(user[:user][:password_digest]).to be_a(String)
      expect(user[:user][:role]).to be_a(String)
      expect(user[:user][:created_at]).to be_a(String)
      expect(user[:user][:updated_at]).to be_a(String)
    end
  end

end
