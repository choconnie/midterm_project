# Homepage (Root path)
get '/' do
  erb :index
end

get '/user/login' do
	erb :'/user/login'
end

get '/user/sign_up' do
	erb :'/user/sign_up/index'
end

get '/groups' do
 erb :'/groups/index'
end

get '/events' do
 erb :'/events/index'
end

get '/services' do
 erb :'/services/index'
end

