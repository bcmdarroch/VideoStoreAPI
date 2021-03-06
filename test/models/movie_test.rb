require "test_helper"

describe Movie do
  let(:movie) { movies(:firewalk) }

  it "is a valid object with title, release_date, inventory, and available_inventory" do
    movie.valid?.must_equal true
  end

  it "must have a title" do
      movie.title.must_equal "Firewalk with Me"
  end

  it "is invalid without a title" do
      movie = Movie.create(release_date: "2000-12-12", inventory: 10, available_inventory: 5)
      movie.valid?.must_equal false
      movie.errors.messages.must_include :title
  end

  it "must have a release date" do
      movie.release_date.must_equal "2017-05-14"
  end

  it "is invalid without a release date" do
      movie = Movie.create(title: "It's So Hard", inventory: 20, available_inventory: 15)
      movie.valid?.must_equal false
      movie.errors.messages.must_include :release_date
  end

  it "must have integer inventory" do
      movie.inventory.must_equal 1
      movie.inventory.class.must_equal Integer
  end

  it "is invalid without inventory" do
      movie = Movie.create(title: "Guardians of the Galaxy, Vol 2", release_date: "2000-12-12", available_inventory: 5)
      movie.valid?.must_equal false
      movie.errors.messages.must_include :inventory
  end

  it "invalid if negative inventory number" do
    movie = Movie.create(title: "Guardians of the Galaxy, Vol 2", release_date: "2000-12-12", inventory: -5, available_inventory: -5)
    movie.valid?.must_equal false
    movie.errors.messages.must_include :inventory
  end

  it "is invalid with non-integer inventory" do
    movie = Movie.create(title: "Guardians of the Galaxy, Vol 2", release_date: "2000-12-12", inventory: "two", available_inventory: 5)
    movie.valid?.must_equal false
    movie.errors.messages.must_include :inventory
  end

  it "is valid with available_inventory" do
    movie.available_inventory.must_equal 1
    movie.available_inventory.class.must_equal Integer
  end

  it "is invalid without available_inventory" do
    movie = Movie.create(title: "Guardians of the Galaxy, Vol 2", release_date: "2000-12-12", inventory: 5)
    movie.valid?.must_equal false
    movie.errors.messages.must_include :available_inventory
  end

  it "is invalid with non-integer available_inventory" do
    movie = Movie.create(title: "Guardians of the Galaxy, Vol 2", release_date: "2000-12-12", inventory: 5, available_inventory: "a million")
    movie.valid?.must_equal false
    movie.errors.messages.must_include :available_inventory
  end

  it "available inventory is valid if less than or equal to inventory" do
    movie.available_inventory.wont_be :>, movie.inventory
    movie.valid?.must_equal true
  end

  it "invalid if negative available_inventory number" do
    movie = Movie.create(title: "Guardians of the Galaxy, Vol 2", release_date: "2000-12-12", inventory: -5, available_inventory: -5)
    movie.valid?.must_equal false
    movie.errors.messages.must_include :available_inventory
  end

  it "available inventory is invalid if greater than inventory" do
    movie = Movie.create(title: "Guardians of the Galaxy, Vol 2", release_date: "2000-12-12", inventory: 5, available_inventory: 50)
    movie.valid?.must_equal false
    movie.errors.messages.must_include :available_inventory
  end

  it "can have overview" do
      movie.overview.must_equal "David Lynch's prequel to Twin Peaks. Did you know next week there is a scavenger hunt in real Twin Peaks?!?!?!"
  end

  it "returns an array of rentals" do
      movie.rentals.each do |rental|
          rental.must_be_instance_of Rental
          rental.movie.must_equal movie
      end
  end

  it "returns an empty array if they have not rented a movie yet" do
      movie = Movie.create(title: "Guardians of the Galaxy, Vol 2", release_date: "2000-12-12", inventory: 5, available_inventory: 5)
      movie.rentals.must_equal []
  end

  it "returns an array of customers" do
      movie.customers.each do |customer|
          customer.must_be_instance_of Customer
          customer.movies.must_include movie
      end
  end

  it "returns an empty array if they have not rented a movie yet" do
      movie = Movie.create(title: "Guardians of the Galaxy, Vol 2", release_date: "2000-12-12", inventory: 5, available_inventory: 5)
      movie.customers.must_equal []
  end
end
