require 'sinatra'
require 'pry'

enable :sessions

get '/' do
	@message ||= session[:message]
	session[:message] = nil

	erb :index, layout: true
end

post '/result' do
	if params[:percent] === "" || params[:credit] === "" || params[:term] === ""
		session[:message] = 'Invalid data'
		redirect to "/"
	else		
		@percent = params[:percent].to_f		
		@credit = params[:credit].to_f
		@term = params[:term].to_i
		if params[:payOff] === 'Usual'
			@total = compute_usual @percent, @credit, @term
		else
			@total = compute_ann @percent, @credit, @term
		end
		session[:total] = @total
		redirect  to "/result"
	end
end

get '/result' do
	@total = session[:total]
	session[:total] = nil
	erb :result, layout: true
end

def compute_usual percent, credit, term
	stable_month_payment = credit/term
	leftover = credit
	i = percent/(100 * 12)
	total = []
	temp = []
	until leftover < 0 do	
		month_percents = leftover * i			
		month_payment = stable_month_payment + month_percents
		leftover -= month_payment
		temp.push(month_payment).push(leftover)
		total << temp
		temp = []	
	end
	total
end

def compute_ann percent, credit, term
	leftover = credit
	p = percent/(100 * 12)	
	a = p * (1 + p)**term / ((1 + p)**term - 1)	
	total = []
	temp = []
	
	until leftover <= 0 do
		month_payment = credit * a
		temp.push(month_payment).push(leftover)		
		leftover -=  month_payment
		total << temp
		temp = []
	end	
	total	
end
