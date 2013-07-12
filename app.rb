require 'sinatra'
require 'sass'
require 'slim'

PLATES = [45, 35, 25, 15, 10, 5, 2.5]

get '/' do
  slim :index
end

get '/plates' do
	#build plate hash aka 45=>0
	build_plates
	#subtract weight of bar from total weight needed
	weight = params[:weight].to_i - params[:bar].to_i
	@plates_to_stack = plate_count(weight)
	slim :calculation
end

get('/styles.css'){scss :styles}

def build_plates
	@plates = Hash.new
	PLATES.each do |plate|
		@plates[plate] = 0
	end
end

def plate_count(weight)
	if weight <= 0
		return @plates
	end
	PLATES.each do |plate|
		@plates[plate] = 2 * ((weight - total_weight) / (2 * plate))
	end
	return @plates
end

def total_weight
	total = 0
	@plates.each do |plate, weight|
		total += plate * weight
	end
	return total.to_i
end
