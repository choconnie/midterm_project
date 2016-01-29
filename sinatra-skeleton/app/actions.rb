helpers do

	# def logged_in?
 #    current_user != nil 
 #  end

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
	@user = User.find_by(username: username)
	@user.password_check(password)
	if (@user.password == password) && @user.status == true
		session[:user_id] = @user.id
		redirect "/user/#{@user.id}/dashboard"
	elsif @user
		@user.status_check
		erb :'/user/login'
	else
		erb :'/user/login'
	end
end

get '/user/:id/dashboard' do
	@announcement = Announcement.last
	@user = current_user
	@memberships = Membership.where(user_id: @user.id)
	@events = Event.all.order(:event_date).limit(3)
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

# Go to profile
get '/user/:id/profile' do
	@user = current_user
	erb :'/user/profile'
	 # if @user.nil?
	 #    erb :login
	 #  else 
	 #    session[:user_id] = @user.id
	 #    redirect "/user/#{user.id}/profile"
	 #  end
end

# Edit profile username and password
post '/profile/:id' do
	username = params[:username]
	password = params[:password]
	user = current_user
 	user.update_attributes(username: username, password: password)
  redirect "/user/#{user.id}/dashboard"
end

# Get profile with image
get '/profile' do
  @user = User.new
  erb :profile
end

# Upload profile image to public folder
# post '/profile' do
#   @user = User.new(params[:user])
#      @user.username.upcase!
#   if @user.save
#     session[:id] = @user.id
#     if params[:file].present?
#       tempfile = params[:file][:tempfile]
#       filename = params[:file][:filename]
#       cp(tempfile.path, "public/uploads_imgs/#{@user.id}")
#       redirect '/profile'
#     else
#       redirect '/profile'
#     end
#   else
#     erb :'/login'
#   end
# end

post '/profile/<%= @user.id %>/upload_imgs' do
  tempfile = params['file'][:tempfile]
  filename = params['file'][:filename]
  File.copy(tempfile.path, "public/uploads_imgs/#{@user.id}")
  redirect '/user/profile'
end

# End of Profile Actions

get '/admin' do
	@total_users = User.all.count
	erb :'/admin/index'
end

post '/admin/announcement' do
	@announcement = Announcement.new(
		title: params[:title],
		content: params[:content]
		)
	if @announcement.save
		redirect '/admin'
	else
		erb :'/admin/index'
	end
end

post '/admin/users/:id/deactivate' do
	@user = User.find params[:id]
	@user.update_attributes(status: false)
	redirect '/admin/users'
end

post '/admin/users/:id/activate' do
	@user = User.find params[:id]
	@user.update_attributes(status: true)
	redirect '/admin/users'
end

get '/admin/users' do
	@users = User.all
	erb :'/admin/users/index'
end

get '/admin/events' do
	erb :'/admin/events/index'
end

post '/admin/event' do
	@event = Event.create(
		title: params[:title],
		event_date: params[:date],
		location: params[:location],
		url: params[:url]
	)
end 
