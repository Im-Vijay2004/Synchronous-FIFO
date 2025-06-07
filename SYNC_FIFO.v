module SYNC_FIFO#(parameter DEPTH=8,WIDTH=8)(sys_clk,rst,data_in,wr_en,data_out,rd_en,empty,full,overflow,underflow,AN,display_out);
input sys_clk,rst;
input [WIDTH-1:0]data_in;
input wr_en,rd_en;
output reg [WIDTH-1:0] data_out;
output reg empty,full,underflow,overflow;
output [7:0] AN,display_out;

// Intermediate variables
localparam PTR_WIDTH=$clog2(DEPTH);
reg [PTR_WIDTH-1:0] wr_ptr,rd_ptr;
reg wr_toggle,rd_toggle;
reg [WIDTH-1:0] FIFO [0:DEPTH-1];
wire clk;
CLK_DIV Clock_Divider(sys_clk,clk);
Multi_Seg_Disp Seven_Segment_Controller(sys_clk,8,data_in[7:4],data_in[3:0],50,50,50,50,data_out[7:4],data_out[3:0],AN,display_out);
// FIFO Write
always @(posedge clk)
begin
    if(rst)
    begin
        wr_ptr<=0;
        wr_toggle<=0;
        overflow<=0;
    end
    else if(wr_en)
    begin
        if(full)
            overflow<=1;
        else
        begin
            overflow<=0;
            FIFO[wr_ptr]<=data_in;
            if(wr_ptr==DEPTH-1)
            begin
                wr_ptr<=0;
                wr_toggle<=~wr_toggle;
            end
            else
                wr_ptr<=wr_ptr+1;
        end
    end
    else
    begin
        overflow<=0;
    end
end

// Read FIFO
always @(posedge clk)
begin
    if(rst)
    begin
        rd_ptr<=0;
        rd_toggle<=0;
        underflow<=0;
		data_out<=0;
    end
    else if(rd_en)
    begin
        if(empty)
        begin
            underflow<=1;
            data_out<=data_out;
        end
        else
        begin
            underflow<=0;
            data_out<=FIFO[rd_ptr];
            if(rd_ptr==DEPTH-1)
            begin
                rd_ptr<=0;
                rd_toggle<=~rd_toggle;
            end
            else
                rd_ptr<=rd_ptr+1;
        end
    end
    else
    begin
        underflow<=0;
    end
end
always @*
begin
    if(rd_ptr==wr_ptr)
    begin
        if(rd_toggle==wr_toggle)
        begin
            empty<=1;
            full<=0;
        end
        else
        begin
            empty<=0;
            full<=1;
        end
    end
    else
    begin
        empty<=0;
        full<=0;
    end
end
endmodule
module CLK_DIV(clk_in,clk_out);
input clk_in;
output reg clk_out=0;
integer i;
always @(posedge clk_in)
begin
    if(i==24999999)
    begin
        clk_out<=~clk_out;
        i<=0;
    end
    else
        i<=i+1;
end
endmodule
