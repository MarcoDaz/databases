# Albums Model and Repository Classes Design Recipe

## 1. Design and create the Table
```
Table: albums

Columns:
id | title | release_year | artist_id
```

## 2. Create Test SQL Seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- Write your SQL seed here.

-- First, you'd need to truncate the table - this is so our table is emptied between each test run so we ca start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE albums RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO albums
  ("title", "release_year", "artist_id")
  VALUES
  ('Doolittle', 1989, 1),
  ('Surfer Rosa', 1988, 1),
  ('Waterloo', 1974, 2),
  ('Super Trouper', 1980, 2),
  ('Bossanova', 1990, 1),
  ('Lover', 2019, 3),
  ('Folklore', 2020, 3),
  ('I Put a Spell on You', 1965, 4),
  ('Baltimore', 1978, 4),
  ( 'Here Comes the Sun', 1971, 4),
  ( 'Fodder on My Wings', 1982, 4),
  ( 'Ring Ring', 1973, 2);
```
Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: albums

# Model class
# (in lib/album.rb)
class Album
end

# Repository class
# (in lib/album_repository.rb)
class AlbumRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: albums
class Album
  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :release_year, :artist_id
end
```
You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: albums
class AlbumsRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums;

    # Returns an array of Album objects.
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# 1 - Get all albums
repo = AlbumRepository.new
albums = repo.all

albums.length # => 2
albums.first.title # => 'Doolittle'
albums.first.release_year # => 1989
albums.first.artist_id # => 1
```

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

def reset_albums_table
  seed_sql = File.read('spec/seeds_albums.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_albums_table
  end
end
```

## 8. Test-drive and implement the Repository class behavioour

After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.