class Tweet < ActiveRecord::Base
    # validates_uniqueness_of :name, :email
    
    def to_json
        super()
    end
    
end


