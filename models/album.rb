
require('pg')
require_relative('artist')
require_relative('../db/sql_runner')

class Album

  attr_accessor :title, :genre, :artist_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @artist_id = options['artist_id'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM albums"
    SqlRunner.run(sql)
  end

  def save()
    sql = "INSERT INTO albums (
             title,
             genre,
             artist_id
            ) VALUES (
               $1, $2, $3
              )
          RETURNING id"
    values = [@title, @genre, @artist_id]
    @id = SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM albums"
    results = SqlRunner.run(sql)
    return results.map { |album| Album.new(album) }
  end

  def artists()
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [@artist_id]
    return SqlRunner.run(sql, values)[0]['name']
  end



end
