package com.jejutree.search_model;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

public interface SearchDAO {
	
	int insertSearch(SearchDTO dto);
	
	List<SearchDTO> getKeywordList();
	
	int deleteKeyword(int no);
	
	
}
