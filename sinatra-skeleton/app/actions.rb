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
		redirect '/'
	else
		erb :'/user/login'
	end
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
  @groups = Group.all
  erb :'/groups/index'
end

get '/groups/:id/details' do
	@group = Group.find(params[:id])
	@posts = Post.where(group_id: @group.id)
  erb :'/groups/details'
end

get '/groups/:id/posts/:id/details' do
	@post = Post.find(params[:id])
	@comments = Comment.where(post_id: @post.id)
  erb :'/groups/posts/details'
end

get '/events' do
  erb :'/events/index'
end

get '/services' do
	@services = Service.all
  erb :'/services/index'
end

get '/services/:id/details' do
	@service = Service.find(params[:id])
  erb :'/services/details'
end

