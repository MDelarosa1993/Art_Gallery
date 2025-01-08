require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "Associations" do 
    it { should belong_to(:order) }
    it { should belong_to(:artwork) }
  end
end
