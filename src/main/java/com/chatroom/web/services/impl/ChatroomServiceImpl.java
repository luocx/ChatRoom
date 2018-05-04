package com.chatroom.web.services.impl;

import com.chatroom.web.dao.ChatuserMapper;
import com.chatroom.web.services.ChatroomService;
import com.chatroom.web.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChatroomServiceImpl implements ChatroomService {

    @Autowired
    private ChatuserMapper chatUser;

    public void setChatUser(ChatuserMapper chatUser) {
        this.chatUser = chatUser;
    }

    @Override
    public User findUserByAccount(String useraccount) {
        return chatUser.findUserByUseraccount(useraccount);
    }

    @Override
    public User findUserById(String id) {
        return chatUser.findUserById(id);
    }

    @Override
    public void updateUserInfo(User user) {
        chatUser.updateUserInfo(user);
    }

    @Override
    public List findEmojiByType(String type) {
        return chatUser.findEmojiBytype(type);
    }

    @Override
    public void updateUserPwd(User user) {
        chatUser.updateUserPwd(user);
    }
}
