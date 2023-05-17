package com.jejutree.user_model;

import java.util.List;



public interface UserDAO {
	int insertUser(UserDTO dto);
	
	List<UserDTO> getUserList();
	
	int deleteUser(String user_id);
}
