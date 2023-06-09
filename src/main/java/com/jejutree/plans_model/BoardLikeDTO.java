package com.jejutree.plans_model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardLikeDTO {
   private int id;
   private String user_id;
   private int board_no;
   private int is_liked;
}
