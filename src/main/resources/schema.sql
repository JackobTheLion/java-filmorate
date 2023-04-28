CREATE TABLE filmorate_users
(
    user_id  integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    email    varchar(50) UNIQUE,
    login    varchar(50) UNIQUE,
    name     varchar(50),
    birthday date
);

CREATE TABLE mpa
(
    mpa_id Integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    mpa    varchar(50)
);

CREATE TABLE films
(
    film_id      integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name         varchar(50),
    description  varchar(255),
    release_date date,
    duration     integer,
    mpa_id       Integer REFERENCES mpa (mpa_id) ON DELETE CASCADE
);

CREATE TABLE likes
(
    film_id integer REFERENCES films (film_id) ON DELETE CASCADE,
    user_id integer REFERENCES filmorate_users (user_id) ON DELETE CASCADE,
    PRIMARY KEY (film_id, user_id)
);

CREATE TABLE genre
(
    genre_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name     varchar(50)
);

CREATE TABLE film_genre
(
    film_id  integer REFERENCES films (film_id) ON DELETE CASCADE,
    genre_id integer REFERENCES genre (genre_id) ON DELETE CASCADE,
    PRIMARY KEY (film_id, genre_id)
);

CREATE TABLE friends
(
    user1_id  integer REFERENCES filmorate_users (user_id) ON DELETE CASCADE,
    user2_id  integer REFERENCES filmorate_users (user_id) ON DELETE CASCADE,
    PRIMARY KEY (user1_id, user2_id),
    confirmed boolean DEFAULT false
);