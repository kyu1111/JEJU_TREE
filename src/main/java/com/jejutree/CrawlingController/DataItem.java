package com.jejutree.CrawlingController;

public class DataItem {
    private String title;
    private String address;
    private String url;
    private String thumbnailUrl;

    // 생성자, getter, setter 메서드

    // 생성자
    public DataItem(String title, String address, String url, String thumbnailUrl) {
        this.title = title;
        this.address = address;
        this.url = url;
        this.thumbnailUrl = thumbnailUrl;
    }

    // Getter 메서드
    public String getTitle() {
        return title;
    }

    public String getAddress() {
        return address;
    }

    public String getUrl() {
        return url;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    // Setter 메서드
    public void setTitle(String title) {
        this.title = title;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }
}

