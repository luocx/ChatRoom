package com.chatroom.web.exception;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.ExceptionHandler;

//@ControllerAdvice
public class MyExceptionResolver {
    private final static Logger log = Logger.getLogger(MyExceptionResolver.class);

    @ExceptionHandler
    public String handleIOException(Exception ex) {
        // prepare responseEntity
        log.error("异常处理！",ex);
        return "error/500";
    }
}
