module design(	
    input CLK, 
	
    output LED_R0, 
	output LED_R1, 
	output LED_R2, 
	output LED_R3, 
	output LED_R4, 
	output LED_R5, 
	output LED_R6, 
	output LED_R7,

	output LED_C0, 
	output LED_C1, 
	output LED_C2, 
	output LED_C3,
	
	input BTN_1,
	input BTN_2,
	input BTN_RST
	);
	
	reg STOP;
	reg [22:0] TICK_COUNTER;

	reg [11:0] COUNTER;
	reg [7:0]  LED_R; 
	reg [3:0]  LED_C;
	reg [7:0]  LED_MATRIX [3:0];

	reg [3:0] RESYNC_BTN1;
	reg [3:0] RESYNC_BTN2;
	reg [3:0] RESYNC_BTN_RST;

	reg [7:0] BUCKET_POSITION;
	reg [2:0] EGG_POSITION_X;
	reg [1:0] EGG_POSITION_Y;

	reg [31:0] RND;
	reg [4:0]  RND_INDEX;

	always@(posedge CLK) begin
		if(!STOP) begin
			RESYNC_BTN1 <= {RESYNC_BTN1[2:0], BTN_1 == 0};
			RESYNC_BTN2 <= {RESYNC_BTN2[2:0], BTN_2 == 0};  

			// If the move right button is pressed move bucket to the right
			if(~RESYNC_BTN1[3] & RESYNC_BTN1[2]) begin
				if(BUCKET_POSITION != 7) begin
					LED_MATRIX[3] <= LED_MATRIX[3] >> 1;
					BUCKET_POSITION <=  BUCKET_POSITION + 1;
				end
			end

			// If the move left button is pressed move bucket to the left
			if(~RESYNC_BTN2[3] & RESYNC_BTN2[2]) begin
				if(BUCKET_POSITION != 1) begin
					LED_MATRIX[3] <= LED_MATRIX[3] << 1;
					BUCKET_POSITION <= BUCKET_POSITION - 1;
				end
			end

			// Generate egg and drop straight down as per the laws of physics :-)
			if(TICK_COUNTER == 0) begin
				LED_MATRIX[0] <= 0;
				LED_MATRIX[1] <= 0;
				LED_MATRIX[2] <= 0;

				if(EGG_POSITION_Y == 0) begin 
					EGG_POSITION_X = RND[RND_INDEX + 2: RND_INDEX];
					RND_INDEX = RND_INDEX + 1;
				end

				if(EGG_POSITION_Y != 3)
					LED_MATRIX[EGG_POSITION_Y] <= 1 << EGG_POSITION_X;

				EGG_POSITION_Y <= EGG_POSITION_Y + 1;
			end

			// Check if the egg has been caught in the basket
			if(TICK_COUNTER == 0 && EGG_POSITION_Y == 3) begin
				if(!(LED_MATRIX[3] & (1 << EGG_POSITION_X)))
					STOP <= 1;
			end
		end
		else begin
			LED_MATRIX[0] <= 8'h00;
			LED_MATRIX[1] <= 8'h00;
			LED_MATRIX[2] <= 8'h00;
			LED_MATRIX[3] <= 8'h00;

			// Check for reset signal
			RESYNC_BTN_RST <= {RESYNC_BTN_RST[2:0], BTN_RST == 0};
			
			if(~RESYNC_BTN_RST[3] & RESYNC_BTN_RST[2]) begin
				STOP <= 0;
				LED_MATRIX[3] <= 8'h18;
				BUCKET_POSITION <= 8'h04;
				RND <= 32'hA3D0_4F56;
			end
				
		end
	end

    always@(posedge CLK) begin
		case (COUNTER[11:10])
			2'b00: begin
    			LED_R[7:0] <= ~LED_MATRIX[0];
				LED_C[3:0] <= ~4'b0001;
			end	    
			2'b01: begin
    			LED_R[7:0] <= ~LED_MATRIX[1];
				LED_C[3:0] <= ~4'b0010;
			end	    
			2'b10: begin
    			LED_R[7:0] <= ~LED_MATRIX[2];
				LED_C[3:0] <= ~4'b0100;
			end	    
			2'b11: begin
    			LED_R[7:0] <= ~LED_MATRIX[3];
				LED_C[3:0] <= ~4'b1000;
			end	    
    	endcase
    end
	
	always@(posedge CLK) begin
		COUNTER <= COUNTER + 1;
		TICK_COUNTER <= TICK_COUNTER + 1;
	end

	assign {LED_R7, LED_R6, LED_R5, LED_R4, LED_R3, LED_R2, LED_R1, LED_R0} = LED_R;
	assign {LED_C0, LED_C1, LED_C2, LED_C3} = LED_C;

endmodule