get '/users' do
  users = DB.execute("SELECT * FROM users")
  users.to_json
end

post '/users' do
  data = JSON.parse(request.body.read)
  name = data['name']
  email = data['email']
  password = data['password']

  begin
    DB.execute("INSERT INTO users (name, email, password) (?, ?, ?)", [name, email, password])
    status 201
    { message: "User created successfully" }.to_json
  rescue SQLite3::ConstraintException
    status 409
    { error: "Email already exists" }.to_json
  end
end
