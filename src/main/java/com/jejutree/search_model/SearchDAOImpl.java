package com.jejutree.search_model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
@Repository
public class SearchDAOImpl implements SearchDAO{

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public int insertSearch(SearchDTO dto) {
		return this.sqlSession.insert("search_insert", dto);
	}

	@Override
	public List<SearchDTO> getKeywordList() {
		return sqlSession.selectList("getSearchList");
	}

	@Override
	public int deleteKeyword(int no) {
		// TODO Auto-generated method stub
		return 0;
	}

}
