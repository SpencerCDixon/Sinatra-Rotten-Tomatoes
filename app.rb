require 'sinatra'
require 'json'
require 'csv'
require 'pry'

movie_data = JSON.parse(File.read('in_theaters.json'))


get '/' do
  @movies = movie_data["movies"]
  erb :home
end

get '/movies/:id' do
  index = 0
  movie_data["movies"].each do |movie|
    if movie["id"] == params[:id]
      index = movie_data["movies"].index(movie)
    end
  end
  @single_movie = movie_data["movies"][index]
  erb :show_movie
end

post '/movies/:id' do
  @name = params[:name]
  @review = params[:review]
  @time = Time.now
  @id = params[:id]
  binding.pry
  CSV.open("reviews.csv","ab") do |row|
    row << [@id,@name,@review,@time.to_s]
  end
  redirect '/'
end
