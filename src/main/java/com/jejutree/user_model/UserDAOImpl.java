//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package com.jejutree.user_model;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserDAOImpl implements UserDAO {
    @Autowired
    private SqlSessionTemplate sqlSession;

    public UserDAOImpl() {
    }

    public int insertUser(UserDTO dto) {
        return this.sqlSession.insert("UserJoin", dto);
    }

    public List<UserDTO> getUserList() {
        return null;
    }

    public int deleteUser(int id) {
        return this.sqlSession.delete("Normaldelete", id);
    }

    public int updateSequence(int id) {
        return this.sqlSession.update("UpdateSequence", id);
    }

    public int deleteTemporaryUser(String user_email) {
        return this.sqlSession.delete("temporaryDelete", user_email);
    }

    public int deleteKakaoUser(String user_email) {
        return this.sqlSession.delete("KaKaoDelete", user_email);
    }

    public UserDTO getuser(String user_id) {
        return (UserDTO)this.sqlSession.selectOne("UserInfo", user_id);
    }

    public UserDTO getkakaouser(String user_email) {
        return (UserDTO)this.sqlSession.selectOne("iskakaouserinfo", user_email);
    }

    public int updateMember(UserDTO dto) {
        return this.sqlSession.update("updateMember", dto);
    }

    public String checkPwd(int id) {
        return (String)this.sqlSession.selectOne("checkPwd", id);
    }

    public UserDTO getuserById(int id) {
        return (UserDTO)this.sqlSession.selectOne("getuserById", id);
    }

    public int kakao_insert(String user_email) {
        return this.sqlSession.insert("kakao_insert", user_email);
    }

    public Temporary_kakao_userDTO kakao_userInfo(String user_email) {
        return (Temporary_kakao_userDTO)this.sqlSession.selectOne("kakaoUserInfo", user_email);
    }

    public int insertKakaoUser(UserDTO dto) {
        return this.sqlSession.insert("KaKaoJoin", dto);
    }

    public int updateKakao(String user_email) {
        return this.sqlSession.update("UpdateIskakao", user_email);
    }

    public int checkEmail(String email) {
        return (Integer)this.sqlSession.selectOne("checkEmail", email);
    }

    public int updateMailKey(UserDTO dto) throws Exception {
        return this.sqlSession.update("updateMailKey", dto);
    }

    public String emailCheck(int id) {
        return (String)this.sqlSession.selectOne("emailCheck", id);
    }

    public int updateMailAuth(UserDTO dto) throws Exception {
        return this.sqlSession.update("updateMailAuth", dto);
    }

    public int emailAuthFail(String id) throws Exception {
        return (Integer)this.sqlSession.selectOne("emailAuthFail", id);
    }

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
