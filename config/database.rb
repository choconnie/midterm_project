configure do
  # Log queries to STDOUT in development
  if Sinatra::Application.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)

  set :database, {
    adapter: "sqlite3",
    database: "db/db.sqlite3"
  } 
  else
    set :database, ENV['postgres://sbjlqagqrcjfpm:ckAnxPSIiWnwtT71nloEkBk3bV@ec2-54-235-152-114.compute-1.amazonaws.com:5432/dfnk5l9ejko6jh']
  end

  # Load all models from app/models, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

end
