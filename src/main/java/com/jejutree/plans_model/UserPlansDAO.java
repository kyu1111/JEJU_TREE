package com.jejutree.plans_model;

import com.jejutree.plans_model.*;

import java.util.List;

import com.jejutree.*;

public interface UserPlansDAO {
	
	List<UserPlansDTO> getPlanList(String userId);
	
	int insertPlans(UserPlansDTO dto);
	
}
