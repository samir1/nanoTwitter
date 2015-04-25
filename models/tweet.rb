class Tweet < ActiveRecord::Base
    # validates_uniqueness_of :name, :email
    validates :text, uniqueness: { scope: :owner, message: "cant write the same tweet twice" }

    belongs_to :user

    def to_json
        super()
    end
    
end


