package com.jejutree.user_model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserDAOImpl implements UserDAO {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	/*일반 회원 기능*/
	
	//일반 회원가입시 사용하는 insert문
	@Override
	public int insertUser(UserDTO dto) {
		return this.sqlSession.insert("UserJoin",dto);
	}
	@Override
	public List<UserDTO> getUserList() {
		// TODO Auto-generated method stub
		return null;
	}
	//일반 유저 회원 탈퇴
	@Override
	public int deleteUser(int id) {
		return this.sqlSession.delete("Normaldelete", id);
	}
	//탈퇴 이후 시퀀스 정리 작업.
	@Override
	public int updateSequence(int id) {
		return this.sqlSession.update("UpdateSequence",id);
	}
	@Override
	public int deleteTemporaryUser(String user_email) {
		return this.sqlSession.delete("temporaryDelete",user_email);
	}
	//카카오 세션 로그인 유저가 회원 탈퇴 요청시 사용.
	@Override
	public int deleteKakaoUser(String user_email) {
		return this.sqlSession.delete("KaKaoDelete",user_email);
	}
	@Override
	public UserDTO getuser(String user_id) {
		return this.sqlSession.selectOne("UserInfo",user_id);
	}
	@Override
	//세션의 이메일과 일치 하는 일치하는 정회원 정보 조회
	public UserDTO getkakaouser(String user_email) {
		return this.sqlSession.selectOne("iskakaouserinfo",user_email);
	}
	@Override
	public int updateMember(UserDTO dto) {
		return this.sqlSession.update("updateMember", dto);
	}
	@Override
	public String checkPwd(int id) {
		return this.sqlSession.selectOne("checkPwd", id);
	}
	@Override
	public UserDTO getuserById(int id) {
		return this.sqlSession.selectOne("getuserById", id);
	}
	
	
	/*카카오 기능*/
	
	//최초 카카오 로그인시 임시 회원 정보 등록
	@Override
	public int kakao_insert(String user_email) {
		
		return this.sqlSession.insert("kakao_insert",user_email);
	}
	//카카오 임시로그인 정보 조회
	@Override
	public Temporary_kakao_userDTO kakao_userInfo(String user_email) {
		return this.sqlSession.selectOne("kakaoUserInfo", user_email);
	}
	@Override
	public int insertKakaoUser(UserDTO dto) {
		return this.sqlSession.insert("KaKaoJoin",dto);
	}
	@Override
	public int updateKakao(String user_email) {
		return this.sqlSession.update("UpdateIskakao", user_email);
	}
	
	
	/*이메일 기능*/
	@Override
	public int checkEmail(String email) {
		return this.sqlSession.selectOne("checkEmail", email);
	}
	
	
	@Override
	public int updateMailKey(UserDTO dto) throws Exception {
		return this.sqlSession.update("updateMailKey", dto);
	}
	

	@Override
	public String emailCheck(int id) {
		return this.sqlSession.selectOne("emailCheck", id);
	}
	
	@Override
	public int updateMailAuth(UserDTO dto) throws Exception {
		return this.sqlSession.update("updateMailAuth", dto);
	}
	
	
	
	@Override
	public int emailAuthFail(String id) throws Exception {
		return this.sqlSession.selectOne("emailAuthFail", id);
	}
	//이메일 변경시 새로운 이메일 정보
	@Override
	public int updateMail(UserDTO dto) {
		return this.sqlSession.update("updateMail", dto);
	}
	
	
}
