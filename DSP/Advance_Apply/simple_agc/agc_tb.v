`timescale 1ns/1ns

module agc_tb;

	reg clk;
	reg rst;
	wire signed [15:0] x_in;
	wire signed [15:0] y_out;	
	reg [15:0] ref;
	reg [7:0] addr;	
	reg [7:0] sh;	
	wire [7:0] data;	
	reg [7:0] a_coef;
		
	reg [15:0] ref_lvl;
	
	always #20 clk = ~clk;


	always @(posedge clk or negedge rst)
		if(!rst) addr <= 'h0;
		else addr <= addr + 'h1;	

	//always @(posedge clk or negedge rst)
	//	if(!rst) ref_lvl <= 'h0;
	//	else if (&addr) ref_lvl <= ref_lvl + 'hf;	

	assign x_in = {$signed(data - 8'h80) , 8'h0};
	
	//assign ref = ref_lvl;
	
	sine_rom SINE(
		.addr(addr),
		.data(data)
	);

	agc UUT(
		.clk(clk),
		.rst(rst),
		.x_in(x_in >>> sh),
		.a_coef(a_coef),
		.reference(ref),
		.y_out(y_out)
	);


	initial begin
		clk = 'b0;
		rst = 'b0;
		sh = 'h1;	
		ref = 'h3fff;
		a_coef = 'h3f;
		#20 rst = 'b1;
		
		#100000     
		sh = 'h2;	
		#200000     
		sh = 'h1;	 
		#100000     
		sh = 'h0;  
		#100000     
		sh = 'h2;	
		#250000 
		sh = 'h3;	
		#250000 
		sh = 'h0;  
		#250000 
		sh = 'h2;	
		#10000000                                          
		$write("Simulation has finished");
		$finish;
	end

	initial begin
		$dumpfile("agc_tb.vcd");
		$dumpvars(0,agc_tb);
	end

endmodule


module sine_rom(
    input   [7:0] addr,
    output  [7:0] data
);

reg [7:0] mem [0:255];
    
initial
  $readmemh("sine.txt", mem);

assign data = mem[addr]; 
        
endmodule
			
		
