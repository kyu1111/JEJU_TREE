package com.jejutree.kakaoController;

import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.gson.JsonObject;
import com.jejutree.user_model.Temporary_kakao_userDTO;
import com.jejutree.user_model.UserDAO;

@Controller
public class kakaoLoginController {
	@Autowired
	private kakaoLoginService ks;
	@Autowired
	private UserDAO dao;
	
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
		response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();  
		//카카오에서 불러와서 저장할 정보 저장해주기
		String user_email =(String)userInfo.get("email");
		String user_nickname = (String)userInfo.get("nickname");
		//카카오 요청에 성공해서 토큰으로 정보를 불러온 경우.
		if(user_email != null) {
	        //카카오에서 불러온 이메일 정보가 있는 dto가 있다면 바로 로그인 아니면 인서트 후 로그인 성공.
			Temporary_kakao_userDTO kakao_user = dao.kakao_userInfo(user_email);
			
			//카카오에서 정보를 불러왔지만  해당 정보가 임시 회원 가입테이블에 등록 되어 있지 않은 경우 임시 정보 삽입 후 로그인 세션 추가.
			if(kakao_user == null) {
				int check = dao.kakao_insert(user_email);
				
				if(check > 0) {
					HashMap<String, Object> hashMap = new HashMap<String,Object>();
					hashMap.put("kakao_id", user_email);
					hashMap.put("kakao_token", access_Token);
					hashMap.put("kakao_nickname", user_nickname);
					//정회원 가입 여부도 등록 해주기(이 값을 띄워서 mypage 띄울지 말지 결정)
					hashMap.put("user_join",kakao_user.getUser_join());
					session.setAttribute("Kakao_info", hashMap);
					return "MainPage";
				}else {
					out.println("<script>");
		            out.println("alert('카카오  회원정보를 다시한번 확인하세요')");
		            out.println("history.back()");
		            out.println("</script>");
				}
			//임시 회원으로 가입 되어 있는 경우 곧바로 로그인 처리.
			}else {
				HashMap<String, Object> hashMap = new HashMap<String,Object>();
				hashMap.put("kakao_id", user_email);
				hashMap.put("kakao_token", access_Token);
				hashMap.put("kakao_nickname", user_nickname);
				//정회원 가입 여부도 등록 해주기(이 값을 띄워서 mypage 띄울지 말지 결정)
				hashMap.put("user_join",kakao_user.getUser_join());
				session.setAttribute("Kakao_info", hashMap);
				return "MainPage";
			}
		//카카오 요청에 실패해서  토큰으로 정보를  못 불러온 경우.	
		}else {
			out.println("<script>");
            out.println("alert('카카오 정보를 불러오지 못했습니다.')");
            out.println("history.back()");
            out.println("</script>");
		}
		return null;
		}
	@RequestMapping(value ={"/share.go","/share2.go"})
	public String goshare(HttpServletRequest request) {
		
		if(request.getServletPath().equals("/share.go")){
			return "login/share";
		}else if(request.getServletPath().equals("/share2.go")){
			return "login/share2";
		}
		return "Main.go";
	}
}

