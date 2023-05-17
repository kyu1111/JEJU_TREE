package com.jejutree.user_Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jejutree.kakaoController.kakaoLoginService;
import com.jejutree.user_model.UserDAO;
import com.jejutree.user_model.UserDTO;
@Controller
public class userController {
	@Autowired
	private UserDAO dao;
	@Autowired
	private kakaoLoginService ks;
	
	@RequestMapping("user_join.go")
	public String go_user_join() {
		return "login/user_join";
	}
	@RequestMapping("/user_join_ok.do")
	public void user_join_ok(HttpServletResponse response,UserDTO dto ) throws IOException{
		
		int check = dao.insertUser(dto);
		
		response.setContentType("text/html; charset=UTF-8");
		
		PrintWriter out = response.getWriter();
		
		if(check > 0) {
			out.println("<script>");
			out.println("alert('회원가입이 완료 되었습니다.')");
			out.println("window.close()");
			out.println("location.href='MainPage.go'");
			out.println("</script>");
		}else {
			out.println("<script>");
			out.println("alert('가입 실패 유캔트 회원가입 실패~~~')");
			out.println("history.back()");
			out.println("</script>");
		}
		
	}
	 @RequestMapping(value="/logout")
	 	public String logout(HttpSession session,HttpServletResponse response) {
		HashMap<String, Object> hashMap = (HashMap<String, Object>) session.getAttribute("KakaoInfo"); 
        
		String access_Token = (String)hashMap.get("kakaoToken");
        
        if(access_Token != null && !"".equals(access_Token)){
            ks.kakaoLogout(access_Token);
            session.removeAttribute("KakaoInfo");
            session.invalidate();
            Cookie cookie = new Cookie("kakaoCookie", null);
            cookie.setMaxAge(0); // 쿠키 유효기간을 0으로 설정하여 즉시 만료시킴
            cookie.setPath("/"); // 쿠키의 경로 설정
            response.addCookie(cookie);
        }else{
            System.out.println("access_Token is null");
            //return "redirect:/";
        }
        //return "index";
        return "redirect:/";
    }
}
