package com.jejutree.search_model;

import java.util.List;


public interface SearchDAO {
	
	int insertSearch(SearchDTO dto);
	
	List<SearchDTO> getKeywordList(String id);
	
	int deleteKeyword(int no);
	
}