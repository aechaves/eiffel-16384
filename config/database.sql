DROP DATABASE IF EXISTS users_16384;
CREATE DATABASE users_16384;

USE users_16384;

DROP TABLE IF EXISTS users; -- Users
CREATE TABLE users(
    nickname VARCHAR(255),
    password VARCHAR(255),
    board VARCHAR(2555),
    has_unfinished_game BOOLEAN,
  CONSTRAINT users_pk PRIMARY KEY (nickname)
);