package com.jejutree.plans_model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Plan_participantsDTO {
	String user_id;
	String user_share_id;
	int number;
}
