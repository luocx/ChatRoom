package com.chatroom.websocket.chatroom;

import com.chatroom.web.entity.User;
import com.chatroom.web.util.Convert;
import com.chatroom.web.util.FinalValue;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint(value = "/chatServer", configurator = GetHttpSessionConfig.class)
public class ChatServer {
    private static final Logger log = Logger.getLogger(ChatServer.class);

    private static volatile int linenum = 0;          //当前在线人数
    private static CopyOnWriteArraySet<ChatServer> chatServerList = new CopyOnWriteArraySet<ChatServer>(); //
    private User user;            //用户
    private Session session;            //当前登录用户的会话，用来发送消息
    private HttpSession httpSession;    //当前请求会话，用来取用户账号信息

    private static List<User> userlist = new ArrayList<User>();
    private static Map<String, Session> routetablel = new HashMap<String, Session>();        //映射用户名跟会话关系

    /**
     * 建立连接成功时调用
     *
     * @param session
     * @param conf
     */
    @OnOpen
    public void open(Session session, EndpointConfig conf) {
        this.session = session;
        this.httpSession = (HttpSession) conf.getUserProperties().get(HttpSession.class.getName());

        user = (User) httpSession.getAttribute(FinalValue.CHATROOM_USER);
        if (user == null){
            try {
                session.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        String userid = Convert.toReadStr(user.getUserid());

        //如果当前用户在多个客户端登录，则后面登录的将之前登录的客户端挤下线
        if (routetablel.get(userid) != null){
            try {
                routetablel.get(userid).close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        addLineNum();
        //加入用户列表
        userlist.add(user);
        //映射关系 用于发送消息给指定用户
        routetablel.put(userid, session);
        chatServerList.add(this);
        sendToAll(getMessage("用户上线通知。","notice", userlist));
    }

    /**
     * 连接关闭时清除session
     * @param session
     * @param reason
     */
    @OnClose
    public void close(Session session, CloseReason reason) {
        //移除用户列表
        removeLineNum();
        userlist.remove(user);
        routetablel.remove(user.getUserid());
        chatServerList.remove(this);
        sendToAll(getMessage("用户下线通知。", "notice", userlist));
    }

    /**
     * 接收客户端的消息
     *
     * @param session
     * @param msg
     *
     * msg = {from:"", message:"", to:""}
     */
    @OnMessage
    public void onMessage(Session session, String msg) {
        try {
            //log.info("接收到客户端数据："+msg);

            JSONObject data = JSONObject.fromObject(msg);
            JSONObject message = data.getJSONObject("message");

            if (message.get("to") == null || message.getString("to").isEmpty()){
                sendToAll(msg);
            }else {
                String[] userlist = message.getString("to").split(",");
                for (String userid : userlist){
                    sendToSinger(routetablel.get(userid), msg);
                }
            }
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    /**
     * 连接出现错误时调用
     *
     * @param session
     * @param error
     */
    @OnError
    public void error(Session session, Throwable error) {
        log.error("连接异常："+error.getMessage());
        //error.printStackTrace();
    }

    private void addLineNum() {
        ChatServer.linenum ++;
    }

    private void removeLineNum(){
        ChatServer.linenum --;
    }
    /**
     * 发送消息给所有会话
     * @param message
     */
    public void sendToAll(String message){
        for (ChatServer chatServer : chatServerList){
            try {
                chatServer.session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 发送消息给单个会话
     * @param username
     */
    private void sendToSinger(Session session, String message) {
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 生成系统通讯消息
     * @param text
     * @param type
     * @param userlist
     * @return
     */
    private String getMessage(String message, String type, List userlist){
        JSONObject json = new JSONObject();
        json.put("message",message);
        json.put("userlist", userlist);
        json.put("type",type);
        return json.toString();
    }
}
