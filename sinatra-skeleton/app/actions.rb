helpers do

	def current_user
		User.find(session[:user_id]) if session[:user_id]
	end

end

# Homepage (Root path)
get '/' do
  erb :index
end

get '/user/login' do
	erb :'/user/login'
end

post 'user/login' do
	username = params[:username]
	password = params [:password]
	user = User.find_by(username: username, password: password)
	if user
		session[:user_id] = user.id
		redirect '/'
	end
end

get '/user/sign_up' do
	erb :'/user/sign_up/index'
end

post '/user/sign_up' do
	@user = User.new(
		username: params[:username],
		password: params[:password],
		email: params[:email]
		)
	if @user.save
		redirect '/'
	else
		erb :'/login/sign_up'
	end
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

