package com.jejutree.PlanDragFunctionController;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.jejutree.plans_model.UserPlansDAO;
import com.jejutree.plans_model.UserPlansDTO;
import com.jejutree.user_model.UserDAO;
import com.jejutree.user_model.UserDTO;

import org.springframework.http.ResponseEntity;

@Controller
public class PlanDragFunctionController {
	@Autowired
	private HttpSession session;
	@Inject
	private UserPlansDAO dao;
	@Inject
	private UserDAO userdao;

	@RequestMapping("drag_plan_list.go")
	public String cont(Model model) {
		String user_id = (String) session.getAttribute("user_id");
		List<UserPlansDTO> list = this.dao.getPlanList(user_id);
		if (!list.isEmpty()) {
			UserPlansDTO startPlan = list.get(0);
			UserPlansDTO endPlan = list.get(list.size() - 1);
			model.addAttribute("startPlan", startPlan);
			model.addAttribute("endPlan", endPlan);
		}
		model.addAttribute("List", list);
		
		return "dragplan/dragplan";
	}

	@RequestMapping("get_others_plans.go")
	public String getOthersPlans(@RequestParam("otherUserId") String otherUserId, Model model,@RequestParam(value="is_guest",required = false)String is_guest) {
		// Use the provided otherUserId to get the plans of the other user
		//게시판을 통해서 동행 신청과 동시에 드래그 플랜을 요청하는 경우
		if(is_guest != null) {
			model.addAttribute("is_guest",is_guest);
			model.addAttribute("otherUserId",otherUserId);
		}
		List<UserPlansDTO> otherUserList = this.dao.getPlanList(otherUserId);
		// Add the other user's plans to the model
		model.addAttribute("otherUserList", otherUserList);
		String user_id = (String) session.getAttribute("user_id");
		List<UserPlansDTO> list = this.dao.getPlanList(user_id);
		if (!list.isEmpty()) {
			UserPlansDTO startPlan = list.get(0);
			UserPlansDTO endPlan = list.get(list.size() - 1);
			model.addAttribute("startPlan", startPlan);
			model.addAttribute("endPlan", endPlan);
		}
		model.addAttribute("List", list);
		

		String KakaoInfo = (String) session.getAttribute("KakaoInfo");
	     String userId = (String) session.getAttribute("user_id");
	     UserDTO dto = new UserDTO();
		if (KakaoInfo != null || userId != null) {
			if(user_id != null) {
				dto.setUser_id(userId);
				dto = this.userdao.getuser(userId);
				
			} else if(KakaoInfo != null) {
				dto.setUser_id(KakaoInfo);
				dto = this.userdao.getuser(KakaoInfo);
			} 
		}
		System.out.println(userId);
		System.out.println(dto.getUser_id());
		System.out.println(dto.getUser_nickname());
		model.addAttribute("User", dto);
		
		return "dragplan/dragplan";
	}
	
	@RequestMapping(value="drag_update.go", method=RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<String> handleDragAndDrop(@RequestParam("planId") int planId, @RequestParam("userId") String userId) {
	    //int check = this.dao.insertPlans(dto);
		
		// Use the provided planId to get the specific plan
	    UserPlansDTO dto = this.dao.getPlanById(planId);
	    
	    // Update the user_id of the plan
	    dto.setUser_id(userId);
	    String shareId = dto.getUser_id();
	    System.out.println(shareId);
	    	
	    // Save the updated plan to the DB
	    this.dao.updatePlan(dto);

	    // Return a success message
	    return new ResponseEntity<String>("Plan updated successfully.", HttpStatus.OK);
	}
	
	@RequestMapping(value="drag_update_back.go", method=RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<String> handleDragAndDropBack(@RequestParam("planId") int planId, @RequestParam("userId") String userId) {
		// Use the provided planId to get the specific plan
		UserPlansDTO dto = this.dao.getPlanById(planId);
		    
		// Update the user_id of the plan back to original user
		dto.setUser_id(userId);
		String originalId = dto.getUser_id();
		System.out.println(originalId);
		    	
		// Save the updated plan back to the DB
		this.dao.updatePlan(dto);

		// Return a success message
		return new ResponseEntity<String>("Plan returned successfully.", HttpStatus.OK);
	}

	   @RequestMapping(value = "delete_plan.go", method = RequestMethod.POST)
	   @ResponseBody
	   public ResponseEntity<Void> deletePlan(@RequestParam("planId") int planId, @RequestParam("userId") String userId) {
	       // userId validation, if necessary
	       if (session.getAttribute("user_id") != null && !userId.equals(session.getAttribute("user_id"))) {
	           return new ResponseEntity<Void>(HttpStatus.UNAUTHORIZED);
	       }


	       int rowsDeleted = dao.deletePlan(planId);

	       if (rowsDeleted > 0) {
	           return new ResponseEntity<Void>(HttpStatus.OK);
	       } else {
	           return new ResponseEntity<Void>(HttpStatus.INTERNAL_SERVER_ERROR);
	       }
	   }
	
	
}