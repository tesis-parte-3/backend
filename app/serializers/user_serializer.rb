class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :dni, :created_at, :updated_at
end
