package com.jejutree.user_model;

import com.jejutree.search_model.SearchDTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDTO {
	String user_id;
	String user_pwd;
	String user_email;
	String user_nickname;
	String is_admin;
	String user_image;
	String user_like_keyword;
	String user_phone;
}
