package com.jejutree.search_model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SearchDTO {
	
	private int search_no;
	private String search_keyword;
	private String search_log;
}
