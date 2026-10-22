module cgFSM (
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire       ready,
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire [7:0] C,

    output reg        valid,
    output reg        done,
    output reg [7:0] data_out
);

  localparam IDLE = 3'b000,
             As = 3'b001,
             Bs = 3'b010,
             Cs = 3'b011,
             DONE = 3'b100;

  reg [2:0] cur_state, next_state;

  // 1. State register
  always @(posedge clk) begin
    if (reset) begin cur_state <= IDLE;
    valid <= 1'b0;
    done <= 1'b0;
    data_out <= 8'b00000000;
    end 
    else         cur_state <= next_state;
  end

  // 2. Next-state logic
  always @(*) begin
    next_state = cur_state;
    valid = 1'b1;
    data_out = 8'b00000000;
    case (cur_state)
      IDLE : begin 
        done = 1'b0;
        if (start) begin
        valid = 1'b1;
        next_state = As;
      end
      end
      
      As : if (ready) begin
        data_out = A;
        next_state = Bs;
        valid = 1'b1;
      end else  begin
        data_out = A;
        next_state = As;
        valid = 1'b1;
      end

      Bs : if (ready) begin
        data_out = B;
        next_state = Cs;
        valid = 1'b1;
      end else  begin
        data_out = B;
        next_state = Bs;
        valid = 1'b1;
      end

      Cs: if (ready) begin
        data_out = C;
        next_state = DONE;
        valid = 1'b1;
      end else  begin
        data_out = C;
        next_state = Cs;
        valid = 1'b1;
      end

      DONE: begin data_out = 8'b00000000;
            valid = 1'b0;
            done = 1'b1;
            next_state = IDLE;
      end

      default: next_state = IDLE;
    endcase
  end
endmodule