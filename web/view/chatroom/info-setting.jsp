<%@ page import="com.chatroom.web.util.FinalValue" %>
<%--
  Created by IntelliJ IDEA.
  User: 罗晨旭
  Date: 2018/4/8
  Time: 14:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("bspath", request.getContextPath());
    request.setAttribute("user", request.getSession().getAttribute(FinalValue.CHATROOM_USER));
%>
<html>
<head>
    <title>个人设置</title>
    <jsp:include page="../public/head.jsp"/>
    <link href="${bspath}/js/cropper/cropper.min.css" rel="stylesheet">
    <script src="${bspath}/js/cropper/cropper.min.js"></script>
</head>
<body>
<div class="container" style="background-color: #e8e8e8;">
    <div class="row">
        <jsp:include page="left-list.jsp"/>

        <div class="col-md-11 col-sm-11 col-xs-11">
            <div class="page-header">
                <h1>个人信息/info setting</h1>
            </div>
            <div class="set-head row" style="margin-bottom: 30px;">
                <div class="col-md-6 col-md-offset-3">
                    <ul class="nav nav-pills nav-justified">
                        <li role="presentation" class="user-info-nav active" data-infoclass="set-base-content"><a
                                href="#">基础信息</a></li>
                        <li role="presentation" class="user-info-nav" data-infoclass="set-head-content"><a
                                href="#">头像</a></li>
                        <li role="presentation" class="user-info-nav" data-infoclass="set-account-content"><a href="#">密码修改</a>
                        </li>
                    </ul>
                </div>
            </div>
            <!-- 基础信息 -->
            <div class="set-base-content row">
                <div class="col-md-6 col-md-offset-3">
                    <form class="form-horizontal" name="userInfoForm" action="${bspath}/chatroom/infosave"
                          method="post">
                        <div class="form-group">
                            <label for="inputUseraccount" class="col-sm-2 control-label">用户账号</label>
                            <div class="col-sm-10">
                                <input type="text" disabled class="form-control" id="inputUseraccount"
                                       placeholder="${user.useraccount}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputUsername" class="col-sm-2 control-label">昵称</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="inputUsername" name="username"
                                       placeholder="不少于两个字符" value="${user.username}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="selectSex" class="col-sm-2 control-label">性别</label>
                            <div class="col-sm-10">
                                <select class="form-control" id="selectSex" name="sex">
                                    <option name="man" value="1">男</option>
                                    <option name="woman" value="2">女</option>
                                    <option name="djjgirl" value="3">大屌萌妹</option>
                                    <option name="galigaygay" value="4">女装大佬</option>
                                    <option name="private" value="5">害羞,保密</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="user-oldyear" class="col-sm-2 control-label">年龄</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="user-oldyear" name="oldyear"
                                       placeholder="诚实的樵夫啊，你掉的是这把金斧头呢还是木斧头呢" value="${user.oldyear}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="user-remark" class="col-sm-2 control-label">个人说明</label>
                            <div class="col-sm-10">
                                <textarea id="user-remark" name="remark" class="form-control" rows="3"
                                          style="max-height: 10%;max-width: 100%;"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                <button type="button" class="save-btn btn btn-default">保存</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <!-- 头像信息-->
            <div class="set-head-content row" style="display: none">
                <div class="col-md-4 col-md-offset-4 text-center">
                    <form name="userHeadImgForm" action="${bspath}/chatroom/uploadhead" method="post"
                          enctype="multipart/form-data">
                        <div class="form-group">
                            <img src="${bspath}/${user.imgurl}" id="pre-head-img"
                                 class="<%--img-responsive--%> img-thumbnail center-block" alt="头像">
                            <input type="file" class="hide" id="head-img" name="head-img">
                            <input type="hidden" class="hide" id="datailX" name="datailX">
                            <input type="hidden" class="hide" id="datailY" name="datailY">
                            <input type="hidden" class="hide" id="datailWidth" name="datailWidth">
                            <input type="hidden" class="hide" id="datailHeight" name="datailHeight">
                        </div>
                        <div class="form-group">
                            <button type="button" class="select-img-btn btn btn-info btn-block"
                                    style="margin-top: 30px;">选择图片
                            </button>
                        </div>
                        <div class="form-group">
                            <button type="button" class="upload-btn btn btn-success btn-block">上传</button>
                        </div>
                    </form>
                </div>
            </div>
            <!-- 账号信息-->
            <div class="set-account-content row" style="display: none">
                <div class="col-md-6 col-md-offset-3">
                    <form class="form-horizontal" name="accountForm" action="${bspath}/chatroom/editpwd" method="post">
                        <div class="form-group">
                            <label for="old-pwd" class="col-sm-2 control-label">原密码</label>
                            <div class="col-sm-10">
                                <input type="password" class="form-control" id="old-pwd" name="oldpwd"
                                       placeholder="不少于6位">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="new-pwd" class="col-sm-2 control-label">新密码</label>
                            <div class="col-sm-10">
                                <input type="password" class="form-control" id="new-pwd" name="newpwd"
                                       placeholder="不少于6位">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="copy-new-pwd" class="col-sm-2 control-label">重复新密码</label>
                            <div class="col-sm-10">
                                <input type="password" class="form-control" id="copy-new-pwd" name="cnewpwd"
                                       placeholder="">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                <button type="button" class="edit-pwd-btn btn btn-default">修改</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- 消息提示 modal -->
<div id="messageModal" class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog"
     aria-labelledby="messageModal">
    <div class="modal-dialog modal-sm" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">提示</h4>
            </div>
            <div class="modal-body">

            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        initValue();

        $(".save-btn").on("click", function () {
            userInfoForm.submit();
        })

        $(".user-info-nav").on('click', function () {
            setPageContent(this);
        })

        $(".select-img-btn").on('click', function () {
            var fileInput = $("#head-img");
            fileInput.click();
        })

        $("#head-img").on('change', function () {
            previewImage(this);
        })
        $(".upload-btn").on('click', function () {
            uploadImage();
        })

        $(".edit-pwd-btn").on('click', function () {
            updateUserPwd();
        })
    });

    /**
     * 上传头像
     */
    function uploadImage() {
        var filein = $("#head-img")[0];
        if (filein.files.length > 0) {
            var file = filein.files[0];
            var type = file.type.split("/")[0];
            if (type == 'image') {
                var srcheight = $("#pre-head-img")[0].height;
                var srcwidth = $("#pre-head-img")[0].width;
                if (datailX<0 ){
                    datailX = 0;
                }
                if (datailY <0){
                    datailY = 0;
                }
                if (datailHeight > srcheight || datailWidth > srcwidth){
                    if (srcwidth > srcheight){
                        datailWidth = datailHeight = srcheight;
                    }else{
                        datailWidth = datailHeight = srcwidth;
                    }
                }
                $("#datailX").val(parseInt(datailX));
                $("#datailY").val(parseInt(datailY));
                $("#datailWidth").val(parseInt(datailWidth));
                $("#datailHeight").val(parseInt(datailHeight));
                userHeadImgForm.submit();
            }
        } else {
            //showMessageModel("")
        }
    }

    /**
     * 预览图片
     * @Param thiss
     */
    function previewImage(thiss) {
        var filein = $(thiss)[0];
        if (filein.files.length > 0) {
            var file = filein.files[0];
            var type = file.type.split("/")[0];
            var name = file.name;
            if (type == 'image') {
                var fileReader = new FileReader();
                fileReader.onload = function () {
                    var src = fileReader.result;
                    $("#pre-head-img").attr("src", src);
                    showCropperPlug();
                };
                fileReader.readAsDataURL(file);
            } else {
                var msg = "= =，哎呀选错了，不是图片文件！";
                showMessageModel(msg);
            }
        }
    }

    /**
     * 标签页内容切换
     * @param thiss
     */
    function setPageContent(thiss) {
        $(".user-info-nav").each(function (index) {
            $(this).removeClass("active");
            $("." + $(this).data("infoclass")).hide("fast");
            //console.log("hide:"+$(this).data("infoclass"));
        });
        $(thiss).addClass("active");
        $("." + $(thiss).data("infoclass")).show("fast");
        //console.log("show:"+$(thiss).data("infoclass"));
    }

    /**
     *
     * 初始化资料
     */
    function initValue() {
        setPageContent($(".user-info-nav").first());

        if ('${user.sex}' == '1') {
            $("#selectSex").find("[name='man']")[0].selected = true;
        } else if ('${user.sex}' == '2') {
            $("#selectSex").find("[name='woman']")[0].selected = true;
        } else if ('${user.sex}' == '3') {
            $("#selectSex").find("[name='djjgirl']")[0].selected = true;
        } else if ('${user.sex}' == '4') {
            $("#selectSex").find("[name='galigaygay']")[0].selected = true;
        } else if ('${user.sex}' == '5') {
            $("#selectSex").find("[name='private']")[0].selected = true;
        }

        $("#user-remark").val('${user.remark}');
        if ('${message}') {
            showMessageModel('${message}');
        }
    }

    /**
     * 弹出模态框 显示提示信息
     * @param message
     */
    function showMessageModel(message) {
        $("#messageModal").find(".modal-body").html("<p>" + message + "</p>");
        $("#messageModal").modal('show');
    }

    /**
     * 显示图片裁剪插件
     */
    var datailX;
    var datailY;
    var datailWidth;
    var datailHeight;
    var cropper;
    function showCropperPlug() {
        var image = document.getElementById('pre-head-img');

        if (!cropper){
            cropper = new Cropper(image, {
                aspectRatio: 1 / 1,
                VIEWMODE: 1,
                //checkOrientation:false,
                crop: function (event) {
                    datailX = event.detail.x;
                    datailY = event.detail.y;
                    datailWidth = event.detail.width;
                    datailHeight = event.detail.height;
                    console.log("x:"+event.detail.x);
                    console.log("y:"+event.detail.y);
                    console.log("width:"+event.detail.width);
                    console.log("height:"+event.detail.height);
                    console.log("rotate:"+event.detail.rotate);
                    console.log("scaleX:"+event.detail.scaleX);
                    console.log("scaleY:"+event.detail.scaleY);
                }
            });
        }else{
            cropper.replace(image.getAttribute("src"));
        }
    }

    /**
     * 更新密码
     */
    function updateUserPwd() {
        var oldpwd = $("#old-pwd").val();
        var newpwd = $("#new-pwd").val();
        var cppwd = $("#copy-new-pwd").val();
        if (!oldpwd || !newpwd || !cppwd) {
            showMessageModel("麻烦您核对下是否输入完全!")
            return;
        } else if (oldpwd.length < 6 || newpwd.length < 6 || cppwd.length < 6) {
            showMessageModel("至少需要输入六位!");
            return;
        }else if(newpwd!=cppwd){
            showMessageModel("新密码两次输入不一致！");
            return;
        }
        accountForm.submit();
    }
</script>
</body>
</html>
