# in user models

require 'bcrypt'
class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: /[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+/, message: "valid email required" }
  validates :password, presence: true

  def password=(plaintext)
    if !plaintext.empty?
      self.password_hash = BCrypt::Password.create(plaintext)
    end
  end

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def self.authenticate(email, password)
    @user = self.find_by(email: email)
    return @user if @user and BCrypt::Password.new(@user.password_hash) == password
  end
end

# ************************************************************************************************************************

# in new.erb

<form action="/users", method="post">
  <p>email: <input type="text" name="email"></p>
  <p>password: <input type="password" name="password"></p>
  <p><input type="submit" value="create"></p>
</form>

# ************************************************************************************************************************

# in login.erb

<form action="/login", method="post">
  <p>email: <input type="text" name="email"></p>
  <p>password: <input type="password" name="password"></p>
  <p><input type="submit" value="login"></p>
  <a href="/users/new">New User?</a>
</form>

# ************************************************************************************************************************

# in home.erb

hello

<p><a href="/logout">Logout</a></p>

# ************************************************************************************************************************

# in user.rb (helpers folder)

helpers do
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end
end

# *************************************************************************************************************************

# in the controller

get '/' do
  if session[:user_id]
    redirect '/home'
  else
    redirect '/login'
  end
end

get '/login' do
  if session[:user_id]
    redirect '/home'
  else
    erb :"/users/login"
  end
end

get '/users/new' do
  erb :"users/new"
end

post '/users' do
  @user = User.new(email: params[:email], password: params[:password])
  if @user.save
    puts "hello"
    session[:user_id] = @user.id
    erb :"/users/home"
  else
    erb :"/users/new"
  end
end


post '/login' do
  @user = User.authenticate(params[:email], params[:password])
  if @user
    session[:user_id] = @user.id
    redirect '/home'
  else
    erb :"/users/login"
  end
end

get '/logout' do
  session.clear
  redirect '/login'
end

get '/home' do
  if session[:user_id]
    erb :"/users/home"
  else
    redirect '/login'
  end
end
