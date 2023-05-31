package com.jejutree.plans_model;

import java.util.List;

public interface UserPlansDAO {
	
	List<UserPlansDTO> getPlanList(String userId);
	
	int insertPlans(UserPlansDTO dto);
	
	UserPlansDTO getPlanById(int planId); // New method for fetching a plan by its ID
	
	int updatePlan(UserPlansDTO dto); // New method for updating a plan
	
}
