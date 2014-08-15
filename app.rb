require 'sinatra'
require 'json'
require 'csv'
require 'pry'

movie_data = JSON.parse(File.read('in_theaters.json'))
reviews = []


get '/' do
  @movies = movie_data["movies"]
  erb :home
end

get '/movies/:id' do
  @reviews = reviews
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
  @time = Time.now.strftime("%Y/%m/%d At %H:%M%p")
  @id = params[:id]
  @review_id = params[:review_id]

  CSV.open("reviews.csv","ab") do |row|
    row << [@review_id,@id,@name,@review,@time.to_s]
  end
  CSV.foreach("reviews.csv",headers:true) do |row|
   reviews <<  {review_id: row["REVIEW_ID"],id: row["ID"], name: row["NAME"], review: row["REVIEW"], time: row["TIME"]}
  end
  redirect '/'
end

# Delete Reviews
get '/movies/:id/review/:review_id' do
  erb :delete
end

delete '/movies/:id/review/:review_id' do
  CSV.foreach("reviews.csv", headers:true) do |row|
    row.delete_if{ row[:review_id] == params[:review_id]}
  end
  CSV.open("reviews.csv", 'w',headers:true) do |row|
   reviews <<  {review_id: row["REVIEW_ID"],id: row["ID"], name: row["NAME"], review: row["REVIEW"], time: row["TIME"]}
  end
  redirect '/'
end
