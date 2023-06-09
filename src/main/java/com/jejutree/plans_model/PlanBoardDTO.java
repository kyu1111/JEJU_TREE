package com.jejutree.plans_model;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PlanBoardDTO {
       private int board_no;
       private String writer;
       private int plan_id;
       private String user_Nickname;
       private String board_Title;
       private String board_Content;
       private String board_RegDate;
       private String  board_Update_Date;
       private int board_hit;
       private int like_count;
}