package ru.yandex.practicum.filmorate.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import ru.yandex.practicum.filmorate.exceptions.NotFoundException;
import ru.yandex.practicum.filmorate.model.Director;
import ru.yandex.practicum.filmorate.storage.director.DirectorStorage;

import java.util.List;

@Slf4j
@Service
public class DirectorService {

    private final DirectorStorage directorStorage;

    @Autowired
    public DirectorService(@Qualifier("dbStorage") DirectorStorage directorStorage) {
        this.directorStorage = directorStorage;
    }


    public List<Director> getAllDirectors() {
        log.info("Get all records");
        return directorStorage.getAllDirectors();
    }


    public Director getDirectorById(Long id) {
        log.info("Get director by id {}", id);
        Director director = directorStorage.getDirector(id);
        if (director == null) {
            throw new NotFoundException(String.format("Director with id %s does not exist", id));
        }
        return director;
    }

    public Director createDirector(Director director) {
        log.info("Create director {}", director);
        return directorStorage.createDirector(director);
    }

    public void deleteDirector(Long id) {
        log.info("Delete director {}", id);
        directorStorage.deleteDirector(id);
    }

    public Director updateDirector(Director director) {
        log.info("Update director {}", director);
        return directorStorage.updateDirector(director);
    }
}