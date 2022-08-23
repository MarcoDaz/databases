TRUNCATE TABLE books RESTART IDENTITY;

INSERT INTO books
  (title, author_name) VALUES
  ('Nineteen Eighty-Four', 'George Orwell'),
  ('Mrs Dalloway', 'Virginia Woolf');