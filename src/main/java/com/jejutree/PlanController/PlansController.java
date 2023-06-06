package com.jejutree.PlanController;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.reflect.TypeToken;
import com.jejutree.plans_model.*;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
@Controller
public class PlansController {
   
    @Autowired
    private HttpSession session;
   
    @Inject
    private UserPlansDAO dao;
      
    @RequestMapping("plans_insert_ok.go")
    public void insertOk(UserPlansDTO dto, HttpServletResponse response,HttpSession session) throws IOException {
        String userId = "";
        if(session.getAttribute("user_id")!=null) {
        	userId = (String)session.getAttribute("user_id");
        }else if(session.getAttribute("Kakao_info")!=null) {
        	HashMap<String, Object> hashMap = (HashMap<String, Object>) session.getAttribute("Kakao_info"); 
        	userId = (String)hashMap.get("kakao_id");
            System.out.println(userId);
        }
        System.out.println(userId);
        dto.setUser_id(userId);
        
        int check = this.dao.insertPlans(dto);
        
        response.setContentType("text/html; charset=UTF-8");
        
        PrintWriter out = response.getWriter();
      
        if (check > 0) {
            out.println("<script>");
            out.println("alert('플랜 등록 성공!!!')");
            out.println("location.href='tmap.go'");
            out.println("</script>");
        } else {
            out.println("<script>");
            out.println("alert('플랜 등록 실패!!!')");
            out.println("history.back()");
            out.println("</script>");
        }
        out.close();
    }   
    
    @RequestMapping("plan_list.go")
    public String cont(@RequestParam("id") String user_id, Model model,@RequestParam(value="is_guest",required = false)String is_guest
    		) {
    	  
    		
	  // plan_list.go 페이지가 사용자가 본인의 열어 본 것인지, 공유된 페이지 인지 구별하는 keyword. is_guest
	  if(is_guest != null) {
	  
	  model.addAttribute("is_guest",is_guest);
	  model.addAttribute("share_id",user_id);
	  }
		 
      List<UserPlansDTO> list = this.dao.getPlanList(user_id);
      
      if (!list.isEmpty()) {
        UserPlansDTO startPlan = list.get(0);
        UserPlansDTO endPlan = list.get(list.size() - 1);
        model.addAttribute("startPlan", startPlan);
        model.addAttribute("endPlan", endPlan);
      }
      model.addAttribute("List", list);
      
      return "calendar/weekly";
    }
    @RequestMapping("planlistCheck.go")
    public void isplnalistCheck(@RequestParam("user_id") String user_id,HttpServletResponse response) throws IOException {
    	 
    	int result = 0;
    	
    	System.out.println(user_id);
    	
    	response.setContentType("text/html; charset=UTF-8");
		
    	PrintWriter out = response.getWriter();
    	
		List<UserPlansDTO> list = this.dao.getPlanList(user_id);
    	System.out.println(list);
    	if(list != null && !list.isEmpty()) {
    		result = 1;
    	 }else{
    		 result = -1;
    	 }
    	System.out.println(result);
    	out.print(result);
    }
    
    

    @RequestMapping(value = "updateEvent.go", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<Void> updateEvent(@RequestParam("id") String id, @RequestParam("start") String start,
          @RequestParam("end") String end) {
       // TODO: id, start, end를 이용하여 실제 일정을 업데이트하는 로직을 작성해야 합니다.
       UserPlansDTO dto = new UserPlansDTO();
       int planId = Integer.parseInt(id);

       dto.setId(planId);

       dto.setStart_date(start);

       dto.setEnd_date(end);

       int rowsUpdated = dao.updatePlan2(dto);
       
       System.out.println("출력이 된다면 여기까지는 일단 목록을 뽑아오는데 성공한 겁니다.");
       System.out.println("변경하는 플래너의 아이디   >>>>>>>>> " + id);
       System.out.println("변경 후의 플래너 시작 날짜 >>>>>>>>> " + start);
       System.out.println("변경 후의 플래너 종료 날짜 >>>>>>>>> " + end);

       if (rowsUpdated > 0) {
          // Plan update was successful.
          return new ResponseEntity<Void>(HttpStatus.OK);
       } else {
          // Plan update failed.
          return new ResponseEntity<Void>(HttpStatus.INTERNAL_SERVER_ERROR);
       }

    }
    
    
   /*
    * @InitBinder public void initBinder(WebDataBinder binder) { SimpleDateFormat
    * sdf = new SimpleDateFormat("yyyy-MM-dd");
    * binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true)); }
    */
    
    @RequestMapping("toggle_like.go")
	@ResponseBody
	public String toggleBm(BookmarkDTO bdto) {
		
		boolean checkBm = dao.checkBookmark(bdto);

		Integer re = -1;
		
		if (!checkBm) {
			re = dao.bmInsert(bdto);
		}
		System.out.println(re);

		return re.toString();
	}

	 @RequestMapping(value = "bm_list.go", produces = "application/json; charset=UTF-8")
	 @ResponseBody
	 public String BmList(HttpSession session, Model model, HttpServletResponse response) throws IOException { 
		 
		 String user_id = (String) session.getAttribute("user_id");
		 List<BookmarkDTO> blist = dao.bmList(user_id);
		 response.setCharacterEncoding("UTF-8");
		 

		 String str = "{\"list\":[";
		 
		 for(int i=0;i<blist.size();i++) {
			 BookmarkDTO d = blist.get(i);
			 str += "{\"user_id\": \""+d.getUser_id()
			 		+ "\" , \"location\": \""+d.getLocation()+"\"}";
			 if(i!=blist.size()-1) {
				 str += ",";
			 }
		 }
		 str += "]}";
		 
		 return str;
	 }

	@RequestMapping("bm_delete_ok.go")
	@ResponseBody
	public String bmDeleteOk(BookmarkDTO bdto, HttpSession session) {
		String user_id = (String) session.getAttribute("user_id");
		bdto.setUser_id(user_id);
		
		System.out.println(bdto);
		
		Integer check = this.dao.bmDelete(bdto);
		return check.toString();
	}
    
}