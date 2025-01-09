require 'rails_helper'

RSpec.describe "Api::V1::Admin::Users", type: :request do
  describe "GET/index" do
    it "if admin, retrieve all buyers and artists" do
      admin = User.create!(name: "Mel", email: "mel@example.com", password: "melchor08", role: :admin)

      post "/api/v1/auth", params: { email: admin.email, password: admin.password }
      
      expect(response).to be_successful

      token = JSON.parse(response.body)["token"]
      
      expect(token).to_not be_nil
      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3)

      User.create(name: "Buyer", email: "buyer@example.com", password: "password", role: :buyer)
      User.create(name: "Artist", email: "artist@example.com", password: "password", role: :artist)

      get "/api/v1/admin/users", headers: { "Authorization" => "Bearer #{token}" }, as: :json

      expect(response).to be_successful

      user_role_info = JSON.parse(response.body, symbolize_names: true)
      
      expect(user_role_info[:artists][0][:id]).to be_an(Integer)
      expect(user_role_info[:artists][0][:name]).to be_a(String)
      expect(user_role_info[:artists][0][:email]).to be_a(String)
      expect(user_role_info[:artists][0][:password_digest]).to be_a(String)
      expect(user_role_info[:artists][0][:role]).to be_a(String)
      expect(user_role_info[:artists][0][:created_at]).to be_a(String)
      expect(user_role_info[:artists][0][:updated_at]).to be_a(String)
      expect(user_role_info[:buyers][0][:id]).to be_an(Integer)
      expect(user_role_info[:buyers][0][:name]).to be_a(String)
      expect(user_role_info[:buyers][0][:email]).to be_a(String)
      expect(user_role_info[:buyers][0][:password_digest]).to be_a(String)
      expect(user_role_info[:buyers][0][:role]).to be_a(String)
      expect(user_role_info[:buyers][0][:created_at]).to be_a(String)
      expect(user_role_info[:buyers][0][:updated_at]).to be_a(String)
    end
  end
end
