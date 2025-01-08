require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do 
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "Associations" do 
    it { should have_many(:artworks) }
    it { should have_many(:orders) }
  end
end
