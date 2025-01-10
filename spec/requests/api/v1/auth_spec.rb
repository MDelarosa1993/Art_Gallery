require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  describe "GET /create" do
    it "successfully logins a user and provides a token" do 
      user = User.create!(name: "Mel", email: "mel@example.com", password: "melchor08", role: :artist)
      post "/api/v1/auth", params: { email: user.email, password: user.password }
      
      expect(response).to be_successful

      jwt = JSON.parse(response.body, symbolize_names: true)
      
      expect(jwt[:token]).to be_a(String)
      expect(jwt[:user][:data]).to be_an(Hash)
      expect(jwt[:user][:data][:id]).to be_a(String)
      expect(jwt[:user][:data][:type]).to be_a(String)
      expect(jwt[:user][:data][:attributes][:name]).to be_a(String)
      expect(jwt[:user][:data][:attributes][:email]).to be_a(String)
      expect(jwt[:user][:data][:attributes][:password]).to be_nil
      expect(jwt[:user][:data][:attributes][:role]).to be_a(String)
    end
  end
end
