package com.chatroom.web.entity;

public class Emoji {
    private String id;
    private String info;
    private String type;
    private String unicode;
    private String bytechar;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUnicode() {
        return unicode;
    }

    public void setUnicode(String unicode) {
        this.unicode = unicode;
    }

    public String getBytechar() {
        return bytechar;
    }

    public void setBytechar(String bytechar) {
        this.bytechar = bytechar;
    }
}
