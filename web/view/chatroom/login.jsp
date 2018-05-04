<%--
  Created by IntelliJ IDEA.
  User: 罗晨旭
  Date: 2018/3/20
  Time: 15:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    pageContext.setAttribute("bspath",request.getContextPath());
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>登录</title>
    <script src="${bspath}/js/md5.min.js"></script>
    <jsp:include page="../public/head.jsp"/>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".login-submit").on("click",function (e) {
                loginCheck();
            });
            $("#inputAccount,#inputPassword").on("keydown",function (e) {
                if (e.keyCode == "13"){
                    loginCheck();
                }
            })

            if ("${error}"){
                var $checkMsg = $(".checkMsg");
                $checkMsg.text("${error}");

                $checkMsg.addClass("alert-warning");
                $checkMsg.removeClass("alert-success");
                $checkMsg.removeClass("hide");
            }
        })

        //登录检查
        function loginCheck() {
            var $checkMsg = $(".checkMsg");
            var username = $("#inputAccount").val();
            var password = $("#inputPassword").val();
            var errmsg ;
            $checkMsg.addClass("hide");

            if(!username){
                errmsg = "请输入账号!";
            }else if(username.length < 2){
                errmsg = "请检查账号格式！";
            }else if(!password){
                //密码为空
                errmsg = "请输入密码！";
            }else if(password.length < 6 ){
                errmsg =  "密码长度不符合格式！";
            };
            if (errmsg){
                $checkMsg.text(errmsg);
                $checkMsg.removeClass("hide");
                return ;
            }else{
                $checkMsg.text("登录中~");
                $checkMsg.removeClass("hide alert-warning");
                $checkMsg.addClass("alert-success");
            }
            if ($("#rememberMeBox")[0].checked){
                $("#remeberMe").val(true);
            }else{
                $("#remeberMe").val(false);
            }
            var stamp_str = Math.random();
            var spassword = md5(md5(password).toLowerCase() + '' + stamp_str);

            var url = "${bspath}/chatroom/login";
            var data = {account: username, password: password, signkey: stamp_str};

            loginForm.action = url;
            loginForm.method = "POST";
            loginForm.submit();
            return;

            $.ajaxSetup({cache: false});
            $.ajax({
                url: url,
                data: data,
                method: "POST",
                dataType: "JSON",
                traditional:true,
                success:
                    function (data) {
                        //var data = eval("(" + data + ")");
                        if (data.code == "0") {
                           window.location.reload();
                        } else {
                            $("#inputAccount").val("");
                            $("#inputPassword").val("");
                            $checkMsg.text(data.message);

                            $checkMsg.addClass("alert-warning");
                            $checkMsg.removeClass("alert-success");
                            $checkMsg.removeClass("hide");
                        }
                    },
                error:
                    function (XMLHttpRequest, textStatus, errorThrown) {
                        $checkMsg.text(errorThrown);
                        $checkMsg.addClass("alert-warning");
                        $checkMsg.removeClass("alert-success");
                        $checkMsg.removeClass("hide");
                    }
            })
        }
    </script>
</head>
<body style="height: 100%;background-color: #f3f3f3;">
    <div class="container" style="margin-top: 150px;">
        <div class="row">
            <div class="col-md-12" style="margin-bottom: 40px;">
                <img class=" center-block" width="329px"  src="${bspath}/images/Msjin.gif">
            </div>
        </div>
        <div class="row">
            <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3" style="background-color: #fbfbfb;padding: 30px;">
                <form id="loginForm">
                    <div class="form-group">
                        <label for="inputAccount">账户名\邮箱</label>
                        <input type="text" class="form-control" name="account" id="inputAccount" placeholder="Email">
                    </div>
                    <div class="form-group">
                        <label for="inputPassword">密码</label>
                        <input type="password" class="form-control" name="password" id="inputPassword" placeholder="Password">
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" id="rememberMeBox"> 记住我的登录信息
                                    <input type="hidden" id="remeberMe" name="remeberMe" value="false">
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6 text-right">
                            <button type="button" class="login-submit btn btn-info">登录</button>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="checkMsg alert alert-warning alert-dismissible hide" role="alert"></div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
