require 'faker'

author = Author.all

author.each do |author|
  author.update(name: "#{Faker::Name.name}")
end

4.times do
  Author.create(name: Faker::Name.name)
end

book = Book.all

book.each do |book|
  book.update(title: "#{Faker::Book.title}")
end

4.times do
  Book.create(title: Faker::Book.title)
end

