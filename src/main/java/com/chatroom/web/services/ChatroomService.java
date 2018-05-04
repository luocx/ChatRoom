package com.chatroom.web.services;

import com.chatroom.web.entity.User;

import java.util.List;

public interface ChatroomService {
    User findUserByAccount(String username);

    User findUserById(String id);

    void updateUserInfo(User user);

    List findEmojiByType(String type);

    void updateUserPwd(User user);
}
