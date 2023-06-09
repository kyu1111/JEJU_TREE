package com.jejutree.plans_model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PlanBoardCommentDTO {
    private int rno;
     private int board_no;
     private int comment_ParentNumber;
     private String writer;
     private String content;
     private String regdate;
     private String updatedate ;
}
