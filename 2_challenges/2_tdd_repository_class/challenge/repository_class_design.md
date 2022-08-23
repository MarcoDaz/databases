# book_store Model and Repository Classes Design Recipe

## 1 .Design and create the Table

```
Table: books

Columns:
id | name | cohort_name
```

## 2. Create Test SQL Seeds

```sql
TRUNCATE TABLE books RESTART IDENTITY;

INSERT INTO books
  (name, cohort_name) VALUES
  (1, 'Nineteen Eighty-Four', 'George Orwell'),
  (2, 'Mrs Dalloway', 'Virginia Woolf');
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: books

# Model class
class Book
end

# Repository class
# (in lib/student_repository.rb)
class BookRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: books
class Book

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :author_name
end
```
You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: books
class BooksRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, author_name FROM books;

    # Returns an array of Book objects.
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1 Get all books
RSpec.describe BookRepository do
  describe "#all" do
    it "return 2 books"
      repo = BookRepository.new
      books = repo.all
      
      books.length # => 2
      books.first.title # => 'Nineteen Eighty-Four'
      books.first.author_name # => 'George Orwell'
    end
  end
end

```

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby

def reset_books_table
  seed_sql = File.read('spec/seeds_books.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'book_store_test' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_books_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behavioour

After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.