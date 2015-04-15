require 'csv'

userIDs=Hash.new 
puts "starting seed generation"
User.delete_all
Tweet.delete_all
Follow.delete_all

CSV.foreach("./seeds/users.csv") do |attributes|
		u = User.create(name: attributes[1],
				username: Faker::Internet.user_name,
				password: Faker::Internet.password(6, 20),
				email: Faker::Internet.email(attributes[1]))
		userIDs["#{attributes[0]}"] = u.id
		puts u.username
		puts u.id
end
puts "Generated users"

CSV.foreach("./seeds/tweets.csv") do |attributes|
		t = Tweet.create(owner: userIDs["#{attributes[0]}"], text: attributes[1])
		puts t.owner
end
puts "Generated tweets"

CSV.foreach("./seeds/follows.csv") do |attributes|
        f = Follow.create(user_id: userIDs["#{attributes[0]}"],
                          follower_id: userIDs["#{attributes[1]}"])
        puts f        
end

puts "Generated follows"

