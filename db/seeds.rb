5.times do |i|
  User.create(name: "Test #{i}", username: "test#{i}", email: "test#{i}@test#{i}.com", password: "test#{i}")
end