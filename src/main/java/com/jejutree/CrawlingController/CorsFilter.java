package com.jejutree.CrawlingController;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CorsFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 필터 초기화 메서드
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        // CORS 설정
        response.setHeader("Access-Control-Allow-Origin", "*"); // 모든 도메인에서의 요청 허용
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS"); // 허용할 HTTP 메서드 설정
        response.setHeader("Access-Control-Max-Age", "3600"); // 프리플라이(OPTIONS) 요청의 유효 시간 설정
        response.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept"); // 허용할 헤더 설정

        // 필터 체인 실행
        filterChain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 필터 종료 메서드
    }
}
