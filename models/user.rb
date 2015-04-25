class User < ActiveRecord::Base
    validates_uniqueness_of :username, :email

    has_many :tweets
end


