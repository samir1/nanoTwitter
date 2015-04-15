class Tweet < ActiveRecord::Base
    # validates_uniqueness_of :name, :email
        validates :text, uniqueness: { scope: :owner, 
    message: "cant write the same tweet twice" }
    def to_json
        super()
    end
    
end


