`timescale 1ns / 1ps
module Cordic #
(
	parameter XY_BITS      = 12,
	parameter PH_BITS      = 32,
	parameter ITERATIONS   = 32,
	parameter CORDIC_STYLE = "ROTATE",
	parameter PHASE_ACC    = "ON"
)
(
	input   clk_in,
	input   RST,
	input   signed [XY_BITS-1:0] x_i,
	input   signed [XY_BITS-1:0] y_i,
	input   signed [PH_BITS-1:0] phase_in,

	output  signed [XY_BITS-1:0] x_o,
	output  signed [XY_BITS-1:0] y_o,
	output  signed [PH_BITS-1:0] phase_out,

	input          valid_in, 
	output         valid_out
);

endmodule
