<%@ page import="org.springframework.web.bind.annotation.ExceptionHandler" %><%--
  Created by IntelliJ IDEA.
  User: 罗晨旭
  Date: 2018/3/23
  Time: 13:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>出错了</title>
    <jsp:include page="../public/head.jsp"/>
</head>
<body>
<h1>错误页面</h1>
<%
    Exception ex = (Exception)request.getAttribute("exception");
    out.print(ex.getMessage());
%>
</body>
</html>
