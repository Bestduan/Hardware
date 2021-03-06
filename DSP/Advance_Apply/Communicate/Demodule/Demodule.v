module Demodule #
(
    parameter PHASE_WIDTH  = 32,
    parameter INPUT_WIDTH  = 8,
    parameter OUTPUT_WIDTH = 24
)
(
    input                     clk_in,
    input                     RST,

    input  [15:0]             N,
    input  [PHASE_WIDTH-1:0]  Fre_word,

    input  [INPUT_WIDTH-1:0]  wave_in,

    output [OUTPUT_WIDTH-1:0] FM_Demodule_OUT,
    output [OUTPUT_WIDTH-1:0] PM_Demodule_OUT,
    output [OUTPUT_WIDTH-1:0] AM_Demodule_OUT
);

// IQ_MIXED Outputs
wire  clk_out;
wire  [OUTPUT_WIDTH - 1 : 0]  I_OUT;
wire  [OUTPUT_WIDTH - 1 : 0]  Q_OUT;

IQ_MIXED #(
    .LO_WIDTH     ( 12 ),
    .PHASE_WIDTH  ( PHASE_WIDTH ),
    .Fiter_WIDTH  ( 32 ),
    .INPUT_WIDTH  ( INPUT_WIDTH ),
    .OUTPUT_WIDTH ( OUTPUT_WIDTH )
)
 u_IQ_MIXED (
    .clk_in                  ( clk_in     ),
    .RST                     ( RST        ),
    .N                       ( N          ),
    .Fre_word                ( Fre_word   ),
    .wave_in                 ( wave_in    ),

    .clk_out                 ( clk_out    ),
    .I_OUT                   ( I_OUT      ),
    .Q_OUT                   ( Q_OUT      )
);

wire  [OUTPUT_WIDTH-1:0] Y_diff;
wire  [OUTPUT_WIDTH-1:0] Modulus;
wire  [OUTPUT_WIDTH-1:0] phase_out;
Cordic # (
    .XY_BITS(OUTPUT_WIDTH),               
    .PH_BITS(OUTPUT_WIDTH),      //1~32
    .ITERATIONS(16),     //1~32
    .CORDIC_STYLE("VECTOR")      //ROTATE  //VECTOR
)
Demodule_Gen_u (
    .clk_in(clk_out),
    .RST(RST),
    .x_i(I_OUT), 
    .y_i(Q_OUT),
    .phase_in(0),          
     
    .x_o(AM_Demodule_OUT),
    .y_o(Y_diff),
    .phase_out(PM_Demodule_OUT)
);

reg PM_Demodule_OUT_r;
always @(posedge clk_out) begin
    PM_Demodule_OUT_r <= PM_Demodule_OUT;
end
assign FM_Demodule_OUT = $signed(PM_Demodule_OUT) - $signed(PM_Demodule_OUT_r);

endmodule