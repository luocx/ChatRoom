package com.chatroom.web.interceptor;

import com.chatroom.web.util.FinalValue;
import com.chatroom.web.util.MD5Util;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ChatroomInterceptor extends HandlerInterceptorAdapter {
    private Logger log = Logger.getLogger(ChatroomInterceptor.class);

    private final String LOGIN_URL = "/login";
    private final String CENT_INDEX = "/index";

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
        String loginUrl = request.getContextPath() + LOGIN_URL;
        String ip = request.getRemoteHost();
        String reqUrl = request.getRequestURI();

        String userid = (String)request.getSession().getAttribute(FinalValue.CHATROOM_LOGIN_USERID);
        if (userid ==null || userid.isEmpty()) {
            String secret = "";
            String cuserid = "";
            Cookie[] cookies = request.getCookies();
            for (Cookie coo : cookies) {
                if (coo.getName().equals(FinalValue.COOKIE_USERID)) {
                    cuserid = coo.getValue();
                } else if (coo.getName().equals(FinalValue.COOKIE_SECRET)) {
                    secret = coo.getValue();
                }
            }
            String val = MD5Util.getLowerCaseStringMD5(cuserid + FinalValue.COOKIE_SECRET_VALUE);
            if (val.equals(secret)) {
                userid = cuserid;
            }
        }
        if (userid == null || userid.isEmpty()){
            //log.info("IP："+ip+",地址："+reqUrl);
            if (reqUrl.equals(loginUrl) || reqUrl.equals(request.getContextPath()+"/chatroom")){
                return true;
            }
            response.sendRedirect(loginUrl);
            return false;
        }

        request.getSession().setAttribute(FinalValue.CHATROOM_LOGIN_USERID, userid);

        if (reqUrl.startsWith(loginUrl)){
            response.sendRedirect(request.getContextPath() + CENT_INDEX);
            return false;
        }
        return true;
    }

    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {
    }

    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {
    }
}
