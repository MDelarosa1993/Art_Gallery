class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :email, :password, :role
end
