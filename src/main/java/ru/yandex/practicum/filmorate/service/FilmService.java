package ru.yandex.practicum.filmorate.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.yandex.practicum.filmorate.exceptions.LikeNotFoundException;
import ru.yandex.practicum.filmorate.model.Film;
import ru.yandex.practicum.filmorate.storage.film.FilmStorage;
import ru.yandex.practicum.filmorate.storage.user.UserStorage;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class FilmService {
    private final FilmStorage filmStorage;
    private final UserStorage userStorage;

    @Autowired
    public FilmService(FilmStorage filmStorage, UserStorage userStorage) {
        this.filmStorage = filmStorage;
        this.userStorage = userStorage;
    }

    public Film addFilm(Film film) {
        log.error("Trying to add film {}", film);
        return filmStorage.addFilm(film);
    }

    public Film putFilm(Film film) {
        log.error("Trying to put film {}", film);
        return filmStorage.putFilm(film);
    }

    public List<Film> getFilms() {
        List<Film> films = filmStorage.getFilms();
        log.info("Number of films registered: {}", films.size());
        return films;
    }

    public Film findFilm(Long id) {
        log.info("Looking for film with id: {}", id);
        return filmStorage.findFilm(id);
    }

    public Film addLike(Long filmId, Long userId) {
        log.info("Adding like from id {} to film id {}", userId, filmId);
        userStorage.findUser(userId);
        Film film = filmStorage.findFilm(filmId);
        film.getLikes().add(userId);
        log.info("Like from id {} to film {} added", userId, filmId);
        return film;
    }

    public Film removeLike(Long filmId, Long userId) {
        log.info("Removing like from user id {} to film id {}", userId, filmId);
        userStorage.findUser(userId);
        Film film = filmStorage.findFilm(filmId);
        if (!film.getLikes().remove(userId)) {
            log.error("Like from id {} to film id {} does not exist", userId, filmId);
            throw new LikeNotFoundException(String.format("Like from id %s to film id %s does not exist", userId, filmId));
        }
        log.info("Like from id {} to film {} removed", userId, filmId);
        return film;
    }

    public List<Film> getTopFilms(Integer count) {
        log.info("Returning top liked films, count {}", count);
        return filmStorage.getFilms().stream()
                .sorted((film1, film2) -> (film1.getLikes().size() - film2.getLikes().size()) * -1)
                .limit(count)
                .collect(Collectors.toList());
    }
}