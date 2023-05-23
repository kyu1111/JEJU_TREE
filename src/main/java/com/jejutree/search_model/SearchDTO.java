package com.jejutree.search_model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SearchDTO {
	
	private int id;
	private String user_id;
	private String search_term;
	private String search_date;
	
}
