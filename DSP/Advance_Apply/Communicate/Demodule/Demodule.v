module Demodule #
(
    parameter ITERATIONS   = 16,
    parameter PHASE_WIDTH  = 32,
    parameter INPUT_WIDTH  = 8,
    parameter OUTPUT_WIDTH = 24
)
(
    input                     clk_in,
    input                     RST,
    input  [PHASE_WIDTH-1:0]  Fre_word,
    input  [INPUT_WIDTH-1:0]  data_in,

    output [OUTPUT_WIDTH-1:0] FM_Demodule_OUT,
    output [OUTPUT_WIDTH-1:0] PM_Demodule_OUT,
    output [OUTPUT_WIDTH-1:0] AM_Demodule_OUT
);

localparam DATA_WIDTH = 12;
wire  [DATA_WIDTH-1:0]  cos_wave;
wire  [DATA_WIDTH-1:0]  sin_wave;
wire  [PHASE_WIDTH-1:0] pha_diff;
Cordic #
(
    .XY_BITS(DATA_WIDTH),               
    .PH_BITS(PHASE_WIDTH),      //1~32     
    .ITERATIONS(ITERATIONS),     //1~32
    .CORDIC_STYLE("ROTATE"),    //ROTATE  //VECTOR
    .PHASE_ACC("ON")            //ON      //OFF
)
IQ_Gen_u 
(
    .clk_in(clk_in),
    .RST(RST),
    .x_i(0), 
    .y_i(0),
    .phase_in(Fre_word),          
        
    .x_o(cos_wave),
    .y_o(sin_wave),
    .phase_out(pha_diff)
);

wire  [DATA_WIDTH-1:0] Y_diff;
wire  [DATA_WIDTH-1:0] Modulus;
wire  [OUTPUT_WIDTH-1:0] phase_out;
Cordic #
(
    .XY_BITS(DATA_WIDTH),               
    .PH_BITS(16),                //1~32
    .ITERATIONS(ITERATIONS),     //1~32
    .CORDIC_STYLE("VECTOR")      //ROTATE  //VECTOR
)
Demodule_Gen_u 
(
    .clk_in(clk_in),
    .RST(RST),
    .x_i(I_SIG), 
    .y_i(Q_SIG),
    .phase_in(0),          
     
    .x_o(AM_Demodule_OUT),
    .y_o(Y_diff),
    .phase_out(PM_Demodule_OUT)
);

reg PM_Demodule_OUT_r;
always @(posedge clk_in) begin
    PM_Demodule_OUT_r <= PM_Demodule_OUT;
end
assign FM_Demodule_OUT = PM_Demodule_OUT - PM_Demodule_OUT_r;

endmodule