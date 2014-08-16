require 'sinatra'
require 'json'
require 'csv'
require 'pry'

# movie_data = JSON.parse(File.read('in_theaters.json'))

def load_reviews
  reviews = []

  CSV.foreach('reviews.csv', headers: true) do |row|
    reviews << row.to_hash
  end

  reviews
end

before do
  movie_data = JSON.parse(File.read('in_theaters.json'))
  @all_movies = movie_data['movies']
  @all_reviews = load_reviews
end

def find_movie(id)
  @all_movies.find do |movie|
    movie['id'] == id
  end
end

def find_review(id)
  @all_reviews.find do |review|
    review['REVIEW_ID'] == id
  end
end

get '/' do
  @movies = @all_movies
  erb :home
end

get '/movies/:id' do
  @movie = find_movie(params[:id])
  # binding.pry
  @reviews = @all_reviews
  # index = 0
  # movie_data["movies"].each do |movie|
  #   if movie["id"] == params[:id]
  #     index = movie_data["movies"].index(movie)
  #   end
  # end
  # @single_movie = movie_data["movies"][index]
  erb :show_movie
end

post '/movies/:id' do
  @movie = find_movie(params[:id])
  @name = params[:name]
  @review = params[:review]
  @time = Time.now.strftime("%Y/%m/%d At %H:%M%p")
  @id = params[:id]
  @review_id = params[:review_id]

  CSV.open("reviews.csv","ab") do |row|
    row << [@review_id,@id,@name,@review,@time.to_s]
  end
  # CSV.foreach("reviews.csv",headers:true, header_converters: :symbol) do |row|
  #   reviews <<  row.to_hash
  # end

  redirect '/movies/' + @movie['id']
end

# Delete Reviews
get '/movies/:id/review/:review_id' do
  # binding.pry
  # movie_data["movies"].each do |movie|
  #   if movie["id"] == params[:id]
  #     index = movie_data["movies"].index(movie)
  #   end
  # end
  # @single_movie = movie_data["movies"][index]
  @movie = find_movie(params[:id])
  @review = find_review(params[:review_id])

  erb :delete
end

delete '/movies/:id/review/:review_id' do
  @movie = find_movie(params[:id])
  csv = CSV.open("reviews.csv", 'w', headers:true)
  headers = %w(REVIEW_ID ID NAME REVIEW TIME)
  csv << headers

  @all_reviews.each do |review|
    csv << review.values unless review['REVIEW_ID'] == params[:review_id]
  end

  redirect '/movies/' + @movie['id']
end
