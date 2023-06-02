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

	@Override
	public UserPlansDTO getPlandto(String user_id) {
		return this.sqlSession.selectOne("getPlanDto", user_id);
	}

	// 업데이트 시 필요한 row 정보 출력
	@Override
	public int getUpdateplan(UserPlansDTO dto) {
		return this.sqlSession.update("getUpdateTarget", dto);
	}

	@Override
	public UserPlansDTO getPlandtobyId(int id) {
		return this.sqlSession.selectOne("getPlanDtobyId", id);
	}

	@Override
	public int updatePlan(UserPlansDTO dto) {

		return this.sqlSession.update("updatePlan", dto);

	}

	@Override
	public UserPlansDTO getPlanById(int planId) {

		return this.sqlSession.selectOne("getPlanById", planId);
	}

	/*
	 * @Override public int insertParticipants(Plan_participantsDTO dto) {
	 * 
	 * return this.sqlSession.insert("insertParticipant", dto); }
	 */
	
	@Override
	public List<BookmarkDTO> bmList(String user_id) {
		
		return sqlSession.selectList("bm_loc", user_id);
	}

	@Override
	public int bmInsert(BookmarkDTO bdto) {
		
		return sqlSession.insert("insertBm", bdto);
	}

	@Override
	public int bmDelete(BookmarkDTO bdto) {
		
		return sqlSession.delete("deleteBm", bdto);
	}

	@Override
	public boolean checkBookmark(BookmarkDTO bdto) {
		int count = sqlSession.selectOne("checkBm", bdto);
        return count > 0;
	}

}
