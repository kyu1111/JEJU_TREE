package com.jejutree.model;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.jejutree.CrawlingController.CrawlingController;
import com.jejutree.CrawlingController.CrawlingData;

@Controller
public class HomeController {

	@Autowired
   private final CrawlingController crawlingController;

   @Autowired
   public HomeController(CrawlingController crawlingController) {
       this.crawlingController = crawlingController;
   }

   @RequestMapping(value = "/", method = RequestMethod.GET)
   public String home(Locale locale, Model model) {
      return "MainPage";
   }

   @RequestMapping(value = "MainPage.go", method = RequestMethod.GET)
   public String toMainPage() {
      return "MainPage";
   }

   @RequestMapping(value = "tmap.go", method = RequestMethod.GET)
   public String toTMAP(@RequestParam(value = "title", required = false) String title, Model model) {
       System.out.println("searchQuery :::: " + title);
       if (title == null) {
           title = "제주도 여행";
       }
       List<CrawlingData> crawlingDataList = crawlingController.getCrawlingDataByTitle(title);
       System.out.println("crawlingDataList :::" + crawlingDataList);
       
       model.addAttribute("crawlingDataList", crawlingDataList); // Model에 crawlingDataList 추가
       
       return "TMAP";
   }


   @RequestMapping(value = "/Planner.go", method = RequestMethod.POST)
   public String handleMarkerData(@RequestParam("title") String title, @RequestParam("address") String address, Model model) {
       // 데이터를 Model에 추가하여 JSP 페이지에서 사용할 수 있도록 합니다.
       model.addAttribute("title", title);
       model.addAttribute("address", address);

       return "Planner";
   }
   
   @RequestMapping(value = "/TMAP.go", method = RequestMethod.GET)
   public String toTmapPage(@RequestParam("searchKeyword") String searchKeyword, Model model) {
       model.addAttribute("searchKeyword", searchKeyword);
       return "TMAP";
   } 
}
