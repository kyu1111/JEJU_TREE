package com.jejutree.Login;

import com.jejutree.user_model.UserDTO;

public interface JoinEmailService {
	
	int updateMailKey(UserDTO memberDto) throws Exception;

	int updateMailAuth(UserDTO memberDto) throws Exception;
	   
	int emailAuthFail(String id) throws Exception;
	//이메일 인증시 회원가입 데이터 등록 해주는 기능(실질적인 user_join)
	int insertUser(UserDTO userDTO) throws Exception;

	String CheckEmail(UserDTO userDTO) throws Exception;
	//이메일 변경시 새로운
	String emailChangeForm(UserDTO dto) throws Exception;

	void id_search(UserDTO userDTO) throws Exception;

	String pwd_search(UserDTO userDTO) throws Exception;
}
