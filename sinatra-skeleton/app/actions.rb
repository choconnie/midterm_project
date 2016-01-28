helpers do
	def current_user
		User.find(session[:user_id]) if session[:user_id]
	end
end

get '/' do
  erb :index
end

get '/user/login' do
	erb :'/user/login'
end

post '/user/login' do
	username = params[:username]
	password = params[:password]
	@user = User.find_by(username: username, password: password)
	if @user
		session[:user_id] = @user.id
		redirect "/user/#{@user.id}/dashboard"
	else
		erb :'/user/login'
	end
end

get '/user/:id/dashboard' do
	@user = current_user
	@memberships = Membership.where(user_id: @user.id)
	@events = Event.all.limit(3)
	erb :'/user/dashboard'
end

get '/user/sign_out' do
	session[:user_id] = nil
	redirect '/'
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
		erb :'/user/sign_up/index'
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


# Go to Profile
get '/user/profile' do
	erb :'/user/profile'
end

post '/profile' do
	erb :'/user/profile'
end












