package com.jejutree.Login;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.jejutree.user_model.UserDAO;
import com.jejutree.user_model.UserDTO;

@Service
public class JoinEmailServiceImpl implements JoinEmailService {
	
	@Autowired
	private UserDAO userDAO;
	
	@Autowired
	JavaMailSender MailSender;

	@Override
	public int updateMailKey(UserDTO userDTO) throws Exception {
		return userDAO.updateMailKey(userDTO);
	}

	@Override
	public int updateMailAuth(UserDTO userDTO) throws Exception {
		return userDAO.updateMailAuth(userDTO);
	}

	@Override
	public int emailAuthFail(String id) throws Exception {
		return userDAO.emailAuthFail(id);
	}

	@Override
	public int insertUser(UserDTO userDTO) throws Exception {
		//랜덤 문자열을 생성해서 mail_key 컬럼에 넣어주기
        String mail_key = new TempKey().getKey(30,false); //랜덤키 길이 설정
        userDTO.setMailKey(mail_key);
        //회원가입
        userDAO.insertUser(userDTO);
        userDAO.updateMailKey(userDTO);

        //회원가입 완료하면 인증을 위한 이메일 발송
        MailHandller sendMail = new MailHandller(MailSender);
        sendMail.setSubject("[제주트리 인증메일 입니다.]"); //메일제목
        sendMail.setText(
                "<h1>제주트리 메일인증</h1>" +
                "<br>제주트리에 오신것을 환영합니다!" +
                "<br>아래 [이메일 인증 확인]을 눌러주세요." +
                "<br><a href='http://localhost:8585/model/registerEmail.go?user_email=" + userDTO.getUser_email() +
                "&mailKey=" + mail_key +
                "' target='_blank'>이메일 인증 확인</a>");
        sendMail.setFrom("jejutree1234@gmail.com", "제주트리");
        sendMail.setTo(userDTO.getUser_email());
        sendMail.send();
		return 1;
		
	}
	
	
	@Override
	public String CheckEmail(UserDTO userDTO) throws Exception {
		//랜덤 문자열을 생성해서 mail_key 컬럼에 넣어주기
        String mail_key = new TempKey().getKey(30,false); //랜덤키 길이 설정
        userDTO.setMailKey(mail_key);

        //회원수정
        
        userDAO.updateMailKey(userDTO);

        //회원가입 완료하면 인증을 위한 이메일 발송
        MailHandller sendMail = new MailHandller(MailSender);
        sendMail.setSubject("[제주트리 인증메일 입니다.]"); //메일제목
        sendMail.setText(
                "<h1>제주트리 메일인증</h1>" +
                "<br>제주트리 이메일 변경 인증메일" +
                "<br>아래 인증번호를 화면의 인증 폼에 입력해 주세요." +
                "<br> "+mail_key+" ");
        sendMail.setFrom("jejutree1234@gmail.com", "제주트리");
        sendMail.setTo(userDTO.getUser_email());
        sendMail.send();
		return mail_key;
		
	}

	@Override
	public String emailChangeForm(UserDTO userDTO) throws Exception {
		//랜덤 문자열을 생성해서 mail_key 컬럼에 넣어주기
		System.out.println(userDTO.getId());
        String mail_key = new TempKey().getKey(30,false); //랜덤키 길이 설정
        userDTO.setMailKey(mail_key);

        //회원수정
        userDAO.updateMail(userDTO);

        //회원가입 완료하면 인증을 위한 이메일 발송
        MailHandller sendMail = new MailHandller(MailSender);
        sendMail.setSubject("[제주트리 메일변경 인증메일 입니다.]"); //메일제목
        sendMail.setText(
                "<h1>제주트리 메일 인증</h1>" +
                "<br>제주트리 이메일 변경 인증메일" +
                "<br>아래 인증번호를 화면의 인증 폼에 입력해 주세요." +
                "<br> "+mail_key+" ");
        sendMail.setFrom("jejutree1234@gmail.com", "제주트리");
        sendMail.setTo(userDTO.getUser_email());
        sendMail.send();
        
		return mail_key;
	}
	
	@Override
	public void id_search(UserDTO userDTO) throws Exception {
		//랜덤 문자열을 생성해서 mail_key 컬럼에 넣어주기
		System.out.println(userDTO.getId());
		String user_id = userDTO.getUser_id();
        String mail_key = new TempKey().getKey(30,false); //랜덤키 길이 설정
        userDTO.setMailKey(mail_key);


        //회원가입 완료하면 인증을 위한 이메일 발송
        MailHandller sendMail = new MailHandller(MailSender);
        sendMail.setSubject("[제주트리 메일변경 인증메일 입니다.]"); //메일제목
        sendMail.setText(
                "<h1>제주트리 아이디 찾기</h1>" +
                "<br>제주트리 이메일 찾기 인증메일" +
                "<br>아래 아이디로 로그인해 주세요." +
                "<br> "+user_id+" ");
        sendMail.setFrom("jejutree1234@gmail.com", "제주트리");
        sendMail.setTo(userDTO.getUser_email());
        sendMail.send();
	}
	
	@Override
	public String pwd_search(UserDTO userDTO) throws Exception {
		//랜덤 문자열을 생성해서 mail_key 컬럼에 넣어주기
		System.out.println(userDTO.getId());
        String temp_pwd = new TempKey().getKey(30,false); //랜덤키 길이 설정
        
        //회원가입 완료하면 인증을 위한 이메일 발송
        MailHandller sendMail = new MailHandller(MailSender);
        sendMail.setSubject("[제주트리 메일변경 인증메일 입니다.]"); //메일제목
        sendMail.setText(
                "<h1>제주트리 비밀번호 찾기 메일</h1>" +
                "<br>제주트리 비밀번호 변경 인증메일" +
                "<br>아래 임시 비밀번호로 로그인해 주세요." +
                "<br> "+temp_pwd+" ");
        sendMail.setFrom("jejutree1234@gmail.com", "제주트리");
        sendMail.setTo(userDTO.getUser_email());
        sendMail.send();
        
        return temp_pwd;
	}

}
