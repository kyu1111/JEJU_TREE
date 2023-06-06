package com.jejutree.GuideController;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class guideController {
	
	@RequestMapping("guidePage.go")
	public String guide() {
		return "guide/guidePage";
	}
	
}
