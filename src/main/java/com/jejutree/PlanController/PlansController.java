package com.jejutree.PlanController;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jejutree.plans_model.*;
      
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
   
   /*
    * @InitBinder public void initBinder(WebDataBinder binder) { SimpleDateFormat
    * sdf = new SimpleDateFormat("yyyy-MM-dd");
    * binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true)); }
    */
    
}