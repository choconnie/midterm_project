require_relative('./helpers/view_helpers.rb')

helpers do

  # def logged_in?
  #   current_user != nil 
  # end
 
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
	unless username.blank?
		@user = User.find_by(username: username)
		if @user == nil
			@undefined = true
			erb :'/user/login'
		elsif (@user.password == password) && @user.status == true
			session[:user_id] = @user.id
			redirect "/user/#{@user.id}/dashboard"
		elsif @user
			@user.status_check
			@user.password_check(password)
			erb :'/user/login'
		end
	end
	erb :'/user/login'
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
		redirect '/user/login'
	else
		erb :'/user/sign_up/index'
	end
end

#####>>>>>> Start of Group View

# List all groups
# get '/groups' do
#   @groups = Group.all
#   erb :'groups/index'
# end

get '/groups' do
	@groups = Group.where(status: true)
	erb :'groups/index'
end

# Form to Add new group
get '/groups/new' do
	@group = Group.new
	erb :'groups/new'
end

# Add to Group List and Save
post '/groups' do
	@group = Group.new(
		group_name: params[:group_name],
		city: params[:city],
    description: params[:description]
	)
	if @group.save
    redirect '/groups'
  else
    erb :'groups/new'
  end
end

# Delete Group from list
# post '/group/:id/delete' do
# 	group = Group.find(params[:id])
# 	group.delete
# 	redirect '/groups'
# end

# Link to see group details
post '/groups/join/membership' do
	@user = current_user
	session[:group_id] = params[:group_id]
	@group = Group.find(session[:group_id])

  registered = Membership.where(user_id: @user.id).where(group_id: @group.id)
  if !(registered.empty?)
 	  session.delete(:group_id)
 	  redirect '/groups'
  else
    @membership = Membership.new(
      user_id: current_user.id,
  	  group_id: params[:group_id]
  	)
  	@membership.save
  	redirect "/groups/#{@group.id}/join"
  end
end

get '/groups/:id/join' do
	@group = Group.find(session[:group_id])
	session.delete(:group_id)
  erb :'/groups/join'
end

get '/groups/:id/details' do
	@group = Group.find(params[:id])
	@posts = Post.where(group_id: @group.id)
  erb :'/groups/details'
end

# Link to Group Post details
get '/groups/:id/posts/:id/details' do
	@post = Post.find(params[:id])
	@comments = Comment.where(post_id: @post.id)
  erb :'/groups/posts/details'
end

#####>>>>>> End of Group View

get '/events' do
	@events = Event.where("event_date >= ?", Date.today).order(:event_date)
	@page = Nokogiri::HTML(open("http://www.blogto.com/events/"))
	@blog_to_links = @page.css('.event-name a').map{|a| [a.text.strip, a["href"]]}
	@blog_to_summary = @page.css('.event-summary').map{|x| [x.text]}
	@blog_to_events = @blog_to_links.zip(@blog_to_summary)
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

#####>>>>>> Start of Profile View

# Go to Profile
get '/user/:id/profile' do
	@user = current_user
 	erb :'/user/profile'
end

# Update the username and password of profile
post '/profile/:id' do
	username = params[:username]
	password = params[:password]
	user = current_user
	user.update_attributes(username: username, password: password)
	redirect "/user/#{user.id}/dashboard"
end

# Choose and image for profile
post '/save_image' do
  
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/uploads_imgs/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end 
  erb :'show'
end

# Upload image to profile
post '/user/profile/upload' do 
	@user = current_user
		File.open('./public/uploads/user_avatars/'+params[:user_image][:filename], "wb") do |new_file|
    new_file.write(params[:user_image][:tempfile].read)
	  end
	  @user.avatar_name = params[:user_image][:filename]
	  @user.save
 		erb :'/user/profile'
end

#####>>>>>> End of profile view

get '/admin' do
	@total_users = User.all.count
	@total_groups = Group.all.count
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
	@total_groups = Group.all.count
	@users = User.all
	erb :'/admin/users/index'
end

get '/admin/events' do
	@total_users = User.all.count
	@total_groups = Group.all.count
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

get '/admin/groups' do
	erb :'/admin/groups/index'
end

#####>>>>>> Start of Admin Delete Group View

post '/admin/groups/:id/deactivate' do
	@group = Group.find params[:id]
	@group.update_attributes(status: false)
	redirect '/admin/groups'
end

post '/admin/groups/:id/activate' do
	@group = Group.find params[:id]
	@group.update_attributes(status: true)
	redirect '/admin/groups'
end

get '/admin/groups' do
	@total_users = User.all.count
	@total_groups = Group.all.count
	@groups = Group.all
	erb :'/admin/groups/index'
end

#####>>>>>> End of Admin Delete Group View







>>>>>>> add_group
