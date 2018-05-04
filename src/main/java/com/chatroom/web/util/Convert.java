package com.chatroom.web.util;

public class Convert {
    public static String toReadStr(Object obj) {
        if (obj == null) {
            return "";
        }
        return String.valueOf(obj).trim();
    }
}
