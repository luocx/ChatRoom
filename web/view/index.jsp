<%--
  Created by IntelliJ IDEA.
  User: 罗晨旭
  Date: 2018/3/15
  Time: 16:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>主页</title>
    <jsp:include page="public/head.jsp"/>
</head>
<body>
<div class="jumbotron">
    <div class="container">
        <h1>close</h1>
        <p>该网站暂未开放，请稍候片刻。</p>
        <p><a class="jumpbut btn btn-primary btn-lg" href="<%=request.getContextPath()%>/chatroom" role="button">去聊会?</a></p>
    </div>
</div>
</body>
</html>
