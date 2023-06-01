//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package com.jejutree.user_model;

import java.util.HashMap;
import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.jejutree.plans_model.Plan_participantsDTO;

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
	//카카오 연동 회원가입.
	@Override
	public int insertKakaoUser(UserDTO dto) {
		return this.sqlSession.insert("KaKaoJoin",dto);
	}
	//카카오 회원 가입후 임시테이블의 join 여부 최신화.
	@Override
	public int updateKakao(String user_email) {
		return this.sqlSession.update("UpdateIskakao", user_email);
	}
	
	/*공유 관련 기능*/
	
	//여행 정보 공유 받은 회원이 동행자의 정보 입력.
	@Override
	public int insertParticipant(Plan_participantsDTO dto) {
		return this.sqlSession.insert("insertParticipant", dto);
	}
	//본인이 작성한 기록이 공유 받은 플랜으로 등록 되는것을 방지하는 중복 검사.
	@Override
	public int selfshareCheck(HashMap<String, String> paramMap) {
	    return this.sqlSession.selectOne("selfShareCheck", paramMap);
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
	
	public void updatePwd(UserDTO dto) {
        this.sqlSession.update("updatePwd", dto);
    }

    public UserDTO getUserByEmail(String user_email) {
        return (UserDTO)this.sqlSession.selectOne("getUserByEmail", user_email);
    }

    public UserDTO nickCheck(String user_nickname) {
        return (UserDTO)this.sqlSession.selectOne("nickCheck", user_nickname);
    }

    public UserDTO idCheck(String user_id) {
        return (UserDTO)this.sqlSession.selectOne("userId", user_id);
    }

    public void updatepwd(UserDTO dto) {
        this.sqlSession.update("updatepwd", dto);
    }
	
	
}
