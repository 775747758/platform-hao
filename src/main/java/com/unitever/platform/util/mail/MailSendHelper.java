package com.unitever.platform.util.mail;

import java.util.Properties;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

import com.unitever.platform.core.spring.SpringContextHolder;

public class MailSendHelper {

	private static final Log log = LogFactory.getLog(MailSendHelper.class);

	public static void sendText(String subject, String content) {
		if (subject == null || content == null) {
			throw new RuntimeException("发送邮件参数异常subject:" + subject + " content:" + content);
		}
		JavaMailSenderImpl sender = new JavaMailSenderImpl();
		sender.setHost("smtp.163.com");
		//JavaMailSenderImpl sender = SpringContextHolder.getBeanOneOfType(JavaMailSenderImpl.class);
		sender.setUsername("dengwenjie789@163.com");
		sender.setPassword("88452387");
		
		//配置文件，用于实例化java.mail.session    
        Properties pro = System.getProperties();    
            
        //登录SMTP服务器,需要获得授权，网易163邮箱新近注册的邮箱均不能授权。    
        //测试 sohu 的邮箱可以获得授权    
//        pro.put("mail.smtp.auth","true");    
//        pro.put("mail.smtp.socketFactory.port", "25");    
//        pro.put("mail.smtp.socketFactory.fallback", "false");   
//		sender.setJavaMailProperties(pro); 
		SimpleMailMessage mail = new SimpleMailMessage();
		mail.setFrom(sender.getUsername());
		mail.setTo("775747758@qq.com");
		mail.setSubject(subject);
		mail.setText(content);
		sender.send(mail);
	}

	public static void sendHtml(String toMail, String subject, String content) {
		if (StringUtils.isBlank(toMail) || subject == null || content == null) {
			throw new RuntimeException("发送邮件参数异常：toMail：" + toMail + " subject:" + subject + " content:" + content);
		}
		JavaMailSenderImpl sender = SpringContextHolder.getBeanOneOfType(JavaMailSenderImpl.class);
		MimeMessage msg = sender.createMimeMessage();
		MimeMessageHelper helper;
		try {
			helper = new MimeMessageHelper(msg, true, "GB2312");
			helper.setFrom(sender.getUsername());
			helper.setTo(toMail);
			helper.setSubject(subject);
			helper.setText(content, true);
			sender.send(msg);
		} catch (MessagingException e) {
			e.printStackTrace();
			log.error("发送邮件失败", e);
			throw new MailSendException();
		}
	}

}
