<%@ page import="com.chatroom.web.util.FinalValue" %><%--
  Created by IntelliJ IDEA.
  User: 罗晨旭
  Date: 2018/4/8
  Time: 13:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    pageContext.setAttribute("bspath", request.getContextPath());
    pageContext.setAttribute("user", request.getSession().getAttribute(FinalValue.CHATROOM_USER));
%>
<html>
    <head>
        <link rel="stylesheet" href="${bspath}/css/chatroom.css"/>
        <script type="text/javascript">
            var weburl = "ws://" + location.host + "${pageContext.request.contextPath}/chatServer";
            var ws = new WebSocket(weburl);
        </script>
    </head>
    <body>
        <!--聊天窗口、联系人窗口切换-->
        <div class="fun-list col-md-1 col-sm-1 col-xs-1" style="height: 100%;background-color: #e8e8e8;padding: 1px;    border-right: 1px solid #d4d4d4;">
            <!--显示本人头像部分-->
            <div class="row" style="margin-bottom: 20px;">
                <div class="user-img col-md-12" style="cursor: pointer;">
                    <img src="${bspath}/${user.imgurl}?v=201804013" alt="${username}"
                         class="img-circle img-responsive center-block">
                </div>
            </div>
            <div class="list-group">
                <a href="${bspath}/index" class="list-group-item list-group-item-success">
                    <span class="glyphicon glyphicon-user"></span>
                    <span>聊天</span>
                </a>
                <a href="${bspath}/userset" class="list-group-item list-group-item-success">
                    <span class="glyphicon glyphicon-cog"></span>
                    <span>设置</span>
                </a>
                <a href="${bspath}/help" class="list-group-item list-group-item-success">
                    <span class="glyphicon glyphicon-question-sign"></span>
                    <span>帮助</span>
                </a>
                <a href="${bspath}/about" class="list-group-item list-group-item-success">
                    <span class="glyphicon glyphicon-info-sign"></span>
                    <span>关于</span>
                </a>
                <a href="${bspath}/loginout" class="list-group-item list-group-item-danger">
                    <span class="glyphicon glyphicon-log-out"></span>
                    <span>注销</span>
                </a>
            </div>
        </div>
    </body>
</html>
