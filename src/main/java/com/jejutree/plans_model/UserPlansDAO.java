package com.jejutree.plans_model;

import com.jejutree.plans_model.*;

import java.util.HashMap;
import java.util.List;

import com.jejutree.*;

public interface UserPlansDAO {

	List<UserPlansDTO> getPlanList(String userId);

	int insertPlans(UserPlansDTO dto);

	UserPlansDTO getPlandto(String user_id);

	// 업데이트시 필요 한 row 추출 메서드
	int getUpdateplan(UserPlansDTO dto);

	UserPlansDTO getPlandtobyId(int id);

	UserPlansDTO getPlanById(int planId); // New method for fetching a plan by its ID

	int updatePlan(UserPlansDTO dto); // New method for updating a plan
	
	int bmInsert(BookmarkDTO bdto);
	
	int bmDelete(BookmarkDTO bdto);
	
	List<BookmarkDTO> bmList(String user_id);
	
	boolean checkBookmark(BookmarkDTO bdto);

}
