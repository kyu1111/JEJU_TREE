package com.jejutree.CalendarController;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WeeklyController {
	
	@RequestMapping("weekly_calendar.go")
	public String weekly() {
		return "weekly";
	}

}
