package com.chatroom.web.util;

import java.util.Map;

public class BizResult {
    private String code;
    private String message;
    private Map<String, Object> map;
    private Object object;
    private boolean success = false;

    public BizResult(){}
    public BizResult(boolean success, String message){
        super();
        this.success = success;
        this.message = message;
    }

    public boolean isSuccess(){
        return this.success;
    }

    public BizResult setSuccess(){
        this.success = true;
        return this;
    }

    public Object getObject() {
        return object;
    }

    public BizResult setObject(Object object) {
        this.object = object;
        return this;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Map<String, Object> getMap() {
        return map;
    }

    public BizResult setMap(Map<String, Object> map) {
        this.map = map;
        return this;
    }

    public static BizResult successful(){
        return new BizResult(true, "");
    }

    public static BizResult field(String message){
        return new BizResult(false, message);
    }
}
