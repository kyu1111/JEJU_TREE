package com.jejutree.model;

import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
@Controller
public class HomeController {
   @RequestMapping(value = "/", method = RequestMethod.GET)
   public String home(Locale locale, Model model) {
      
      return "MainPage";

   }
   @RequestMapping(value = "MainPage.go", method = RequestMethod.GET)
   public String toMainPage() {
   
      return "MainPage";
   
   }
   @RequestMapping(value = "tmap.go", method = RequestMethod.GET)
   public String toTMAP() {
   
      return "TMAP";
   
   }
   @RequestMapping(value = "/Planner.go", method = RequestMethod.POST)
   public String handleMarkerData(@RequestParam("title") String title,@RequestParam("address") String address,Model model) {
       // 데이터를 Model에 추가하여 JSP 페이지에서 사용할 수 있도록 합니다.
       model.addAttribute("title", title);
       model.addAttribute("address", address);

       return "Planner";
   }
   
}