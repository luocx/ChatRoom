package com.chatroom.web.dao;

import com.chatroom.web.entity.User;

import java.util.List;

public interface ChatuserMapper {
    User findUserByUseraccount(String username);

    void updateUserInfo(User user);

    List findEmojiBytype(String type);

    void updateUserPwd(User user);

    User findUserById(String id);
}
