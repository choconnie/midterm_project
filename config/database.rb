configure do
  # Log queries to STDOUT in development
  if development?
    set :database, {
      adapter: "sqlite3",
      database: "db/db.sqlite3"
  }
  else
    set :database, ENV['postgres://sbjlqagqrcjfpm:ckAnxPSIiWnwtT71nloEkBk3bV@ec2-54-235-152-114.compute-1.amazonaws.com:5432/dfnk5l9ejko6jh']
  end
  
end
