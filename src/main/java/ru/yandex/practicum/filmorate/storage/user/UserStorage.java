package ru.yandex.practicum.filmorate.storage.user;

import ru.yandex.practicum.filmorate.model.User;

import java.util.List;

public interface UserStorage {
    User addUser(User user);

    User putUser(User user);

    List<User> getUsers();

    User findUser(Long id);

    void deleteUser(Long id);

    List<User> getAllUsersWIthlikes();
}
