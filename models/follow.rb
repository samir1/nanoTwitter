class Follow < ActiveRecord::Base
    validates_uniqueness_of :userId, :followerId
    
    def to_json
        super()
    end
    
end


