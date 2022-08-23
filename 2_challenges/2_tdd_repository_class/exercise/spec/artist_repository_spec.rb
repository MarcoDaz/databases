require 'artist_repository'

RSpec.describe ArtistRepository do
  def reset_artists_table
    seed_sql = File.read('spec/seeds_artists.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_artists_table
  end

  describe "#all" do
    it "returns 2 artists" do
      repo = ArtistRepository.new
      albums = repo.all

      expect(albums.length).to eq 2
      expect(albums.first.name).to eq 'Pixies'
      expect(albums.first.genre).to eq 'Rock'
    end
  end
end