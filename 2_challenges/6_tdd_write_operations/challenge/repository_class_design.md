# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: users
Columns:
id | email_address | username

Table: posts
Columns:
id | title | content | views
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users, posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO
  users (email_address, username)
  VALUES
    ('user_1@email.com', 'user_1'),
    ('user_2@email.com', 'user_2');

INSERT INTO
  posts (title, content, views, user_id)
  VALUES
    ('post_1', 'content_1', 10, 1),
    ('post_2', 'content_2', 20, 1),
    ('post_3', 'content_3', 30, 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < social_network.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: users

# Model class
class User
end

# Repository class
class UserRepository
end

# Table name: posts

# Model class
class Post
end

# Repository class
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: users

# Model class
class Users

  # Replace the attributes by your own columns.
  attr_accessor :id, :email_address, :username
end

# EXAMPLE
# Table name: posts

# Model class
class Post

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :content, :views, :user_id
end
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: users
class UserRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT * FROM users;

    # Returns an array of User objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT * FROM users WHERE id = $1;

    # Returns a single User object.
  end

  # Creates a users record
  # Given a User object
  def create(user)
    # SQL:
    # INSERT INTO users (email_address, username)
    # VALUES ($1, $2);

    # Return nothing
  end

  # Updates a users record
  # Given a User object with updated attributes
  def update(user)
    # SQL:
    # UPDATE users
    # SET email_address = $1, username = $2
    # WHERE id = $3;

    # Return nothing
  end

  # Delete a users record
  # Given a matching id
  def delete(id)
    # SQL:
    # DELETE FROM users
    # WHERE id = $1

    # Return nothing
  end
end

# Table name: posts
class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT * FROM posts;

    # Returns an array of Post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT * FROM posts WHERE id = $1;

    # Returns a single Post object.
  end

  # Creates a posts record
  # Given a Post object
  def create(post)
    # SQL:
    # INSERT INTO posts (title, content, views, user_id)
    # VALUES ($1, $2, $3, $4);

    # Return nothing
  end

  # Updates a posts record
  # Given a Post object with updated attributes
  def update(post)
    # SQL:
    # UPDATE posts
    # SET title = $1,
    #     content = $2,
    #     views = $3,
    #     user_id = $4,
    # WHERE id = $5;

    # Return nothing
  end

  # Delete a posts record
  # Given a matching id
  def delete(id)
    # SQL:
    # DELETE FROM posts
    # WHERE id = $1

    # Return nothing
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

### Tests for UserRepository
```ruby
# 1. return all users
repo = UserRepository.new
all_users = repo.all

all_users.length # => 2

all_users.first.email_address # => 'user_1@email.com'
all_users.first.username # => 'user_1'

all_users.last.email_address # => 'user_2@email.com'
all_users.last.username # => 'user_2'

# 2. returns a single user record given its id
repo = UserRepository.new
user = repo.find(2)

user.email_address # => 'user_2@email.com'
user.username # => 'user_2'

# 3. can create a user record given a User object
repo = UserRepository.new

new_user = User.new
new_user.email_address = 'new_user@email.com'
new_user.username = 'new_user'

repo.create(new_user)

all_users = repo.all
latest_user = all_users.last

latest_user.email_address # => 'new_user@email.com'
latest_user.username # => 'new_user'

# 4. can update a user record given an updated User object
repo = UserRepository.new

user = repo.find(1) # User Object
user.email_address = 'new@email.com'
user.username = 'new'

repo.update(user)
updated_user = repo.find(1) # same id

updated_user.email_address # => 'new@email.com'
updated_user.username # => 'new'

# 5. can delete a user record given its id
repo = UserRepository.new
repo.delete(1)

all_users = repo.all

all_users.length # => 1

all_users.first.email_address # => 'user_2@email.com'
all_users.first.username # => 'user_2'
```

#### Tests for PostRepository
```ruby
# 1. return all posts
repo = PostRepository.new
all_posts = repo.all

all_posts.length # => 3

all_posts.first.title # => 'post_1'
all_posts.first.content # => 'content_1'
all_posts.first.views # => 10
all_posts.first.user_id # => 1

all_posts.last.title # => 'post_3'
all_posts.last.content # => 'content_3'
all_posts.last.views # => 30
all_posts.last.user_id # => 2

# 2. returns a single post record given its id
repo = PostRepository.new
post = repo.find(2)

post.title # => 'post_2'
post.content # => 'content_2'
post.views # => 20
post.user_id # => 1

# 3. can create a user record given a User object
repo = PostRepository.new

new_post = Post.new
new_post.title = 'new_title'
new_post.content = 'new_content'
new_post.views = 40
new_post.user_id = 2

repo.create(new_post)

all_posts = repo.all
latest_post = all_posts.last

latest_post.title # => 'new_title'
latest_post.content # => 'new_content'
latest_post.views # => 40
latest_post.user_id # => 2

# 4. can update a post record given an updated Post object
repo = PostRepository.new

post = repo.find(1) # post Object
post.title = 'updated_title'
post.content = 'updated_content'
post.views = 100
post.user_id = 2

repo.update(post)
updated_post = repo.find(1) # same id

updated_post.title # => 'updated_title'
updated_post.content # => 'updated_content'
updated_post.views # => 100
updated_post.user_id # => 2

# 5. can delete a post record given its id
repo = PostRepository.new
repo.delete(2)

all_posts = repo.all

all_posts.length # => 2

all_posts.first.title # => 'post_1'
all_posts.first.content # => 'content_1'
all_posts.first.views # => 10
all_posts.first.user_id # => 1

all_posts.last.title # => 'post_3'
all_posts.last.content # => 'content_3'
all_posts.last.views # => 30
all_posts.last.user_id # => 2
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
def reset_social_network
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_social_network
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._