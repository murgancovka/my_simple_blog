ActiveRecord::Base.establish_connection(
    :adapter => "mysql2",
    :database => "test",
    :username => "root",
    :encoding => 'utf8',
    :password => '12345',
    :pool => 10
  )
