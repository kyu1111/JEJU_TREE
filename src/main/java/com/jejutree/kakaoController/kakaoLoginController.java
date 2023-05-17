package com.jejutree.kakaoController;

import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.gson.JsonObject;

@Controller
public class kakaoLoginController {
@Autowired
private kakaoLoginService ks;
	@RequestMapping(value="login_page.go", method=RequestMethod.GET)
	public String login() {
		
		return "login/login";
	}
	@RequestMapping(value="kakaologin.go", method=RequestMethod.GET)
	public String kakaoLogin(@RequestParam(value = "code", required = false) String code,HttpSession session,HttpServletResponse response) throws Exception {
		System.out.println("#########" + code);
		String access_Token = ks.getAccessToken(code);
		HashMap<String, Object> userInfo = ks.getUserInfo(access_Token);
		//연결 테스트
		System.out.println("###access_Token#### : " + access_Token);
		System.out.println("###nickname#### : " + userInfo.get("nickname"));
		System.out.println("###email#### : " + userInfo.get("email"));
		//성공여부
		
		if(userInfo.get("email") != null) {
			
			session.setAttribute("KakaoInfo", userInfo);
		}else {
			System.out.println("오류");
		}
		
		return "MainPage";
		}
	@RequestMapping(value="share.go")
	public String goshare() {
		
		return "login/share";
	}
}

