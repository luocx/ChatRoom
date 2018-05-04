<%--
  Created by IntelliJ IDEA.
  User: 罗晨旭
  Date: 2018/4/8
  Time: 14:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    pageContext.setAttribute("bspath",request.getContextPath());
%>
<html>
<head>
    <title>关于</title>
    <jsp:include page="../public/head.jsp"/>
</head>
<body>
    <div class="container" style="background-color: #e8e8e8;">
        <div class="row">
            <jsp:include page="left-list.jsp"/>

            <div class="col-md-11 col-xs-11 col-sm-11" >
                <div class="page-header">
                    <h1>关于/About</h1>
                </div>
                <div class="row">
                    <div class="jumbotron">
                        <h1>技术栈</h1>
                        <p>后台采用当前较流行的ssm框架，Spring + SpringMVC + MyBatis</p>
                        <p>即时消息使用WebSocket基于Java EE 7</p>
                        <p>前端框架BootStrap3.0,Jquery</p>
                        <p>数据库MySQL</p>
                        <div class="row">
                            <div class="col-md-4">
                                <p><a href="https://spring.io/" target="_blank"><img src="${bspath}/images/about/spring.png" style="height: 80px"  class="img-thumbnail img-responsive center-block" alt="spring"></a></p>
                            </div>
                            <div class="col-md-4">
                                <p><a href="http://www.mybatis.org/mybatis-3/" target="_blank"><img src="${bspath}/images/about/mybatis.png" style="height: 80px" class="img-thumbnail img-responsive center-block" alt="mybatis"></a></p>
                            </div>
                            <div class="col-md-4">
                                <p><a href="https://jquery.com/" target="_blank"><img src="${bspath}/images/about/jquery.png" style="height: 80px" class="img-thumbnail img-responsive center-block" alt="jquery"></a></p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p><a href="http://www.bootcss.com/" target="_blank"><img src="${bspath}/images/about/bootstrap.png" style="height: 132px" class="img-thumbnail img-responsive center-block" alt="bootstrap"></a></p>
                            </div>
                            <div class="col-md-6">
                                <p><a href="https://www.mysql.com/cn/" target="_blank"><img src="${bspath}/images/about/mysql.png" style="height:132px" class="img-thumbnail img-responsive center-block" alt="mysql"></a></p>
                            </div>
                        </div>
                        <br>
                        <br>
                        <h1>源码</h1>
                        <p>GitHub :<a href="javascript:window.open('https://github.com/luocx/ChatRoom')">https://github.com/luocx/ChatRoom</a></p>
                        <br>
                        <br>
                        <h1>关于作者</h1>
                        <p>一个不断成长中的普普通通小码农。</p>
                        <p>博客：<a href="http://blog.cxluo.com" target="_blank">blog.cxluo.com (虽然没啥好看的)</a></p>
                        <p>WeChat: chenxu0033</p>
                        <%--<p><img src="${bspath}/images/wxcode.jpg" class="img-circle img-responsive center-block"></p>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
