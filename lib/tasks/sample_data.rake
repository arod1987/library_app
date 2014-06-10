namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "User",
                 email: "user@libraryapp.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "user-#{n+1}@libraryapp.org"
      password = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    50.times do |n|
      title = "LibraryBook#{n+1}"
      author = Faker::Name.name
      synopsis = "This is synopsis of " + title
      if n % 2 == 0
        copies = 3
      else
        copies = 5
      end
      year = rand(1900..2014)
      Book.create!(title: title,
                   author: author,
                   synopsis: synopsis,
                   year: year,
                   copies: copies)
    end

    25.times do |n|
      book = Book.find(n+1)
      copies = book.copies
      copies.times do
        user = User.find(rand(1..99))
        book.users << user
      end
    end
  end
end
