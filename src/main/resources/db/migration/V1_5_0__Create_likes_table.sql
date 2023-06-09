CREATE TABLE likes
(
    like_id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    film_id integer NOT NULL REFERENCES films (film_id),
    user_id integer NOT NULL REFERENCES filmorate_users (user_id)
);

ALTER TABLE likes
    ADD CONSTRAINT uniqe_like UNIQUE (film_id, user_id);