module async_fifo #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 4)
(
    input wire wr_clk,             // Write clock
    input wire rd_clk,             // Read clock
    input wire rst,                // Reset signal
    input wire wr_en,              // Write enable
    input wire rd_en,              // Read enable
    input wire [DATA_WIDTH-1:0] wr_data, // Write data
    output reg [DATA_WIDTH-1:0] rd_data, // Read data
    output wire full,              // FIFO full flag
    output wire empty              // FIFO empty flag
);

    // FIFO memory array
    reg [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

    // Write and read pointers
    reg [ADDR_WIDTH:0] w_ptr, r_ptr;

    // Gray code pointers for synchronization
    reg [ADDR_WIDTH:0] w_ptr_gray, r_ptr_gray;
    reg [ADDR_WIDTH:0] w_ptr_gray_rd_clk, r_ptr_gray_wr_clk;

    // Write logic
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            w_ptr <= 0;
            w_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            mem[w_ptr[ADDR_WIDTH-1:0]] <= wr_data;
            w_ptr <= w_ptr + 1;
            w_ptr_gray <= (w_ptr + 1) ^ ((w_ptr + 1) >> 1);
        end
    end

    // Read logic
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            r_ptr <= 0;
            r_ptr_gray <= 0;
        end else if (rd_en && !empty) begin
            rd_data <= mem[r_ptr[ADDR_WIDTH-1:0]];
            r_ptr <= r_ptr + 1;
            r_ptr_gray <= (r_ptr + 1) ^ ((r_ptr + 1) >> 1);
        end
    end

    // Synchronization logic
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            w_ptr_gray_rd_clk <= 0;
        end else begin
            w_ptr_gray_rd_clk <= w_ptr_gray;
        end
    end

    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            r_ptr_gray_wr_clk <= 0;
        end else begin
            r_ptr_gray_wr_clk <= r_ptr_gray;
        end
    end

    // Empty and Full flag logic
    assign empty = (w_ptr_gray_rd_clk == r_ptr_gray);
    assign full = (w_ptr_gray == {~r_ptr_gray_wr_clk[ADDR_WIDTH:ADDR_WIDTH-1], r_ptr_gray_wr_clk[ADDR_WIDTH-2:0]});

endmodule
