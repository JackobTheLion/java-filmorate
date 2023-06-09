package ru.yandex.practicum.filmorate.storage.likes;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import ru.yandex.practicum.filmorate.exceptions.NotFoundException;
import ru.yandex.practicum.filmorate.model.Likes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Slf4j
@Component
@Qualifier("dbStorage")
public class DbLikesStorage implements LikesStorage {
    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public DbLikesStorage(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void addLike(Long filmId, Long userId) {
        String sql = "INSERT INTO likes (film_id, user_id) VALUES (?,?)";
        try {
            jdbcTemplate.update(sql, filmId, userId);
            log.info("Like from id {} to film {} added", userId, filmId);
        } catch (DuplicateKeyException e) {
            log.error("User with id {} or film with id {} not found", userId, filmId);
        } catch (DataIntegrityViolationException e) {
            log.error("User with id {} or film with id {} not found", userId, filmId);
            throw new NotFoundException(String.format("User with id %s or film with id %s not found", userId, filmId));
        }
    }

    @Override
    public void removeLike(Long filmId, Long userId) {
        log.info("Removing like from user id {} to film id {}", userId, filmId);
        String sql = "DELETE FROM likes WHERE film_id = ? AND user_id = ?";
        if (jdbcTemplate.update(sql, filmId, userId) != 1) {
            log.error("User with id {} or film with id {} not found", userId, filmId);
            throw new NotFoundException(String.format("User with id %s or film with id %s not found", userId, filmId));
        }
        log.info("Like from id {} to film {} removed", userId, filmId);
    }

    @Override
    public List<Likes> getLikes(Long filmId) {
        String sql = "SELECT * FROM likes WHERE film_id = ?";
        return jdbcTemplate.query(sql, (rs, rowNum) -> mapLikes(rs), filmId);
    }

    @Override
    public List<Likes> getAllLikes() {
        String sql = "SELECT * FROM likes";
        return jdbcTemplate.query(sql, (rs, rowNum) -> mapLikes(rs));
    }

    private Likes mapLikes(ResultSet rs) throws SQLException {
        return Likes.builder()
                .userId(rs.getLong("user_id"))
                .filmId(rs.getLong("film_id"))
                .build();
    }
}