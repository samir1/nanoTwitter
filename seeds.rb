require 'csv'

currentid=User.last.id
puts "starting seed generation"

CSV.foreach("./seeds/tweets.csv") do |attributes|
        if attributes[0]
		t = Tweet.create(owner: attributes[0] + currentid.to_s,
				text: attributes[1])
        end
end

CSV.foreach("./seeds/users.csv") do |attributes|
		u = User.create(name: attributes[1],
				username: Faker::Internet.user_name,
				password: Faker::Internet.password(6, 20),
				email: Faker::Internet.email(attributes[1]))
end


