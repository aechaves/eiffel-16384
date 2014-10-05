DROP TABLE IF EXISTS users; -- Users
CREATE TABLE users(
    id INT(11) NOT NULL AUTO_INCREMENT,
    nickname VARCHAR(255),
    password VARCHAR(255),
    board VARCHAR(255),
    has_unfinished_game BOOLEAN,
  CONSTRAINT users_pk PRIMARY KEY (id)
);