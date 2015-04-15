class Follow < ActiveRecord::Base
    #validates_uniqueness_of :user_id, :follower_id
    validates :follower_id, uniqueness: { scope: :user_id,
    message: "cant follow same person twice" }
    def to_json
        super()
    end
    
end


