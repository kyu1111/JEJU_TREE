package com.jejutree.searchController;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.jejutree.search_model.SearchDAO;
import com.jejutree.search_model.SearchDTO;

@Controller
public class searchController {
	
	@Autowired
	private SearchDAO dao;
	
	@RequestMapping("search_insertok.go")
	public void insertOk(SearchDTO dto,HttpServletResponse response) throws IOException
	{	
	int check = this.dao.insertSearch(dto);
	response.setContentType("text/html; charset=UTF-8");
	
	PrintWriter out = response.getWriter();
	
		if(check > 0) {
			out.println("<script>");
			out.println("alert('검색어 추가 성공!!!')");
			out.println("history.back()");
			out.println("</script>");
		}else {
			out.println("<script>");
			out.println("alert('검색어 추가 실패~~~')");
			out.println("history.back()");
			out.println("</script>");
		}
	}
	
	@RequestMapping(value = "recent_search_list.go")
	public String getRecentSearchList(HttpServletRequest request,Model model) {
	    List<SearchDTO> list = this.dao.getKeywordList();
	    model.addAttribute("List", list);
	    return "MainPage";
	}
	
}