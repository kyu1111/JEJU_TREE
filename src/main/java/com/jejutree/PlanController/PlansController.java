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
import org.springframework.http.MediaType;
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
    @RequestMapping(value = "planListUpdateOk.go", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> updatePlan(@RequestParam String data, @RequestParam String user_id) {
    	System.out.println(user_id);
    	//기존의 리스트 추출 해당 리스트의 차수 id 값이 필요함.
    	 if (user_id == null || user_id.isEmpty()) {
    	        // 유효하지 않은 user_id 처리
    	        Map<String, Object> result = new HashMap<String, Object>();
    	        result.put("result", false);
    	        return result;
    	    }
    	
    	
        List<UserPlansDTO> origin_list = this.dao.getPlanList(user_id);
        
        int origin_index = 0;
        
        Map<String, Object> result = new HashMap<String, Object>();
        int update_check = 0;
        try {
            System.out.println(String.valueOf(data));
            List<Map<String, Object>> updatePlans = new Gson().fromJson(String.valueOf(data),
                    new TypeToken<List<Map<String, Object>>>() {}.getType());
            System.out.println(":::::::::::::::::여기까지 됩니다:1::::::::::::::::::::");
            for (Map<String, Object> updatePlan : updatePlans) {
                int new_id = Integer.parseInt((String) updatePlan.get("id"));
                String title = (String) updatePlan.get("title");
                // "start" 값에서 날짜 및 시간 정보 추출
                Map<String, Object> start = (Map<String, Object>) updatePlan.get("start");
                Map<String, Object> startDateTime = (Map<String, Object>) start.get("d");
                String start_date = (String) startDateTime.get("d");

                // "end" 값에서 날짜 및 시간 정보 추출
                Map<String, Object> end = (Map<String, Object>) updatePlan.get("end");
                Map<String, Object> endDateTime = (Map<String, Object>) end.get("d");
                String end_date = (String) endDateTime.get("d");
                
                System.out.println("변수 저장은 됬습니다.");
                
                
                // 기존의 유저 아이디로 전체 리스트 뽑고 dto로 받아서 거기서 id만 추출, 받은 배열의 해당 번째에서 추출한 아이디에 해당하는 플랜의 정보를 기존의 유저 아이디 정보로 업데이트
                UserPlansDTO origin_dto = origin_list.get(origin_index);
                System.out.println("dto는 뽑힙니다." + origin_dto);
                // 업데이트할 row의 id where 조건
                int origin_id = origin_dto.getId();
                System.out.println(":::::::::::::::::여기까지 됩니다:1::::::::::::::::::::");
                // 받아온 새로운 순서로 등록될 플랜의 정보를 id로 조회해서 dto로 받기
                UserPlansDTO new_dto = this.dao.getPlandtobyId(new_id);
                System.out.println("dto는 뽑힙니다2." + new_dto);
                // 출력한 dto의 id만 origin_id로 변경해서 update 메서드의 parameter로 넣어주기
                new_dto.setId(origin_id);
                new_dto.setStart_date(start_date);
                new_dto.setEnd_date(end_date);
                System.out.println("dto가 바꼈나?." + new_dto);
                // 업데이트 메서드 진행
                update_check = dao.getUpdateplan(new_dto);
                
                // 기존 리스트 dto 출력을 위한 인덱스 
                origin_index += 1;
                System.out.println(":::::::::::::::::여기까지 됩니다2:::::::::::::::::::::");
            }
            if(update_check > 0) {
            	result.put("result", true);
            }else {
            	result.put("result", false);
            }
            System.out.println(":::::::::::::::::여기까지 됩니다3:::::::::::::::::::::");
        } catch (Exception e) {
            result.put("result", false);
        }

        return result; 
    }
   /*
    * @InitBinder public void initBinder(WebDataBinder binder) { SimpleDateFormat
    * sdf = new SimpleDateFormat("yyyy-MM-dd");
    * binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true)); }
    */
    
}