package entity;

import java.util.HashMap;
import java.util.Map;

/**
 * 对以json格式返回的对象进行的封装，是通用的返回类
 */
public class Message {
    //定义消息的状态码
    private int code;
    //提示信息
    private String message;

    //定义一个集合，用来存放服务器发送的数据
    private Map<String,Object> data = new HashMap<>();

    //定义静态的发送成功和失败方法
    public static Message success(){
        Message result = new Message();
        result.setCode(100);
        result.setMessage("发送成功");
        return result;
    }

    public static Message fail(){
        Message result = new Message();
        result.setCode(200);
        result.setMessage("发送失败");
        return result;
    }
    //添加数据到Map
    public Message add(String key,Object object){
        this.data.put(key,object);
        return this;
    }


    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Map<String, Object> getData() {
        return data;
    }

    public void setData(Map<String, Object> data) {
        this.data = data;
    }
}
