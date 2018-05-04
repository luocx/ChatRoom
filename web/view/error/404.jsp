<%--
  Created by IntelliJ IDEA.
  User: 罗晨旭
  Date: 2018/3/23
  Time: 11:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>404</title>
    <jsp:include page="../public/head.jsp"/>
    <script type="text/javascript">
        $(document).ready(function () {
            setInterval("timeout_jump()",1000);
        });
        var jumptime = 5;
        function timeout_jump() {
            if (jumptime-- >1){
                $(".jumptime-s").text(jumptime);
            }else {
                $(".jumpbut")[0].click();
            }
        }
    </script>
</head>
<body>
    <div class="jumbotron">
        <div class="container">
            <h1>404</h1>
            <p>您访问的页面消失了,请检查您的URI.</p>
            <p><a class="jumpbut btn btn-primary btn-lg" href="<%=request.getContextPath()%>" role="button">将跳转到首页(<span class="jumptime-s">5</span>)</a></p>
        </div>
    </div>
</body>
</html>
