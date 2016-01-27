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
