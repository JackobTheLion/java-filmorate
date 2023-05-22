create TABLE filmorate_users
(
    user_id  integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    email    varchar(50) UNIQUE,
    login    varchar(50) UNIQUE,
    name     varchar(50),
    birthday date
);

create TABLE mpa
(
    mpa_id Integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    mpa    varchar(50)
);

create TABLE films
(
    film_id      integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name         varchar(50),
    description  varchar(255),
    release_date date,
    duration     integer,
    mpa_id       Integer REFERENCES mpa (mpa_id) ON delete CASCADE
);

create TABLE likes
(
    like_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    film_id integer REFERENCES films (film_id) ON delete CASCADE,
    user_id integer REFERENCES filmorate_users (user_id) ON delete CASCADE
);

create TABLE genre
(
    genre_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name     varchar(50)
);

create TABLE film_genre
(
    film_id  integer REFERENCES films (film_id) ON delete CASCADE,
    genre_id integer REFERENCES genre (genre_id) ON delete CASCADE,
    PRIMARY KEY (film_id, genre_id)
);

create TABLE friends
(
    friendship_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    user1_id  integer REFERENCES filmorate_users (user_id) ON delete CASCADE,
    user2_id  integer REFERENCES filmorate_users (user_id) ON delete CASCADE,
    confirmed boolean DEFAULT false
);

create TABLE reviews
(
    review_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY
);

create TABLE like_event
(
    event_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    timestamp timestamp DEFAULT NOW(),
    user_id integer REFERENCES filmorate_users (user_id) ON delete CASCADE,
    eventType ENUM ('LIKE', 'REVIEW', 'FRIEND') DEFAULT 'LIKE',
    operation ENUM ('REMOVE', 'ADD', 'UPDATE'),
    entity_id integer REFERENCES films (film_id) ON delete CASCADE
);

create TABLE review_event
(
    event_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    timestamp timestamp DEFAULT NOW(),
    user_id integer REFERENCES filmorate_users (user_id) ON delete CASCADE,
    eventType ENUM ('LIKE', 'REVIEW', 'FRIEND') DEFAULT 'REVIEW',
    operation ENUM ('REMOVE', 'ADD', 'UPDATE'),
    entity_id integer REFERENCES reviews (review_id) ON delete CASCADE
);

create TABLE friend_event
(
    event_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    timestamp timestamp DEFAULT NOW(),
    user_id integer REFERENCES filmorate_users (user_id) ON delete CASCADE,
    eventType ENUM ('LIKE', 'REVIEW', 'FRIEND') DEFAULT 'FRIEND',
    operation ENUM ('REMOVE', 'ADD', 'UPDATE'),
    entity_id integer REFERENCES filmorate_users (user_id) ON delete CASCADE
);

alter table friends add CONSTRAINT uniqe_friends UNIQUE (user1_id, user2_id);

alter table likes add CONSTRAINT uniqe_like UNIQUE (film_id, user_id);