class Follow < ActiveRecord::Base
    validates_uniqueness_of :user_id, :follower_id
    
    def to_json
        super()
    end
    
end


