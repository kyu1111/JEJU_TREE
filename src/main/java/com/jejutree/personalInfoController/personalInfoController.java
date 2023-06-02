package com.jejutree.personalInfoController;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class personalInfoController {
	
	@RequestMapping("personalInfoPage.go")
	public String personalInfo() {
		return "personalInfo/personalInfoPage";
	}
}
