# Single Table Design Recipe

## 1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

As a person who loves movies,
So I can list all my favourite movies
I want to see a list of movies' titles.

As a person who loves movies,
So I can list all my favourite movies
I want to see a list of movies' genres.

As a person who loves movies,
So I can list all my favourite movies
I want to see a list of movies' release year.
```

```
Nouns:
movies, titles, genres, release year

```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.


| Record  | Properties                 |
| ------- | -------------------------- |
| movie   | title, genre, release year |



## 3. Decide the column types

Most of the time, you'll need text, int, bigint, numeric, boolean. If you're in doubt, do some research or ask your peers.

Remember to always have the primary key id as a first columnm Its type will always be SERIAL.

```
# Example

id : SERIAL
title: text
genre: text
release_year: int
```

## 4. Write the SQL

```sql
-- EXAMPLE
-- file: movies.sql

-- Replace the table name, column names and types

CREATE TABLE movies (
  id SERIAL PRIMARY KEY,
  title text,
  genre text,
  release_year int
);
```

## 5. Create the table

```bash
psql -h 127.0.0.1 movie_directory < movies.sql
```