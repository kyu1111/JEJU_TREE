package com.jejutree.user_model;

import java.util.List;



public interface UserDAO {
	/* 일반회원관련 기능 */
		
		//일반 회원 가입
		int insertUser(UserDTO dto);
		
		//개인정보 수정
		int updateKakao(String user_email);
		
		List<UserDTO> getUserList();
		
		//일반회원 테이블만 삭제
		int deleteUser(int id);
		//삭제 이후 시퀀스 정렬 작업 해주는 메서드. 해당 id큰 row들의 id -1 씩 감소.
		int updateSequence(int id);
		
		//카카오 연동 회원일 시 임시 회원 테이블도 삭제
		int deleteTemporaryUser(String user_email);
		
		//카카오 세션 로그인시 탈퇴요청에 사용하는 메서드.
		int deleteKakaoUser(String user_email);
		
		//로그인시 정보 조회
		UserDTO getuser(String user_id);
		
		//카카오 이메일을 보유한 정회원의 여부를 조회하는 메서드
		UserDTO getkakaouser(String user_email);
		
		//유저 시퀀스 번호로 정보 조회
		UserDTO getuserById(int id);
		
		// 회원 수정 메서드
		int updateMember(UserDTO dto);
		
		// 회원 수정 시 비밀번호 일치 확인 메서드
		String checkPwd(int id);
		
	/* 카카오 기능 */
	
		//카카오회원가입
		int insertKakaoUser(UserDTO dto);
		
		//카카오 로그인시 이메일 정보와 iskakao항목만 임시 기록
		int kakao_insert(String user_email);
		
		//temporary 테이블에 있는 유저 정보 조회 
		Temporary_kakao_userDTO kakao_userInfo(String user_email);
	
		
	/* 이메일 기능 */
		 
		
		 // 이메일 중복 체크 처리
		 int checkEmail(String email);
		 
		 // 회원가입 시 이메일 인증을 위한 랜덤번호 저장
		 int updateMailKey(UserDTO dto) throws Exception;
		 
		 // 회원 수정 시 이메일 인증용 이메일 확인 메서드
		 String emailCheck(int id);
		 
		 // 메일 인증을 하면 mail_auth 컬럼을 기본값 0에서 1로 바꿔 로그인을 허용
		 int updateMailAuth(UserDTO dto) throws Exception;
		   
		 // 이메일 인증을 안 했으면 0을 반환, 로그인 시 인증했나 안 했나 체크하기 위함
		 int emailAuthFail(String id) throws Exception;
		 //
		 int updateMail(UserDTO userDTO);
}