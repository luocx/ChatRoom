package com.chatroom.web.util;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import java.io.IOException;

public class Encryptions {
	private static BASE64Encoder encoder = new BASE64Encoder();
	private static BASE64Decoder decoder = new BASE64Decoder();

	/**
 	 * 计算文件的base64为编码
 	 * @param b
 	 * @return
 	 */
    public static String byteBase64(byte[] b){
    	if(b!=null && b.length>0){
	    	String result = encoder.encode(b);
	    	//result = result.replaceAll("\r\n","");//去掉所有的换行
	    	return result;
    	}
    	return null;
    }
    /**
     * 将base64位图片转换为byte字节
     * @param base64
     * @return
     */
    public static byte[] Base64byte(String base64) throws IOException {

    		if(base64!=null && !"".equals(base64)){
    			base64 = base64.replaceAll(" ","\r\n");//去掉空格
    			//base64 = base64.replaceAll("\r\n","");//去掉里面所有的回车符好
    			return decoder.decodeBuffer(base64);
    		}

    	return null;
    }
    /**
     * 测试用
     * @param args
     */
 	public static void main(String[] args) {
    }
}
