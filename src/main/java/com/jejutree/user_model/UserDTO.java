package com.jejutree.user_model;

import com.jejutree.search_model.SearchDTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDTO {
	private String user_id;
	private String user_pwd;
	private String user_email;
	private String user_nickname;
	private String is_admin;
	private String user_image;
	private String user_like_keyword;
	private String user_phone;
	private int user_iskakao;
	private String mailKey;
	private int mailAuth;
	private int id;
}
