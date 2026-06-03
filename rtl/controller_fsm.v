module controller_fsm(
	input clk,
	input reset,
	input start,

	output reg enable,
	output reg done
);

reg [1:0] state;

parameter IDLE =2'b00;
parameter LOAD =2'b01;
parameter COMPUTE =2'b10;
parameter DONE =2'b11;

always @(posedge clk or posedge reset)
begin 
	if(reset)
	begin
		state <= IDLE;
		enable <= 0;
		done <= 0;
	end

	else
	begin
		case(state)

		IDLE:
		begin
			enable <= 0;
			done <= 0;

			if(start)
				state <= LOAD;
		end

		LOAD:
		begin
			state <= COMPUTE;
		end

		COMPUTE:
		begin
			enable <= 1;
			state <= DONE;
		end

		DONE:
		begin
			enable <= 0;
			done <= 1;
		end

		endcase
	end
end
endmodule
