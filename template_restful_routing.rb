# view all posts

get '/posts' do
  if session[:student_id]
    @posts = Post.all
    erb :"/posts/all"
  else
    redirect '/login'
  end
end

<p>welcome <%= current_student.email %></p>
<% @posts.each do |post| %>
<p>Title: <%= post.title %></p>
<p>Content: <%= post.content %></p>

<a href="posts/<%= post.id %>/edit">Edit post</a>

<form action='/posts/<%= post.id %>' method="post">
  <input type="hidden" name="_method" value="delete"/>
  <input type="submit" value="Delete Post!"/>
</form>

<% end %>
<p><a href="posts/new">new post</a></p>

######################################################################################
######################################CREATE##########################################

<p><a href="posts/new">new post</a></p>

# create new post - click on the link above

get '/posts/new' do
  @post = Post.new
  erb :"/posts/new"
end

<p>welcome <%= current_student.email %></p>
<form action="/posts" method="post">
  <p>Title: <input type="text" name="title"></p>
  <p>Content: <input type="text" name="content"></p>
  <p><input type="submit" value="create!"></p>
</form>

# post request for creating
post '/posts' do
  @post = Post.new(title: params[:title], content: params[:content], student: current_student)
  if @post.save
    redirect '/posts'
  else
    erb :"/posts/new"
  end
end

######################################################################################
######################################READ##########################################

get '/posts/:id' do
  @post = Post.find(params[:id])
  if @post
    erb :"/posts/show"
  else
    redirect '/posts'
  end
end

<p>welcome <%= current_student.email %></p>
<p><%= @post.title %></p>
<p><%= @post.content %></p>

######################################################################################
######################################EDIT##########################################

<a href="posts/<%= post.id %>/edit">Edit post</a>

get '/posts/:id/edit' do
  @post = Post.find(params[:id])
  if @post
    erb :"/posts/edit"
  else
    redirect '/posts'
  end
end

<p>welcome <%= current_student.email %></p>
<form action="/posts/<%= @post.id %>" method="post">
  <p>Title: <input type="text" name="title" value="<%= @post.title %>"></p>
  <p>Content: <input type="text" name="content" value="<%= @post.content %>"></p>
  <input type="hidden" name="_method" value="put"/>
  <p><input type="submit" value="edit!"></p>
</form>

put '/posts/:id' do
  @post = Post.find(params[:id])
  if @post.update(content: params[:content], title: params[:title])
    redirect "/posts/#{@post.id}"
  else
    erb :"posts/edit"
  end
end

######################################################################################
######################################DELETE##########################################

<form action='/posts/<%= post.id %>' method="post">
  <input type="hidden" name="_method" value="delete"/>
  <input type="submit" value="Delete Post!"/>
</form>

delete '/posts/:id' do
  @post = Post.find(params[:id])
  @post.delete
  redirect '/posts'
end
