package com.chatroom.web.controller;


import com.chatroom.web.entity.Emoji;
import com.chatroom.web.entity.User;
import com.chatroom.web.services.ChatroomService;
import com.chatroom.web.util.*;
import com.drew.imaging.jpeg.JpegMetadataReader;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.exif.ExifDirectoryBase;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.List;
import java.util.UUID;

@Controller
public class ChatRoomController {

    private final static Logger log = Logger.getLogger(ChatRoomController.class);

    private final static String LOGIN_PARAM_ERROR ="登录参数错误！";
    private final static String LOGIN_ACCOUNT_ERROR ="用户账号不存在！";
    private final static String LOGIN_PASSWORD_ERROR ="用户密码不匹配！";
    private final static String UPDATE_SUCCESS ="保存成功！";



    @Autowired
    private ChatroomService chatroomService;

    public void setChatroomService(ChatroomService chatroomService) {
        this.chatroomService = chatroomService;
    }


    /**
     * 进入登录页面
     * @return
     */
    @RequestMapping(value = {"login"}, method = RequestMethod.GET)
    public String doLoginPage(){
        return "chatroom/login";
    }

    /**
     * 登录操作
     * @param request
     * @param attributes
     * @return
     */
    @RequestMapping(value = "/chatroom/login", method = RequestMethod.POST)
    public String loginUser(HttpServletRequest request, HttpServletResponse response, RedirectAttributes attributes,@RequestParam String account,
                            @RequestParam String password,  @RequestParam Boolean remeberMe){
        String error = "";
        account = Convert.toReadStr(account);
        password = Convert.toReadStr(password);
        if (account.isEmpty() || password.isEmpty()){
            attributes.addFlashAttribute("error", LOGIN_PARAM_ERROR);
            return "redirect:/login";
        }else{
            User user = chatroomService.findUserByAccount(account);
            if (user == null){
                attributes.addFlashAttribute("error",LOGIN_ACCOUNT_ERROR);
                return "redirect:/login";
            }else if (!password.equals(user.getPassword())){
                attributes.addFlashAttribute("error",LOGIN_PASSWORD_ERROR);
                return "redirect:/login";
            }else{
                HttpSession session = request.getSession();
                session.setAttribute(FinalValue.CHATROOM_LOGIN_USERID,user.getUserid());
                session.setAttribute(FinalValue.CHATROOM_USER, user);
                if (remeberMe){
                    int expreitime = 3 * 24 * 3600;
                    Cookie uidcookie = new Cookie(FinalValue.COOKIE_USERID, user.getUserid());
                    uidcookie.setMaxAge(expreitime);
                    uidcookie.setPath("/");
                    Cookie secretcookie = new Cookie(FinalValue.COOKIE_SECRET, MD5Util.getLowerCaseStringMD5(user.getUserid() + FinalValue.COOKIE_SECRET_VALUE));
                    secretcookie.setMaxAge(expreitime);
                    secretcookie.setPath("/");
                    response.addCookie(uidcookie);
                    response.addCookie(secretcookie);
                }
                return "redirect:/index";
            }
        }
    }

    /**
     * 用户注销登录
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "loginout")
    public String userLoginOut(HttpServletRequest request, HttpServletResponse response){
        request.getSession().removeAttribute(FinalValue.CHATROOM_USER);
        request.getSession().removeAttribute(FinalValue.CHATROOM_LOGIN_USERID);

        //让cookie失效
        Cookie[] cookies = request.getCookies();
        for (Cookie coo : cookies){
            if(coo.getName().equals(FinalValue.COOKIE_USERID) || coo.getName().equals(FinalValue.COOKIE_SECRET)){
                coo.setMaxAge(0);
                coo.setPath("/");
                response.addCookie(coo);
            }
        }

        return "redirect:/login";
    }

    /**
     * 进入聊天室
     * @return
     */
    @RequestMapping(value = {"index"})
    public String doChatRoom(HttpServletRequest request){
        HttpSession session = request.getSession();

        String userid = (String) session.getAttribute(FinalValue.CHATROOM_LOGIN_USERID);
        if (userid == null || userid.isEmpty()){
            return "redirect:/login";
        }
        User user = (User) session.getAttribute(FinalValue.CHATROOM_USER);
        if (user == null){
            user = chatroomService.findUserById(userid);
            session.setAttribute(FinalValue.CHATROOM_USER, user);
        }

        return "chatroom/index";
    }

    /**
     * 保存用户基础信息
     * @param request
     * @param attributes
     * @param username
     * @param sex
     * @param remark
     * @param oldyear
     * @return
     */
    @RequestMapping(value = "chatroom/infosave",method = RequestMethod.POST)
    public String infoUpdate(HttpServletRequest request, RedirectAttributes attributes, @RequestParam(name = "username") String username, @RequestParam String sex, @RequestParam String remark, @RequestParam String oldyear){
        HttpSession session = request.getSession();
        if (username.length()<2){
            attributes.addFlashAttribute("message","用户名不得少于两个字符！");
            return "redirect:/userset";
        }
        User user = (User) session.getAttribute(FinalValue.CHATROOM_USER);
        user.setUsername(username);
        user.setOldyear(oldyear);
        user.setRemark(remark);
        user.setSex(sex);
        chatroomService.updateUserInfo(user);
        attributes.addFlashAttribute("message",UPDATE_SUCCESS);

        return "redirect:/userset";
    }

    /**
     * 修改用户密码
     * @param request
     * @return
     */
    @RequestMapping(value = "chatroom/editpwd", method = RequestMethod.POST)
    public String pwdUpdate(HttpServletRequest request,RedirectAttributes attribute, @RequestParam String oldpwd, @RequestParam String newpwd){
        User user = (User) request.getSession().getAttribute(FinalValue.CHATROOM_USER);
        if (oldpwd.equals(user.getPassword())){
            user.setPassword(newpwd);
            chatroomService.updateUserPwd(user);
            attribute.addFlashAttribute("message","修改成功！");
        }else{
            attribute.addFlashAttribute("message","修改失败，原密码不正确！");
        }

        return "redirect:/userset";
    }

    /**
     * 用户上传头像，根据x,y,width,height裁剪图片 比例为1:1
     * @param request
     * @param attributes    重定向属性
     * @param file          文件
     * @param datailX       坐标x
     * @param datailY       坐标y
     * @param datailWidth   图片裁剪宽度
     * @param datailHeight  图片裁剪高度
     * @return
     */
    @RequestMapping(value = "chatroom/uploadhead", method = RequestMethod.POST)
    public String headImageUpload(HttpServletRequest request, RedirectAttributes attributes, @RequestParam("head-img") MultipartFile file,
                                  @RequestParam int datailX, @RequestParam int datailY, @RequestParam int datailWidth, @RequestParam int datailHeight) {
        User user = (User) request.getSession().getAttribute(FinalValue.CHATROOM_USER);

        if (!file.isEmpty()) {
            try {
                String filename = file.getOriginalFilename();
                String type = filename.substring(filename.lastIndexOf("."), filename.length());

                String path = "images/user/" + user.getUserid() + "-head-" + UUID.randomUUID().toString().replaceAll("-", "") + type;
                String localPath = request.getSession().getServletContext().getRealPath("/");
                String tagerpath = localPath + path;
                log.info("头像保存路径：" + tagerpath);

                Long btime = System.currentTimeMillis();
                //将文件写入到服务器目录
                FileUtil.writeFileTOLocal(tagerpath, file.getBytes());
                System.out.println("写入文件耗时：" + (System.currentTimeMillis() - btime));
                btime = System.currentTimeMillis();
                //旋转图片，由于摄像头拍摄的图片包含EXIF信息，防止预览效果跟保存效果不一致，要做旋转处理
                Metadata metadata = JpegMetadataReader.readMetadata(new File(tagerpath));
                Directory directory = metadata.getFirstDirectoryOfType(ExifDirectoryBase.class);
                int orientation = 0;
                if (directory != null && directory.containsTag(ExifDirectoryBase.TAG_ORIENTATION)) { // Exif信息中有保存方向,把信息复制到缩略图
                    orientation = directory.getInt(ExifDirectoryBase.TAG_ORIENTATION); // 原图片的方向信息
                }
                if (orientation == 1) {
                    ImageCompressUtil.RotateImage(tagerpath, 0, tagerpath);
                } else if (6 == orientation) {
                    ImageCompressUtil.RotateImage(tagerpath, 90, tagerpath);
                } else if (3 == orientation) {
                    ImageCompressUtil.RotateImage(tagerpath, 180, tagerpath);
                } else if (8 == orientation) {
                    ImageCompressUtil.RotateImage(tagerpath, 270, tagerpath);
                }
                System.out.println("旋转图片耗时：" + (System.currentTimeMillis() - btime));
                btime = System.currentTimeMillis();
                //裁剪头像图片
                log.info("裁剪图像：x:"+datailX +",y:"+datailY+",width:"+datailWidth+",height"+datailHeight+",");
                if (!ImageCompressUtil.cutPic(tagerpath, tagerpath, datailX, datailY, datailWidth, datailHeight)){
                    throw new Exception("图片裁剪异常！");
                }
                System.out.println("裁剪图片耗时：" + (System.currentTimeMillis() - btime));
                user.setImgurl(path);
                chatroomService.updateUserInfo(user);
                attributes.addFlashAttribute("message", "保存成功！");
            } catch (Exception e) {
                e.printStackTrace();
                attributes.addFlashAttribute("message", "头像更新失败！");
            }
        }
        return "redirect:/userset";
    }

    /**
     * 获取特定类型的Emoji信息，unicode码
     * @param request
     * @return
     */
    @RequestMapping(value = "chatroom/getEmoji", method = RequestMethod.POST)
    @ResponseBody
    public String getEmoji(HttpServletRequest request,@RequestParam String type){
        BizResult bizResult = new BizResult();

        if (type!=null && !type.isEmpty()){
            List<Emoji> emojiList =  chatroomService.findEmojiByType(type);
            bizResult.setCode("0");
            bizResult.setObject(emojiList);
        }else{
            bizResult.setObject("1");
            bizResult.setMessage("类型参数获取为空的。");
        }

        return JSONObject.fromObject(bizResult).toString();
    }

    /**
     * 进入用户设置页面
     * @return
     */
    @RequestMapping(value = "userset", method = RequestMethod.GET)
    public String doUserSet(@ModelAttribute("message")String message){
        return "chatroom/info-setting";
    }

    /**
     * 进入帮助页面
     * @return
     */
    @RequestMapping(value = "help", method = RequestMethod.GET)
    public String doHelpPage(){
        return "chatroom/help";
    }

    /**
     * 进入关于页面
     * @return
     */
    @RequestMapping(value = "about", method = RequestMethod.GET)
    public String doAboutPage(){
        return "chatroom/about";
    }
}
