require_relative 'album'

class AlbumRepository
  def all
    albums = []

    sql = 'SELECT * FROM albums;'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      album = Album.new
      album.id = record['id']
      album.title = record['title']
      album.release_year = record['release_year']
      album.artist_id = record['artist_id']

      albums << album
    end

    return albums
  end

  def find(id)
    sql = "SELECT * FROM albums WHERE id = $1"
    param = [id]
    result = DatabaseConnection.exec_params(sql, param)[0]

    album = Album.new
    album.id = result['id']
    album.title = result['title']
    album.release_year = result['release_year']
    album.artist_id = result['artist_id']

    return album
  end
end