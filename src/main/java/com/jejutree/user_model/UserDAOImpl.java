package com.jejutree.user_model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserDAOImpl implements UserDAO {
	
	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public int insertUser(UserDTO dto) {
		return this.sqlSession.insert("UserJoin",dto);
	}

	@Override
	public List<UserDTO> getUserList() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int deleteUser(String user_id) {
		// TODO Auto-generated method stub
		return 0;
	}
	
}
