# in student model

class Student < ActiveRecord::Base
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
    @student = self.find_by(email: email)
    return @student if @student and BCrypt::Password.new(@student.password_hash) == password
  end
end

# ************************************************************************************************************************

# in new.erb

<form action="/students", method="post">
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
  <a href="/students/new">New Student?</a>
</form>

# in home.erb

hello

<p><a href="/logout">Logout</a></p>


# ************************************************************************************************************************

# in student.rb (helpers folder)

helpers do
  def current_student
    if session[:student_id]
      @current_student ||= User.find(session[:student_id])
    end
  end

  def logged_in?
    !current_student.nil?
  end
end


# *************************************************************************************************************************

# in the controller

get '/' do
  if session[:student_id]
    redirect '/home'
  else
    redirect '/login'
  end
end

get '/login' do
  if session[:student_id]
    redirect '/home'
  else
    erb :"/students/login"
  end
end

get '/students/new' do
  erb :"students/new"
end

post '/students' do
  @student = Student.new(email: params[:email], password: params[:password])
  if @student.save
    session[:student_id] = @student.id
    erb :"/students/home"
  else
    erb :"/students/new"
  end
end


post '/login' do
  @student = Student.authenticate(params[:email], params[:password])
  if @student
    session[:student_id] = @student.id
    redirect '/home'
  else
    erb :"/students/login"
  end
end

get '/logout' do
  session.clear
  redirect '/login'
end

get '/home' do
  if session[:student_id]
    erb :"/students/home"
  else
    redirect '/login'
  end
end

