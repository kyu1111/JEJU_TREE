package com.jejutree.plans_model;

import java.util.*;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserPlansImpl implements UserPlansDAO {

	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public int insertPlans(UserPlansDTO dto) {

		return this.sqlSession.insert("addplans", dto);

	}

	@Override
	public List<UserPlansDTO> getPlanList(String user_id) {
		
		return this.sqlSession.selectList("myplans", user_id);
	
	}

	/*
	 * @Override public int insertParticipants(Plan_participantsDTO dto) {
	 * 
	 * return this.sqlSession.insert("insertParticipant", dto); }
	 */

}
