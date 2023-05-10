package com.jejutree.kakaoController;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class kakaoLoginController {
@Autowired
private kakaoLoginService ks;
	@RequestMapping(value="login_page.go", method=RequestMethod.GET)
	public String login() {
		
		return "login/login";
	}
	@RequestMapping(value="login.go", method=RequestMethod.GET)
	public String kakaoLogin(@RequestParam(value = "code", required = false) String code,Model model ) throws Exception {
		System.out.println("#########" + code);
		// 여기 까진 나왔었음 return "testPage"; 
		String access_Token = ks.getAccessToken(code);
		//얘까진 된다.
		HashMap<String, Object> userInfo = ks.getUserInfo(access_Token);
		System.out.println("###access_Token#### : " + access_Token);
		System.out.println("###nickname#### : " + userInfo.get("nickname"));
		System.out.println("###email#### : " + userInfo.get("email"));
		model.addAttribute("KakaoInfo", userInfo);
		return "login/testPage";
		}
}

