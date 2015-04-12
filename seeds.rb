require 'csv'

currentid=User.last.id
User.delete_all
Tweet.delete_all
puts "starting seed generation"
CSV.foreach("./seeds/users.csv") do |attributes|
		u = User.create(name: attributes[1],
				username: Faker::Internet.user_name,
				password: Faker::Internet.password(6, 20),
				email: Faker::Internet.email(attributes[1]))
	if u.id % 10 == 0
	puts u.name
	end
end

CSV.foreach("./seeds/tweets.csv") do |attributes|
		t = Tweet.create(owner: attributes[0] + currentid,
				text: attributes[1])
	if t.id % 100 == 0
	puts t.text
	end
end



