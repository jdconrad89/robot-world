require 'sqlite3'

class Robot
  attr_reader :name, :department,
              :city, :state,
              :id

  def initialize(robot_params)
    @name       = robot_params["name"]
    @department = robot_params["department"]
    @id         = robot_params["id"] if robot_params["id"]
    @city       = robot_params["city"]
    @state      = robot_params["state"]
    @database   = SQLite3::Database.new('db/robot_world_development.db')
    @database.results_as_hash = true
  end

  def self.database
    database = SQLite3::Database.new('db/robot_world_development.db')
    database.results_as_hash = true
    database
  end

  def self.all
    robots = database.execute("SELECT * FROM robots")
    robots.map do |robot|
      Robot.new(robot)
    end
  end

  def self.find(id)
    robot = database.execute("SELECT * FROM robots
                              WHERE id = ?", id).first
    Robot.new(robot)
  end

  def save
    @database.execute("INSERT INTO robots (name, department, city, state) VALUES (?, ?, ?, ?);", @name, @department, @city, @state)
  end

  def self.update(id, robot_params)
    database.execute("UPDATE robots
                      SET name       = ?,
                          department = ?,
                          city       = ?,
                          state      = ?
                      WHERE id       = ?;",
                      robot_params[:name],
                      robot_params[:department],
                      robot_params[:city],
                      robot_params[:state],
                      id)
    Robot.find(id)
  end

  def self.destroy(id)
    database.execute("DELETE FROM robots
                      WHERE id = ?;", id)
  end

end
