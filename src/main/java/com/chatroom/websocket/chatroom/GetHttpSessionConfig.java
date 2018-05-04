package com.chatroom.websocket.chatroom;

import javax.servlet.http.HttpSession;
import javax.websocket.Decoder;
import javax.websocket.Encoder;
import javax.websocket.Extension;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;
import java.util.List;
import java.util.Map;

/**
 * 继承ServerEndpointConfig.Configurator获取httpSession
 * 写入userProperties
 * 在websocket open方法中可获取
 */
public class GetHttpSessionConfig extends ServerEndpointConfig.Configurator {
    @Override
    public void modifyHandshake(ServerEndpointConfig sec, HandshakeRequest request, HandshakeResponse response) {
        sec.getUserProperties().put(HttpSession.class.getName(),request.getHttpSession());
    }

}
