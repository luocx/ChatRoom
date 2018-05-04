package com.chatroom.web.filter;

import com.chatroom.web.util.FinalValue;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class JspFilter implements Filter {

    private final String LOGIN_PAEG = "/login";        //登錄url
    private final String INDEX_PAGE = "/index";              //首頁url

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }


    /**
     * 对直接访问jsp的地址进行拦截返回404，访问首页时检查登录状态
     * @param servletRequest
     * @param servletResponse
     * @param filterChain
     * @throws IOException
     * @throws ServletException
     */
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest)servletRequest;
        HttpServletResponse response =  (HttpServletResponse)servletResponse;

        HttpSession session = request.getSession();
        String requrl = request.getRequestURI();
        if (requrl.endsWith(".jsp")){
            response.sendError(404);
            return;
        }
        if (session.getAttribute(FinalValue.CHATROOM_LOGIN_USERID) == null){
            response.sendRedirect(request.getContextPath()+ LOGIN_PAEG);
            return;
        }else{
            response.sendRedirect(request.getContextPath()+ INDEX_PAGE);
            return;
        }
    }

    @Override
    public void destroy() {

    }
}
