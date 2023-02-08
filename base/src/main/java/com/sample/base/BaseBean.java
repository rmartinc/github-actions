package com.sample.base;

/**
 *
 * @author rmartinc
 */
public class BaseBean {

    private String message;

    public BaseBean() {
        this.message = null;
    }

    public BaseBean(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
