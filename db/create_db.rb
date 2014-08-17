require 'sequel'
DB = Sequel.sqlite('game_database.db')
DB.create_table :players do
  primary_key :id
  String :name
  String :email
  String :available_challenges
  Integer :score
end
