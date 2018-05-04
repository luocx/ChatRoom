<%--
  Created by IntelliJ IDEA.
  User: 罗晨旭
  Date: 2018/4/8
  Time: 14:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>帮助</title>
    <jsp:include page="../public/head.jsp"/>
</head>
<body>
    <div class="container" style="background-color: #e8e8e8;">
        <div class="row">

            <jsp:include page="left-list.jsp"/>

            <div class="col-md-11 col-sm-11 col-xs-11">
                <div class="page-header">
                    <h1>帮助/Help</h1>
                </div>
                <div class="jumbotron">
                    <h1>求人不如求我</h1>
                    <p> <textarea id="question" class="form-control" rows="3" style="max-height: 10%;max-width: 100%;" placeholder="输入你想问的问题"></textarea></p>
                    <p><a class="btn btn-primary btn-lg" href="javascript:window.open('http://www.google.com/search?q='+$('#question').val())" role="button">点我解答</a></p>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
