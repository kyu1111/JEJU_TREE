package com.jejutree.termsController;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class termsController {
	
	@RequestMapping("termsPage.go")
	public String terms() {
		return "terms/termsPage";
	}
}
