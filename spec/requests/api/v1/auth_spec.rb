require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  describe "GET /create" do
    it "successfully logins a user and provides a token" do 
      user = User.create!(name: "Mel", email: "mel@example.com", password: "melchor08", role: :artist)
      post "/api/v1/auth", params: { email: user.email, password: user.password }
      
      expect(response).to be_successful

      jwt = JSON.parse(response.body, symbolize_names: true)
      # require 'pry'; binding.pry
      expect(jwt[:token]).to be_a(String)
      expect(jwt[:user]).to be_an(Hash)
      expect(jwt[:user][:id]).to be_a(Integer)
      expect(jwt[:user][:name]).to be_a(String)
      expect(jwt[:user][:email]).to be_a(String)
      expect(jwt[:user][:password_digest]).to be_a(String)
      expect(jwt[:user][:role]).to be_a(String)
      expect(jwt[:user][:created_at]).to be_a(String)
      expect(jwt[:user][:updated_at]).to be_a(String)
    end
  end
end
