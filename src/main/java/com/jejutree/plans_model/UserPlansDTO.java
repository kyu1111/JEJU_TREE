package com.jejutree.plans_model;

import java.sql.Timestamp;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserPlansDTO {
   
   private int id;
   private String user_id;
   private String description;
   private String title;
   private String start_date;
   private String end_date;
   private String location;
   private Timestamp createdAt;
   private Timestamp updatedAt;
   private double markerLat;
   private double markerLng;
   private String image;
   private String addr;

}