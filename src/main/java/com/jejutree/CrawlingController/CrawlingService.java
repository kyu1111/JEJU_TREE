package com.jejutree.CrawlingController;

import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
public class CrawlingService {

    public List<CrawlingData> crawlDataByTitle(String title) {
        List<DataItem> crawledDataList = getCrawledDataList(); // 크롤링 작업을 수행하여 데이터를 가져오는 메서드 호출

        // 가져온 데이터를 CrawlingData 객체로 변환하여 리스트에 저장
        List<CrawlingData> crawlingDataList = new ArrayList<>();

        // 예시: 가져온 데이터를 반복하면서 CrawlingData 객체로 변환하여 리스트에 추가
        for (DataItem dataItem : crawledDataList) {
            CrawlingData crawlingData = new CrawlingData();
            crawlingData.setTitle(dataItem.getTitle());
            crawlingData.setUrl(dataItem.getUrl()); // 추가: 데이터 아이템의 URL 값을 설정
            //crawlingData.setThumbnailUrl(dataItem.getThumbnailUrl()); // 추가: 데이터 아이템의 썸네일 URL 값을 설정
            crawlingDataList.add(crawlingData);
        }

        return crawlingDataList;
    }
    
    private List<DataItem> getCrawledDataList() {
        List<DataItem> crawledDataList = new ArrayList<>();
        // 크롤링 작업을 수행하여 데이터를 crawledDataList에 추가
        // TODO: 크롤링 작업을 수행하여 데이터를 crawledDataList에 추가하는 로직 구현
        // 예시: 데이터를 크롤링하여 DataItem 객체를 생성하고 crawledDataList에 추가하는 로직
        DataItem dataItem1 = new DataItem("블로그 제목1", "블로그 주소1","","");
        DataItem dataItem2 = new DataItem("블로그 제목2", "블로그 주소2","","");
        crawledDataList.add(dataItem1);
        crawledDataList.add(dataItem2);
        return crawledDataList;
    }
}
