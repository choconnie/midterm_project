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
	@events = Event.where("event_date >= ?", Date.today).order(:event_date).limit(3)
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
	@events = Event.where("event_date >= ?", Date.today).order(:event_date)
  erb :'/events/index'
end

get '/event/:id/details' do
	@event = Event.find params[:id]
	erb :'/events/details/index'
end

get '/services' do
	@services = Service.all
  erb :'/services/index'
end

get '/services/:id/details' do
	@service = Service.find(params[:id])
  erb :'/services/details'
end

#### Start of Profile View

# Go to Profile
get '/user/:id/profile' do
	@user = current_user
	# @photo = Photo.find_by user_id: params[:id]
 	erb :'/user/profile'
end

post '/save_image' do
  
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/uploads_imgs/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end 
  erb :'show'
end



# Get profile with image
# get '/profile' do
#   @user = User.new
#   erb :profile
# end

# Upload image for profile
# post '/profile/:id' do 
# 	username = params[:username]
# 	password = params[:password]
# 	user = current_user
#  	user.update_attributes(username: username, password: password)

# 	@user_image = User.find_by(filename: params[:filename])
# 	File.open('uploads_imgs/' + params[:user_image][:filename], "wb") do |new_file|
#     new_file.write(params[:user_image][:tempfile].read)
#   end
#   @user_image.update_attributes(user_image: user_image)
# 	if @user_image.persisted?
# 		redirect '/user/#{user.id}/profile'
# 	else
# 		erb :'user/profile'
# 	end
# end

##### End of Profile Actions

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
		@success = true
	end
	erb :'/admin/index'
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
	@total_users = User.all.count
	@users = User.all
	erb :'/admin/users/index'
end

get '/admin/events' do
	@total_users = User.all.count
	erb :'/admin/events/index'
end

post '/admin/event' do
	@event = Event.new(
		title: params[:title],
		event_date: params[:date],
		location: params[:location],
		url: params[:url],
		details: params[:details]
	)
	if @event.save
		@success = true
	end
	erb :'/admin/events/index'
end 