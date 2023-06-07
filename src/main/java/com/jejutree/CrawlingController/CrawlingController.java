package com.jejutree.CrawlingController;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/model")
public class CrawlingController {

    @RequestMapping(value = "/tmap.go")
    public String crawlDataByTitle(@RequestParam("title") String title, Model model) {
        List<CrawlingData> crawlingDataList = getCrawlingDataByTitle(title);
        
        model.addAttribute("crawlingDataList", crawlingDataList);
        
        return "TMAP"; // assuming the name of your HTML page is 'TMAP'
    }

    public List<CrawlingData> getCrawlingDataByTitle(String title) {
        List<CrawlingData> crawlingDataList = new ArrayList<>();

        try {
            // 네이버 '인플루언서'에서 제목을 기반으로 검색하여 데이터 크롤링
            String url = "https://search.naver.com/search.naver?where=influencer&sm=tab_jum&query=" + title;
            Document document = Jsoup.connect(url).get();
            Elements blogPosts = document.select(".keyword_bx._item._check_visible");
            
            System.out.println("searchQuery:::"+ title);
            int count = 0; // 가져온 데이터의 개수를 카운트하기 위한 변수

            
            for (int i = 0; i < blogPosts.size(); i++) {
                Element post = blogPosts.get(i);

                String postTitle = post.select(".name_link._foryou_trigger").text();
                String postUrl = post.select(".name_link._foryou_trigger").attr("href");
                String thumbnailUrl = "";

                Element thumbArea = post.select(".thumb_area").first();
                if (thumbArea != null) {
                    if (thumbArea.hasClass("type_solo")) {
                        thumbnailUrl = thumbArea.select("img").attr("src");
                    } else {
                        thumbnailUrl = thumbArea.select(".thumb_area img").attr("src");
                    }
                }

                postTitle = Jsoup.parse(postTitle).text();

                // 썸네일 URL이 비어있지 않은 경우에만 데이터를 추가합니다.
                if (!postUrl.isEmpty() && !thumbnailUrl.isEmpty()) {
                    CrawlingData crawlingData = new CrawlingData();
                    crawlingData.setTitle(postTitle);
                    crawlingData.setUrl(postUrl);
                    crawlingData.setThumbnail(thumbnailUrl);

                    //System.out.println("postTitle:::" + postTitle);
                    //System.out.println("postUrl:::" + postUrl);
                    //System.out.println("thumbnailUrl:::" + thumbnailUrl);

                    if (count < 5) {
                        crawlingDataList.add(crawlingData);
                        count++;
                        System.out.println("Title :::::" + crawlingData.getTitle());
                        System.out.println("Url :::::" + crawlingData.getUrl());
                    } else {
                        break;
                    }
                }
            }


           // System.out.println("CrawlingController crawlingDataList :::" + crawlingDataList);

        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return crawlingDataList;
    }
}
