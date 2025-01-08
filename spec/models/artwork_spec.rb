require 'rails_helper'

RSpec.describe Artwork, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:order_items) }
  end
end
