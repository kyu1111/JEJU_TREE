package com.jejutree.PlanController;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
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
	public void insertOk(UserPlansDTO dto, HttpServletResponse response) throws IOException {

		String userId = (String) session.getAttribute("user_id");
		dto.setUserId(userId);
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
	public String cont(@RequestParam("id") String user_id, Model model) {

		String userId = (String) session.getAttribute("user_id");
		List<UserPlansDTO> list = this.dao.getPlanList(userId);

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