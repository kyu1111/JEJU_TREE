package com.jejutree.CalendarController;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class WeeklyController {

	@RequestMapping(value = "/weekly_calendar.go", method = RequestMethod.POST)
	public String weekly(@RequestParam("title") String title, @RequestParam("address") String address, Model model) {
		model.addAttribute("title", title);
		model.addAttribute("address", address);
		return "calendar/weekly";
	}

}
