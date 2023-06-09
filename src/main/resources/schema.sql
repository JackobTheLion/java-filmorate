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


CREATE TABLE PUBLIC.REVIEW (
	REVIEW_ID INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
	CONTENT VARCHAR_IGNORECASE NOT NULL,
	IS_POSITIVE BOOLEAN NOT NULL,
	USER_ID INTEGER NOT NULL,
	FILM_ID INTEGER NOT NULL,
	CONSTRAINT REVIEW_FK FOREIGN KEY (USER_ID) REFERENCES PUBLIC.FILMORATE_USERS(USER_ID),
	CONSTRAINT REVIEW_FK_1 FOREIGN KEY (FILM_ID) REFERENCES PUBLIC.FILMS(FILM_ID)
);

CREATE TABLE PUBLIC.REVIEW_LIKE (
	USER_ID INTEGER NOT NULL,
	REVIEW_ID INTEGER NOT NULL,
	IS_LIKED BOOLEAN NOT NULL,
	CONSTRAINT REVIEW_LIKE_PK PRIMARY KEY (USER_ID,REVIEW_ID),
	CONSTRAINT REVIEW_LIKE_FK FOREIGN KEY (USER_ID) REFERENCES PUBLIC.FILMORATE_USERS(USER_ID) ON delete CASCADE,
	CONSTRAINT REVIEW_LIKE_FK_1 FOREIGN KEY (REVIEW_ID) REFERENCES PUBLIC.REVIEW(REVIEW_ID) ON delete CASCADE
);

create TABLE events
(
    event_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    timestamp timestamp DEFAULT NOW(),
    user_id integer REFERENCES filmorate_users (user_id) ON delete CASCADE,
    eventType ENUM ('LIKE', 'REVIEW', 'FRIEND'),
    operation ENUM ('REMOVE', 'ADD', 'UPDATE'),
    entity_id integer
);

CREATE TABLE director
(
    director_id  integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar(50) NOT NULL
);

CREATE TABLE film_directors
(
    film_id integer REFERENCES films (film_id) ON DELETE CASCADE,
    director_id  integer REFERENCES director (director_id) ON DELETE CASCADE,
    PRIMARY KEY (film_id, director_id)
);
alter table friends add CONSTRAINT uniqe_friends UNIQUE (user1_id, user2_id);

alter table likes add CONSTRAINT uniqe_like UNIQUE (film_id, user_id);