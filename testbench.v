module tb_async_fifo;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    // Signals
    reg wr_clk;
    reg rd_clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] wr_data;
    wire [DATA_WIDTH-1:0] rd_data;
    wire full;
    wire empty;

    // Instantiate the FIFO
    async_fifo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) fifo (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        wr_clk = 0;
        forever #5 wr_clk = ~wr_clk;
    end

    initial begin
        rd_clk = 0;
        forever #7 rd_clk = ~rd_clk;
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;

        // Release reset
        #15 rst = 0;

        // Write some data into the FIFO
        #10 wr_en = 1;
        wr_data = 8'hAA;
        #10 wr_data = 8'hBB;
        #10 wr_data = 8'hCC;
        #10 wr_en = 0;

        // Read data from the FIFO
        #20 rd_en = 1;
        #40 rd_en = 0;

        // Further writes and reads
        #10 wr_en = 1;
        wr_data = 8'hDD;
        #10 wr_data = 8'hEE;
        #10 wr_en = 0;
        #20 rd_en = 1;
        #30 rd_en = 0;

        // Finish simulation
        #100 $finish;
    end

    // Monitor
    initial begin
        $monitor("Time: %0t | wr_clk: %b | rd_clk: %b | rst: %b | wr_en: %b | rd_en: %b | wr_data: %h | rd_data: %h | full: %b | empty: %b",
                 $time, wr_clk, rd_clk, rst, wr_en, rd_en, wr_data, rd_data, full, empty);
    end

endmodule
