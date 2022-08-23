# Single Table Design Recipe

## 1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

As a music lover,
So I can organise my records,
I want to keep a list of albums' titles.

As a music lover,
So I can organise my records,
I want to keep a list of albums' release year.
```

```
Nouns:

album, title, realease year
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.


| Record  | Properties          |
| ------- | ------------------- |
| album   | title, release year |



## 3. Decide the column types

Most of the time, you'll need text, int, bigint, numeric, boolean. If you're in doubt, do some research or ask your peers.

Remember to always have the primary key id as a first columnm Its type will always be SERIAL.

```
# Example

id : SERIAL
title: text
release_year: int
```

## 4. Write the SQL

```sql
-- EXAMPLE
-- file: albums_table.sql

-- Replace the table name, column names and types

CREATE TABLE albums (
  id SERIAL PRIMARY KEY,
  title text,
  release_year int
);
```

## 5. Create the table

```bash
psql -h 127.0.0.1 database_name < albums_table.sql
```