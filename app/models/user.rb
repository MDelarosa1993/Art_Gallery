class User < ApplicationRecord
  has_secure_password

  enum role: { artist: 0, buyer: 1, admin: 2 }

  
end
