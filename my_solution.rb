require "http"
require "json"

gmaps_key = ENV.fetch("GMAPS_KEY")
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

puts "Where are you located?"
user_location = gets.chomp

gmap_data = HTTP.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}")
parsed_gmap_data = JSON.parse(gmap_data)
results = parsed_gmap_data.fetch("results")
first_result = results.at(0)
geometry = first_result.fetch("geometry")
location = geometry.fetch("location")
latitude = location.fetch("lat")
longitude = location.fetch("lng")

pirate_weather_data = HTTP.get("https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}")
parsed_pirate_data = JSON.parse(pirate_weather_data)
currently = parsed_pirate_data.fetch("currently")
temperature = currently.fetch("temperature")
puts "It is currently #{temperature} degrees in #{user_location}"

hourly = parsed_pirate_data.fetch("hourly")
data_ = hourly.fetch("data")
next_twelve_hours = data_[1..12]

threshold = 0.1
take_umbrella = false

next_twelve_hours.each do |rain|
  rain_prob = rain.fetch("precipProbability")
  if rain_prob >= threshold
    take_umbrella = true

    time_of_rain = Time.at(hour_hash.fetch("time"))
    seconds = time_of_rain - Time.now
    hours = seconds / 60 / 60

    puts "In #{hours.round} hours, there is a #{(rain_prob * 100).round}% chance of rain."
  end
end

if take_umbrella == false
  puts "You probably won’t need an umbrella today."
else "You might want to take an umbrella!"
end
