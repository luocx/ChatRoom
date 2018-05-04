<%@ page import="com.chatroom.web.util.FinalValue" %><%--
  Created by IntelliJ IDEA.
  User: 罗晨旭
  Date: 2018/3/30
  Time: 14:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    pageContext.setAttribute("bspath", request.getContextPath());
    pageContext.setAttribute("user", request.getSession().getAttribute(FinalValue.CHATROOM_USER));
%>
<html>
<head>
    <title>ChatRoom</title>
    <jsp:include page="../public/head.jsp"/>
    <script type="text/javascript" src="${bspath}/js/sockjs.min.js"></script>
    <style>
        .emoji-table td:hover{
            background-color: white;
        }
        .emoji-table td{
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="container" style="background-color: #e8e8e8;">
    <div class="row">

        <jsp:include page="left-list.jsp"/>

        <!--窗口列表 动态-->
        <div class="window-list col-md-3 col-sm-3 col-xs-3"
             style="height: 100%;padding-left:0px;padding-right: 0px;border-right: 1px solid #e0e0e0;">
            <!--显示聊天列表-->

            <!--联系人列表-->
            <div class="list-group">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <div class="line-status">
                            <div style="width: 15px;height: 15px;background-color:#3ce03c;border-radius: 100%;float: left"></div>
                            <span>在线</span>
                        </div>
                    </div>
                </div>
                <div id="user-list-panel"></div>
            </div>
        </div>
        <!--内容页面-->
        <div class="content-page col-md-8 col-sm-8 col-xs-8" style="height: 100%;">
            <!--聊天面板-->
            <div class="chat-page">
                <div class="row">
                    <div class="chat-panel panel panel-default" style="height: 70%;overflow-y: scroll;">
                        <div class="panel-heading" style="position: absolute; width: 100%;z-index: 1;">
                            <h3 class="to-username panel-title">公共频道</h3>
                            <input id="to-userid" type="hidden"/>
                        </div>
                        <div class="panel-body" id="chat-body" style="margin-top: 30px;"></div>
                    </div>
                </div>
                <!--悬浮面板-->
                <div class="row">
                    <!--表情栏-->
                    <div class="col-md-12">
                        <div class="emoji-panl row" style="display:none;position: absolute;z-index: 1000;top: auto;width:50%;bottom: 100%;margin-bottom: 2px;font-size: 14px;background-clip: padding-box;border: 1px solid rgba(0,0,0,.15);border-radius: 4px;box-shadow: 0 6px 12px rgba(0,0,0,.175);">
                            <div class="col-md-12">
                                <div class="row">
                                    <ul class="nav nav-tabs">
                                        <li role="presentation" class="active"><a href="#">常用表情</a></li>
                                        <li role="presentation"><a href="#">符号</a></li>
                                        <li role="presentation"><a href="#">工具</a></li>
                                    </ul>
                                </div>
                                <div class="row .table-responsive" style="height: 200px;overflow-y: auto;">
                                    <table class="table emoji-table text-center" style="background: #f1f1f1;font-size: 20px;">
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--小工具栏-->
                <div class="row" style="border-bottom: 0;background-color: white">
                    <!--表情按钮-->
                    <div class="col-md-1">
                        <button type="button" class="emoji-btn btn btn-default" style="border:0;">
                            😁
                        </button>
                    </div>
                </div>

                <!--消息输入框-->
                <div class="row">
                    <textarea id="send-content" class="form-control" rows="3"
                              style="min-width: 100%;min-height: 10%;max-width: 100%;max-height: 10%"></textarea>
                </div>
                <!--按钮-->
                <div class="row text-right">
                    <div class="col-md-10">
                        <span>按下<kbd><kbd>Ctrl</kbd> + <kbd>Enter</kbd></kbd>换行</span>
                    </div>
                    <div class="col-md-2">
                        <button type="button" class="send-btn btn btn-info">发送</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        //初始化表情图标
        initEmoji();

        $("#send-content").on("keypress", function (e) {
            var ctrlKey = e.ctrlKey;

            if (e.keyCode == "13" && !ctrlKey) {
                e.preventDefault();
                $(".emoji-panl").hide();
                sendMessage();
            }else if (e.keyCode =="10" && ctrlKey){
                insertAtCursor(document.getElementById("send-content"),"\n");
            }
        })

        $(".send-btn").on("click", function (e) {
            $(".emoji-panl").hide();
            sendMessage();
        })

        $(".emoji-btn").on('click',function () {
            $(".emoji-panl").toggle('fast');
        })

        $("#send-content").on('click',function () {
            $(".emoji-panl").hide();
        })
        $(document).on('click','.emoji',function () {
            insterEmoji($(this).html());
        })
    });

    ws.onopen = function () {
        // Web Socket 已连接上，使用 send() 方法发送数据
        //ws.send("发送数据");
        //alert("数据发送中...");
    };

    ws.onmessage = function (evt) {
        parseOnMessage(evt.data);
        // alert("数据已接收...");
    };

    ws.onclose = function () {
        // 关闭 websocket
        //alert("连接已关闭...");
        downLine();
    };

    /**
     * 将发送消息封装为结构化数据
     *
     * message:{
     *          to:xx,
     *          from:xx,
     *          content:xxxx,
     *          time:xx
     *          },
     *  type : notice|message,
     *  userlist:[{
     *              img:xxx,
      *             username:xxxx,
      *             userid:xxx
      *          }]
     *
     */
    function getSendMessageText(content, touser, formuser) {
        return JSON.stringify(
            {
                message: {
                    to: touser,
                    from: formuser,
                    content: content,
                    time: new Date()
                },
                type: "message"
            }
        )
    };

    /**
     * 发送信息
     */
    function sendMessage() {

        var text = presSendMessageText($("#send-content").val());
        //console.log(text);
        var touser = $("#to-userid").val();
        var formuser = "${user.userid}";

        if (text == "") {
            $("#send-content").blur();
            $("#send-content").val("");
            return;
        }
        var message = getSendMessageText(text, touser, formuser);
        //console.log(message);

        ws.send(message);
        $("#send-content").val("");
        refushChatText(JSON.parse(message).message, "POST");
        cacheChatText(JSON.parse(message).message, "POST");
    };

    /**
     * 解析接收到的数据
     * @param data
     */
    function parseOnMessage(data) {
        var json = JSON.parse(data);
        if (json.type == "message") {
            //当前是否存在聊天窗口
            var nowChatUser = $("#to-userid");
            if (!nowChatUser.val()) {
                //nowChatUser.val(json.message.from);
                //$(".to-username").val();
            }
            //自己发送的消息不解析
            if (json.message.from == '${user.userid}'){
                return;
            }
            //两种情况下刷新聊天窗口
            // 一种是当前正在聊天的对象为消息发送者，并且消息不是发在公共频道时刷新
            // 二是在公共频道聊天，并且接收的消息也是发在公共频道时刷新
            if ((!nowChatUser.val() && !json.message.to) || (json.message.from == nowChatUser.val() && json.message.to =='${user.userid}')) {
                refushChatText(json.message, "GET")
            }
            cacheChatText(json.message, "GET");
        } else if (json.type == "notice") {
            //userarray = json.userlist;
            refushUserlist(json.userlist);
        }
    };

    /**
     * 缓存聊天记录
     * @param message
     * @param type
     */
    function cacheChatText(message, type) {
        if (message.to == "" || message.from == "") {
            return;
        }
        message.type = type;

        var contentIdx;
        var whitname;
        if (type == "GET") {
            contentIdx = "${user.userid}whit" + message.from;
            whitname = userobjs[message.from];
        } else if (type == "POST") {
            contentIdx = "${user.userid}whit" + message.to;
            whitname = userobjs[message.to];
        }
        if (localStorage[contentIdx]) {
            var messages = JSON.parse(localStorage[contentIdx]).messages;
            messages[messages.length] = message;
            localStorage[contentIdx] = "{\"messages\":" + JSON.stringify(messages) + "}";
        } else {
            localStorage[contentIdx] = "{\"messages\":[" + JSON.stringify(message) + "]}";
        }
    };

    /**
     * 离线
     **/
    function downLine() {
        $(".line-status").find("div").css("backgroundColor", "#bbbbbb");
        $(".line-status").find("span").text("离线");
    };

    /**
     * 刷新聊天窗口
     * @param chat
     */
    function refushChatWindow(chat) {
        var uname = $(chat).data("uname");
        var uid = $(chat).data("uid");

        $("#chat-body").html("");
        $(".to-username").html(uname);
        $("#to-userid").val(uid);

        //加载本地缓存的聊天记录
        if (localStorage["${user.userid}whit" + uid]) {
            var json = JSON.parse(localStorage["${user.userid}whit" + uid]);
            for (var index in json.messages) {
                refushChatText(json.messages[index], json.messages[index].type);
            }
        }
    };

    /**
     * 聊天消息刷新
     * @param message
     */
    function refushChatText(message, type) {
        if (type == "GET") {
            var urlimg = $(".user-img" + message.from).attr("src");
            if (!urlimg){
                urlimg = "${bspath}/images/timg.jpg";
            }
            $("#chat-body").append("<div class=\"get-row row\">" +
                "                                <div class=\"msg-row col-md-1 col-xs-2\">" +
                "                                    <img src=\"" + urlimg + "\" alt=\"" + message.from + "\"  class=\"img-rounded img-responsive center-block\"/>" +
                "                                </div>" +
                "                                <div class=\"col-md-11 col-xs-10\">" +
                "                                    <div class=\"row\"><span>" + userobjs[message.from] + "</span></div>" +
                "                                    <div class=\"row\"><p class=\"msg-row msg-text get-message text-left\">" + presGetMessageText(message.content) + "</p></div>" +
                "                                </div>" +
                "                            </div>");
        } else if (type == "POST") {
            var urlimg;
            if ('${user.imgurl}'){
                urlimg = "${bspath}/${user.imgurl}";
            }else{
                urlimg = "${bspath}/images/timg.jpg";
            }
            $("#chat-body").append("<div class=\"send-row row\">" +
                "                                    <div class=\"col-md-11 col-xs-10  text-right\">" +
                "                                       <div class=\"row\"><p class=\"msg-row msg-text send-message text-left \">" + presGetMessageText(message.content) + "</p></div>" +
                "                                    </div>" +
                "                                    <div class=\"msg-row col-md-1 col-xs-2\">" +
                "                                        <img src=\""+ urlimg +"\" alt=\"" + message.from + "\"  class=\"img-rounded img-responsive center-block\"/>" +
                "                                    </div>" +
                "                                </div>");
        }
        $(".chat-panel").scrollTop($("#chat-body").height());
    };

    /**
     * 对发送的信息预处理，对特殊字符转换
     * @Param text
     */
    function presSendMessageText(text) {
        text = text.replace(/[<]/g,'&lt;').replace(/[>]/g,'&gt;');
        text = text.replace(/[\r\n]/g,'<br>').trim();
        return text;
    };

    /**
     * 收到的信息进行处理，自动换行
     * @Param text
     */
    function presGetMessageText(text) {
        var linecout = 30;
        if (text.length / linecout >1){
            var count = parseInt(text.length / linecout);
            while (count > 0){
                if (text.substring(count*linecout, text.length).indexOf("<br>") == -1){
                    text = text.substring(0, count*linecout)+"<br>"+text.substring(count*linecout,text.length);
                }
                count--;
            }
        }
        return text;
    };

    /**
     * 用户列表刷新
     * @param userlist
     */
    var userobjs = new Object();

    function refushUserlist(userlist) {
        $("#user-list-panel").html("");
        //type 标识用户类型 特殊类型的用相关符号标识
        var addUser = function (username, userid, imgurl,type) {
            var type_class = "";
            if (type == "publicroom"){
                type_class = "glyphicon glyphicon-heart";
            }
            var userrow = " <a href=\"#\" class=\"list-group-item\" data-uname=\"" + username + "\" data-uid  =\"" + userid + "\" onclick='refushChatWindow(this);'>" +
                "                        <div class=\"row\">" +
                "                            <div class=\"col-md-3 col-xs-4\">" +
                "                                <img src=\"" + imgurl + "\" alt=\"\"  class=\"user-img" + userid + " img-rounded img-responsive center-block\"/>" +
                "                            </div>" +
                "                            <div class=\"col-md-9 col-xs-8\">" +
                "                                <h4>" + username + "<span class=\""+type_class+"\"></span></h4>" +
                "                            </div>" +
                "                        </div>" +
                "                    </a>";
            $("#user-list-panel").append(userrow);
        }
        //公共聊天频道
        addUser('公共频道','','','publicroom');
        for (var index in userlist) {
            var imgurl = userlist[index].imgurl;
            var username = userlist[index].username;
            var userid = userlist[index].userid;

            //存储id用户名映射对象
            userobjs[userid] = username;

            if ("${user.userid}" == userid) {
                username += "(我)";
            }
            if (imgurl) {
               imgurl = "${bspath}/" + imgurl;
            }else{
                imgurl = "${bspath}/images/user/timg.jpg?v=20180413";
            }
            addUser(username,userid,imgurl,'');
        }
    };

    /**
     * 初始化Emoji
     */
    function initEmoji() {
        var url = '${bspath}/chatroom/getEmoji';
        var data = {'type':'1'};
        $.ajaxSetup({cache: false});
        $.ajax({
            url: url,
            data: data,
            method: "POST",
            dataType: "JSON",
            traditional:true,
            success:
                function (data) {
                    if (data.code == "0") {
                        //console.log(data);
                        expreEmoji(data.object);
                    } else {
                        alert(data.message);
                    }
                },
            error:
                function (XMLHttpRequest, textStatus, errorThrown) {

                }
        })
    };

    /**
     *解析表情
     *
     */
    function expreEmoji(obj) {
        var emojiTableContentTemple = function (obj, colnum) {
            var tabcontent = '<tr>';
            for (var index in obj) {
                tabcontent += "<td><div class=\"emoji\">" + getEmojiUnicodeStr(obj[index].unicode) + "</div></td>";
                if (index != 0 && index % colnum == colnum-1) {
                    tabcontent += '</tr><tr>';
                }
            }
            tabcontent += '</tr>';
            return tabcontent;
        }
        var rownum = 10;
        var trhtml = emojiTableContentTemple(obj, rownum);
        $(".emoji-table").append(trhtml);
    };

    /**
     * 插入Emoji到输入框
     */
    function insterEmoji(em) {
        insertAtCursor(document.getElementById("send-content"),em);
    };
    /**
     * 工具方法，在文本框光标位置插入内容
     * @param myFiled
     * @param myValue
     */
    function insertAtCursor(myField, myValue) {

        //IE 浏览器
        if (document.selection) {
            myField.focus();
            sel = document.selection.createRange();
            sel.text = myValue;
            sel.select();
        }

        //FireFox、Chrome等
        else if (myField.selectionStart || myField.selectionStart == '0') {
            var startPos = myField.selectionStart;
            var endPos = myField.selectionEnd;

            // 保存滚动条
            var restoreTop = myField.scrollTop;
            myField.value = myField.value.substring(0, startPos) + myValue + myField.value.substring(endPos, myField.value.length);

            if (restoreTop > 0) {
                myField.scrollTop = restoreTop;
            }

            myField.focus();
            myField.selectionStart = startPos + myValue.length;
            myField.selectionEnd = startPos + myValue.length;
        } else {
            myField.value += myValue;
            myField.focus();
        }
    };

    /**
     * 工具方法 用unicode获取表情符号
     * @param unicode
     * @returns {string}
     */
    function getEmojiUnicodeStr(unicode) {
        var findSurrogatePair = function (point) {
            // assumes point > 0xffff
            var offset = point - 0x10000,
                lead = 0xd800 + (offset >> 10),
                trail = 0xdc00 + (offset & 0x3ff);
            return [lead.toString(16), trail.toString(16)];
        }
        var strArr = [];

        if (unicode.length == 6){
            strArr = new Array[unicode.replace('U+', '0x')];
        }else{
            strArr = findSurrogatePair(unicode.replace('U+', '0x'))
        }
        for (var s in strArr) {
            strArr[s] = "0x"+strArr[s];
        }
        return strArr.length == 2 ?String.fromCharCode(strArr[0],strArr[1]) : String.fromCharCode(strArr[0]);
    };
</script>
</body>
</html>
