class UserRecord < ApplicationRecord
    self.table_name = 'users'
    enum status: [:unregistered, :active]
    enum marital_status: [:single, :married, :divorced]

    validates :email, presence: true, uniqueness: true
end
