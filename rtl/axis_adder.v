module axis_adder(ACLK, ARESETn, TDATA_in, TLAST_in, TVALID_in, TREADY_in,
                  TDATA_out, TLAST_out, TVALID_out, TREADY_out);

   input        ACLK;
   input        ARESETn;

   input [7:0]  TDATA_in;
   input        TLAST_in;
   input        TVALID_in;
   output       TREADY_out;

   output [7:0] TDATA_out;
   output       TLAST_out;
   output       TVALID_out;
   input        TREADY_in;

   reg [7:0]    TDATA_out;

   reg          TVALID_out;
   reg          TLAST_out;
   reg          TREADY_out; 

   reg [2:0]    count_out;
   reg [31:0]   sum;

   always @(posedge ACLK) begin
      if (! ARESETn) begin
         TDATA_out <= 0;
      end
      else
        // if (TREADY_in) begin
           case(count_out)
             4: begin
                TDATA_out <= sum[31:24];
                TLAST_out <= 0;
                TVALID_out <= 1;
                TREADY_out <= 0;
             end
             3: begin
                TDATA_out <= sum[23:16];
                TLAST_out <= 0;
                TVALID_out <= 1;
                TREADY_out <= 0;
             end
             2: begin
                TDATA_out <= sum[15:8];
                TLAST_out <= 0;
                TVALID_out <= 1;
                TREADY_out <= 0;
             end
             1: begin
                TDATA_out <= sum[7:0];
                TLAST_out <= 1;
                TVALID_out <= 1;
                TREADY_out <= 0;
             end
             0: begin
                TDATA_out <= 0;
                TLAST_out <= 0;
                TVALID_out <= 0;
                TREADY_out <= 1;
                sum <= 0;
             end
           endcase // case (count_out)
        // end // if (TREADY_in)
   end
   
   always @(posedge ACLK) begin
      if (! ARESETn) begin
         // ARESETn the signals
         count_out <= 'b111;
         TVALID_out <= 0;
         TLAST_out <= 0;
         TREADY_out <= 1;
         sum <= 0;
      end
      else begin
         if (TVALID_in && TREADY_out) begin
            sum <= sum + {24'b0, TDATA_in};
            if (TLAST_in) begin
               TREADY_out <= 0;
               count_out <= 4;
            end
         end
         if (TREADY_out == 0) begin
            if (TREADY_in == 1) begin
               count_out <= count_out - 1;
            end
         end
      end
   end
endmodule

