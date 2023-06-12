package com.jejutree.kakaoController;

import java.io.PrintWriter;
import java.util.HashMap;

import javax.naming.PartialResultException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.gson.JsonObject;
import com.jejutree.plans_model.Plan_participantsDTO;
import com.jejutree.user_model.Temporary_kakao_userDTO;
import com.jejutree.user_model.UserDAO;

@Controller
public class kakaoLoginController {
	@Autowired
	private kakaoLoginService ks;
	@Autowired
	private UserDAO dao;

	@RequestMapping(value = "kakaologin.go", method = RequestMethod.GET)
	public String kakaoLogin(@RequestParam(value = "code", required = false) String code, HttpSession session,
			HttpServletResponse response) throws Exception {
		System.out.println("#########" + code);
		String expectedRedirectUri = "http://localhost:8585/model/kakaologin.go";
		String access_Token = ks.getAccessToken(code, expectedRedirectUri);
		HashMap<String, Object> userInfo = ks.getUserInfo(access_Token);
		// 연결 테스트
		System.out.println("###access_Token#### : " + access_Token);
		System.out.println("###nickname#### : " + userInfo.get("nickname"));
		System.out.println("###email#### : " + userInfo.get("email"));
		// 성공여부
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		// 카카오에서 불러와서 저장할 정보 저장해주기
		String user_email = (String) userInfo.get("email");
		String user_nickname = (String) userInfo.get("nickname");
		// 카카오 요청에 성공해서 토큰으로 정보를 불러온 경우.
		if (user_email != null) {
			// 카카오에서 불러온 이메일 정보가 있는 dto가 있다면 바로 로그인 아니면 인서트 후 로그인 성공.
			Temporary_kakao_userDTO kakao_user = dao.kakao_userInfo(user_email);

			// 카카오에서 정보를 불러왔지만 해당 정보가 임시 회원 가입테이블에 등록 되어 있지 않은 경우 임시 정보 삽입 후 로그인 세션 추가.
			if (kakao_user == null) {
				int check = dao.kakao_insert(user_email);

				if (check > 0) {
					HashMap<String, Object> hashMap = new HashMap<String, Object>();
					hashMap.put("kakao_id", user_email);
					hashMap.put("kakao_token", access_Token);
					hashMap.put("kakao_nickname", user_nickname);
					// 정회원 가입 여부도 등록 해주기(이 값을 띄워서 mypage 띄울지 말지 결정)
					// hashMap.put("user_join",kakao_user.getUser_join());
					session.setAttribute("Kakao_info", hashMap);
					return "MainPage";
				} else {
					out.println("<script>");
					out.println("alert('임시 카카오 로그인 실패.')");
					out.println("history.back()");
					out.println("</script>");
				}
				// 임시 회원으로 가입 되어 있는 경우 곧바로 로그인 처리.
			} else if (kakao_user != null) {
				HashMap<String, Object> hashMap = new HashMap<String, Object>();
				hashMap.put("kakao_id", user_email);
				hashMap.put("kakao_token", access_Token);
				hashMap.put("kakao_nickname", user_nickname);
				// 정회원 가입 여부도 등록 해주기(이 값을 띄워서 mypage 띄울지 말지 결정)
				hashMap.put("user_join", kakao_user.getUser_join());
				session.setAttribute("Kakao_info", hashMap);
				return "MainPage";
			} else if (kakao_user != null & kakao_user.getUser_join() == 1) {
				HashMap<String, Object> hashMap = new HashMap<String, Object>();
				hashMap.put("kakao_id", user_email);
				hashMap.put("kakao_token", access_Token);
				hashMap.put("kakao_nickname", user_nickname);
				// 정회원 가입 여부도 등록 해주기(이 값을 띄워서 mypage 띄울지 말지 결정)
				hashMap.put("user_join", kakao_user.getUser_join());
				session.setAttribute("Kakao_info", hashMap);
				return "MainPage";
			}
			// 카카오 요청에 실패해서 토큰으로 정보를 못 불러온 경우.
		} else {
			out.println("<script>");
			out.println("alert('카카오 정보를 불러오지 못했습니다.')");
			out.println("history.back()");
			out.println("</script>");
		}
		return null;
	}

	@RequestMapping("/share.go")
	public String goshare(HttpServletRequest request, @RequestParam("user_id") String user_id, Model model) {

		model.addAttribute("user_id", user_id);
		return "login/share";
	}

	// 공유 받은 회원이 유입되는 로그인 경로.
	@RequestMapping(value = "/invited_kakaologin.go", method = RequestMethod.GET)
	public String invited_kakaoLogin(@RequestParam(value = "code", required = false) String code,
			@RequestParam(value = "state", required = false) String share_id, HttpSession session,
			HttpServletResponse response, Model model) throws Exception {
		System.out.println(share_id);
		System.out.println("#########" + code);
		String expectedRedirectUri = "http://localhost:8585/model/invited_kakaologin.go";
		String access_Token = ks.getAccessToken(code, expectedRedirectUri);
		HashMap<String, Object> userInfo = ks.getUserInfo(access_Token);
		// 연결 테스트
		System.out.println("###access_Token#### : " + access_Token);
		System.out.println("###nickname#### : " + userInfo.get("nickname"));
		System.out.println("###email#### : " + userInfo.get("email"));
		// 성공여부
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		// 카카오에서 불러와서 저장할 정보 저장해주기
		String user_email = (String) userInfo.get("email");
		String user_nickname = (String) userInfo.get("nickname");
		// 카카오 요청에 성공해서 토큰으로 정보를 불러온 경우.
		if (user_email != null) {
			Temporary_kakao_userDTO kakao_user = dao.kakao_userInfo(user_email);
			//임시 회원 테이블에 이메일이 존재 하고, 카카오톡 연동 회원 가입도 되어있는 경우 바로 공유 정보 조회 가
			if (kakao_user != null && kakao_user.getUser_join() == 1) {
				HashMap<String, Object> hashMap = new HashMap<String, Object>();
				hashMap.put("kakao_id", user_email);
				hashMap.put("kakao_token", access_Token);
				hashMap.put("kakao_nickname", user_nickname);
				hashMap.put("user_join", kakao_user.getUser_join());
				session.setAttribute("Kakao_info", hashMap);
				//기본키 유효성 체크.
				 HashMap<String, String> paramMap = new HashMap<String, String>();
				 paramMap.put("user_id", user_email);
				 paramMap.put("user_share_id", share_id);
				int primary_check = this.dao.selfshareCheck(paramMap);
				System.out.println(primary_check);
				// 중복이 아니라면 동행자 정보 등록.(이미 있는 초대자와 참여자 가 존재 하고 ,초대자와 참여작 동일한 경우를 제외해야한다.)
				if (primary_check == 0 && !share_id.equals(kakao_user.getUser_email())) {
					Plan_participantsDTO Participantdto = new Plan_participantsDTO();
					Participantdto.setUser_id(user_email);
					// 여기에 invited 아이디 파라미터로 받아서 넣어야 할듯.
					Participantdto.setUser_share_id(share_id);
					// 공유된 플랜 정보 insert 해주기 (본인의 계정과 조회후 같지 않다면 share_id) 에 삽입 해준다.
					this.dao.insertParticipant(Participantdto);
				}
				out.println("<script>");
				out.println("if (confirm('공유된 일정을 다시 확인 하시겠습니까?')) {");
				out.println("  location.href='plan_list.go?id=" + share_id + "';");
				out.println("} else {");
				out.println("  alert('메인 페이지로 이동합니다.');");
				out.println("  location.href='MainPage.go';");
				out.println("}");
				out.println("</script>");
				// 카카오에서 불러온 이메일 정보가 있는 temporary_dto가 있지만,user_join 이 0인 경우. 공유서비스를 위한 추가 정보 제공
				// 회원가입 창으로 이동
				// 최초의 카카오 로그인 실행 하는 경우,카카오 로그인을 한번 실행해서 임시 회원이지만 정규 회원 가입을 하지 않은 경우.
			} else if (kakao_user != null && kakao_user.getUser_join() == 0) {
				// share_id 전송 해주는 이유는 간직하다가 회원가입 직전에 insert 할떄 필요 하기 떄문.
				out.println("<script>");
				out.println("window.open('kakaoAlert.go?user_email=" + user_email + "&share_id=" + share_id
						+ "', '카카오톡 연동 회원 가입', 'titlebar=0,height=500,width=370,top=120,left=400,status=0,scrollbars=0,location=0,resizable=0,menubar=0,toolbar=0');");
				out.println("</script>");
			} else if (kakao_user == null) {
				// 최초 로그인이니까 임시정보 입력해버리기.
				int check = dao.kakao_insert(user_email);
				out.println("<script>");
				out.println("window.open('kakaoAlert.go?user_email=" + user_email + "&share_id=" + share_id
						+ "', '카카오톡 연동 회원 가입', 'titlebar=0,height=500,width=370,top=120,left=400,status=0,scrollbars=0,location=0,resizable=0,menubar=0,toolbar=0');");
				out.println("</script>");
			}
		} else {
			out.println("<script>");
			out.println("alert('카카오 정보를 불러오지 못했습니다.')");
			out.println("history.back()");
			out.println("</script>");
		}
		return null;
	}
	@RequestMapping("kakaoAlert.go")
	public String gokakaoalertPage(HttpServletRequest request, @RequestParam("user_email") String user_email,
			@RequestParam("share_id") String share_id) {
		return "login/kakaojoin_alert";
	}
}
