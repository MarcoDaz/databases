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