`timescale 1ns / 1ps

module cgFSM_tb;

    // Inputs
    reg clk;
    reg reset;
    reg start;
    reg ready;
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;

    // Outputs
    wire valid;
    wire done;
    wire [7:0] data_out;

    // Instantiate the Unit Under Test (UUT)
    cgFSM uut (
        .clk(clk), 
        .reset(reset), 
        .start(start), 
        .ready(ready), 
        .A(A), 
        .B(B), 
        .C(C), 
        .valid(valid), 
        .done(done), 
        .data_out(data_out)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
         $dumpfile("cgFSM.vcd");
    $dumpvars(0, clk, reset, start, ready, A, B, C, valid, done, data_out);
        // Initialize Inputs
        clk = 0;
        reset = 0;
        start = 0;
        ready = 0;
        A = 8'hA1;
        B = 8'hB2;
        C = 8'hC3;

        // Apply reset
        #15;
        reset = 1;
        #10;
        reset = 0;
        @(posedge clk);
        start = 1;  // Pulse start for 1 cycle
        @(posedge clk);
        start = 0;
        
        // Assert ready to transfer A
        ready = 1;
        #10;
        
        ready = 0;
        #30;

        // Raise ready to transfer B and then C
        ready = 1;
        #30;

        // Wait for completion
        @(posedge done);
        $display("Transmission completed successfully at time %0t", $time);
        #20;
        $finish;
    end

    // Monitor signals at each rising clock edge
    always @(posedge clk) begin
        if (!reset) begin
            $display("Time=%0t | State=%0d | START=%b READY=%b | VALID=%b DONE=%b DATA_OUT=%h", 
                     $time, uut.cur_state, start, ready, valid, done, data_out);
        end
    end

endmodule