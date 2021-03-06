require_relative('./helpers/view_helpers.rb')

helpers do

  # def logged_in?
  #   current_user != nil 
  # end
 
	def current_user
		User.find(session[:user_id]) if session[:user_id]
	end

	def get_post_details
		@group = Group.find(params[:id])
		@posts = Post.where(group_id: @group.id)
		@tags = []
		@posts.each do |post|
			tags = post.tags
			tags.each do |tag|
				@tags.push tag.name 
			end
		end
		@tags = @tags.uniq
	end

	def get_service_details
		@services = Service.all
		@tags = []
		@services.each do |service|
				tags = service.tags
				tags.each do |tag|
					@tags.push tag.name 
				end
			end
		@tags = @tags.uniq
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
	unless username.blank?
		@user = User.find_by(username: username)
		if @user == nil
			@undefined = true
			erb :'/user/login'
		elsif (@user.authenticate(params[:password])) && @user.status == true
			session[:user_id] = @user.id
      session.delete(:show_group_page_error)
			redirect "/user/#{@user.id}/dashboard"
		elsif @user
			@user.status_check
			@user.password_check(params[:password])
			erb :'/user/login'
		end
	end
	erb :'/user/login'
end

get '/user/:id/dashboard' do
	@announcement = Announcement.last
	@user = current_user
	@memberships = @user.groups
	@events = Event.where("event_date >= ?", Date.today).order(:event_date).limit(3)
	erb :'/user/dashboard'
end

get '/user/sign_out' do
	#session[:user_id] = nil
  session.delete(:user_id)
	redirect '/'
end

get '/user/sign_up' do
	erb :'/user/sign_up/index'
end

post '/user/sign_up' do
	@user = User.new(
		username: params[:username],
		email: params[:email],
		password: params[:password]
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

# Find all groups with status == true
get '/groups' do
	@user = current_user
	@groups = Group.where(status: true)
  if session[:user_id]
	# @group_ids = @groups.map{|group| group.id}
	@user_groups = @user.groups.map{|group| group.id}
	erb :'groups/index'
  else
    session[:show_group_page_error] = "Please login first and Join our group! :)"
    redirect '/'
  end
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

post '/groups/join/:id' do
	@user = current_user
	@group = Group.find(params[:id])
	@membership = Membership.create(
    user_id: @user.id,
	  group_id: @group.id
	)
  redirect "/groups/#{@group.id}/join"
end

# Link to see group details
get '/groups/:id/join' do
	@group = Group.find(params[:id])
  erb :'/groups/join'
end

get '/groups/:id/details' do
	get_post_details
  erb :'/groups/details'
end

get '/groups/:id/posts/:tag' do
	get_post_details
	@tag = Tag.find_by(name: params[:tag])
	@filtered_posts = []
	@posts.each do |post|
 		if post.tags.include?(@tag) 
    	@filtered_posts.push post      
  	end
	end
  erb :'/groups/posts/filtered'
end

# Link to Group Post details
get '/groups/:group_id/posts/:post_id/details' do
	@group = Group.find params[:group_id]
	@post = Post.find(params[:post_id])
	@comments = Comment.where(post_id: params[:post_id])
  erb :'/groups/posts/details'
end

post '/groups/:group_id/posts/:post_id/comment' do
	@group = Group.find params[:group_id]
	@post = Post.find params[:post_id] 
	@user = current_user
	@comment = Comment.new(
		content: params[:content],
		post_id: @post.id
		)
	@comment.save
	@comments = Comment.where(post_id: params[:post_id])
	erb :'/groups/posts/details'
end

post '/groups/:id/post/create' do
	@id = params[:id]
	@new_post = Post.create(
		group_id: params[:id],
    title: params[:title],
    content: params[:content]
	)
	tags = params[:tags].split
	tags.each do |tag|
		@new_post.add_tag(tag)
	end
	redirect "/groups/#{@id}/details"
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
	get_service_details
  erb :'/services/index'
end

get '/services/filtered/:name' do
	get_service_details
	@tag = Tag.find_by(name: params[:name])
	@filtered_services = []
	@services.each do |service|
 		if service.tags.include?(@tag) 
    	@filtered_services.push service      
  	end
	end
  erb :'/services/filtered'
end

get '/services/:id/details' do
	@service = Service.find params[:id]
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
	@user = current_user
	@total_users = User.all.count
	@total_groups = Group.all.count
	erb :'/admin/index'
end

post '/admin/announcement' do
	@user = current_user
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
	@user = current_user
	@total_users = User.all.count
	@total_groups = Group.all.count
	@users = User.all
	erb :'/admin/users/index'
end

get '/admin/events' do
	@user = current_user
	@total_users = User.all.count
	@total_groups = Group.all.count
	erb :'/admin/events/index'
end

post '/admin/event' do
	@user = current_user
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

get '/admin/services' do
	@user = current_user
	erb :'/admin/services/index'
end

post '/admin/services' do
	@user = current_user
	@service = Service.new(
		title: params[:title],
    content: params[:content],
    email: params[:email],
    phone: params[:phone]
  )
  if @service.save
  	@success = true
  	unless params[:tags].empty?
	  	tags = params[:tags].split
	  	tags.each do |tag|
	  		@service.add_tag(tag)
	  	end
  	end
	end
  erb :'/admin/services/index'
end
#####>>>>>> Start of Admin Delete Group View

# Go to admin/groups page and list
# all the groups added
get '/admin/groups' do
  @user = current_user
  @total_users = User.all.count
  @total_groups = Group.all.count
  @groups = Group.all
  erb :'/admin/groups/index'
end

# Deactivate Group 
post '/admin/groups/:id/deactivate' do
  @group = Group.find params[:id]
  @group.update_attributes(status: false)
  redirect '/admin/groups'
end

# Activate Group
post '/admin/groups/:id/activate' do
  @group = Group.find params[:id]
  @group.update_attributes(status: true)
  redirect '/admin/groups'
end

#####>>>>>> End of Admin Delete Group View
#####>>>>>>
#####>>>>>> Start of Email Contact View

post '/contact/index' do
  erb :'/contacts/index'
end

# get '/' do
#   erb :'/index'
# end

# get '/contact' do
#   erb :'/index'
# end

# get '/thankyou' do
#   Pony.email(to: "isc.canada@gmail.com",
#    from: params[:email],
#    subject: "You got a new message from #{params[:name]}",
#    :message => params[:message],
#    :via => :smtp,
#    :via_options => {
#    :address        => 'smtp.gmail.com',
#    :port           => '587',
#    :user_name      => 'isc.canada',
#    :password       => 'midterm16',
#    :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
#    :domain         => "http://localhost:3000/" # the HELO domain provided by the client to the server
#     }
#   )
#   "Thank you #{params[:name]} for contacting us"
# end

# get '/contact/index' do
#   erb :'/contacts/index'
# end

# post '/contact/index' do 
# Pony.mail(
#   name:    params[:name],
#   email:   params[:email],
#   message: params[:message],
#   to:      'isc.canada@gmail.com',
#   port:    '587',
#   via:     :smtp,
#   via_options: { 
#     address:              'smtp.gmail.com', 
#     port:                 '587', 
#     enable_starttls_auto: :true, 
#     user_name:            'isc.canada@gmail.com', 
#     password:             'midterm16', 
#     authentication:       :plain, 
#     domain:               'localhost.localdomain'
#   })
#   redirect '/contacts/index' 
# end

#####>>>>>> End of Email Contact View

