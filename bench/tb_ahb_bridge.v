// =========================================================
// Testbench for AHB Text VRAM Bridge
//
// Tests AHB slave interface with various transaction types
//
// Licensed under the MIT Licensed
//
// Copyright (c) 2026 by ORYZA (https://github.com/ORYZAPAO)
//
// =========================================================

`timescale 1ns / 1ps

module tb_ahb_bridge;

    // Clock and reset
    reg HCLK;
    reg HRESETn;
    reg pixel_clk;
    reg rst_n;

    // AHB signals
    reg        HSEL;
    reg [31:0] HADDR;
    reg [31:0] HWDATA;
    reg        HWRITE;
    reg [1:0]  HTRANS;
    reg [2:0]  HSIZE;
    reg [2:0]  HBURST;
    reg        HREADY;
    wire [31:0] HRDATA;
    wire        HREADYOUT;
    wire [1:0]  HRESP;

    // VRAM CPU interface
    wire        cpu_clk;
    wire        cpu_we;
    wire [14:0] cpu_addr;
    wire [7:0]  cpu_wdata;
    wire [7:0]  cpu_rdata;

    // VGA output (not used in this test, but required by text_vram_top)
    wire        hsync;
    wire        vsync;
    wire        pixel_en;
    wire        pixel_data;
    wire [7:0]  pixel_r;
    wire [7:0]  pixel_g;
    wire [7:0]  pixel_b;

    // Test parameters
    localparam BASE_ADDR = 32'h40000000;
    localparam PAGE_SIZE = 32'h12C0;  // 4800 bytes (80 x 60)

    // AHB transfer types
    localparam HTRANS_IDLE   = 2'b00;
    localparam HTRANS_BUSY   = 2'b01;
    localparam HTRANS_NONSEQ = 2'b10;
    localparam HTRANS_SEQ    = 2'b11;

    // AHB burst types
    localparam HBURST_SINGLE = 3'b000;
    localparam HBURST_INCR   = 3'b001;
    localparam HBURST_WRAP4  = 3'b010;
    localparam HBURST_INCR4  = 3'b011;

    // AHB transfer size
    localparam HSIZE_BYTE = 3'b000;
    localparam HSIZE_HALF = 3'b001;
    localparam HSIZE_WORD = 3'b010;

    // AHB response
    localparam HRESP_OKAY  = 2'b00;
    localparam HRESP_ERROR = 2'b01;

    // Test counters
    integer test_count;
    integer error_count;

    //=========================================================
    // Clock Generation
    //=========================================================
    initial begin
        HCLK = 0;
        forever #10 HCLK = ~HCLK;  // 50MHz (20ns period)
    end

    initial begin
        pixel_clk = 0;
        forever #20 pixel_clk = ~pixel_clk;  // 25MHz (40ns period)
    end

    //=========================================================
    // DUT Instantiation
    //=========================================================

    // AHB Bridge
    ahb_text_vram_bridge #(
        .BASE_ADDR  (BASE_ADDR),
        .ADDR_WIDTH (15),
        .MEM_SIZE   (32'h4B00)
    ) u_ahb_bridge (
        .HCLK       (HCLK),
        .HRESETn    (HRESETn),
        .HSEL       (HSEL),
        .HADDR      (HADDR),
        .HWDATA     (HWDATA),
        .HWRITE     (HWRITE),
        .HTRANS     (HTRANS),
        .HSIZE      (HSIZE),
        .HBURST     (HBURST),
        .HREADY     (HREADY),
        .HRDATA     (HRDATA),
        .HREADYOUT  (HREADYOUT),
        .HRESP      (HRESP),
        .cpu_clk    (cpu_clk),
        .cpu_we     (cpu_we),
        .cpu_addr   (cpu_addr),
        .cpu_wdata  (cpu_wdata),
        .cpu_rdata  (cpu_rdata)
    );

    // Text VRAM Top
    text_vram_top #(
        .H_ACTIVE       (640),
        .H_FRONT_PORCH  (16),
        .H_SYNC_PULSE   (96),
        .H_BACK_PORCH   (48),
        .V_ACTIVE       (480),
        .V_FRONT_PORCH  (10),
        .V_SYNC_PULSE   (2),
        .V_BACK_PORCH   (33),
        .H_SYNC_POL     (0),
        .V_SYNC_POL     (0),
        .CHAR_WIDTH     (8),
        .CHAR_HEIGHT    (8)
    ) u_text_vram (
        .pixel_clk  (pixel_clk),
        .rst_n      (rst_n),
        .hsync      (hsync),
        .vsync      (vsync),
        .pixel_en   (pixel_en),
        .pixel_data (pixel_data),
        .pixel_r    (pixel_r),
        .pixel_g    (pixel_g),
        .pixel_b    (pixel_b),
        .cpu_clk    (cpu_clk),
        .cpu_we     (cpu_we),
        .cpu_addr   (cpu_addr),
        .cpu_wdata  (cpu_wdata),
        .cpu_rdata  (cpu_rdata)
    );

    //=========================================================
    // AHB Transaction Tasks
    //=========================================================

    // AHB Write Byte
    task ahb_write_byte;
        input [31:0] addr;
        input [7:0]  data;
        begin
            @(posedge HCLK);
            HSEL   = 1'b1;
            HADDR  = addr;
            HWRITE = 1'b1;
            HTRANS = HTRANS_NONSEQ;
            HSIZE  = HSIZE_BYTE;
            HBURST = HBURST_SINGLE;
            HREADY = 1'b1;

            @(posedge HCLK);
            // Place data in correct byte lane based on address[1:0]
            case (addr[1:0])
                2'b00: HWDATA = {24'h0, data};
                2'b01: HWDATA = {16'h0, data, 8'h0};
                2'b10: HWDATA = {8'h0, data, 16'h0};
                2'b11: HWDATA = {data, 24'h0};
            endcase
            HTRANS = HTRANS_IDLE;

            @(posedge HCLK);
            HSEL = 1'b0;
        end
    endtask

    // AHB Read Byte
    task ahb_read_byte;
        input  [31:0] addr;
        output [7:0]  data;
        begin
            @(posedge HCLK);
            HSEL   = 1'b1;
            HADDR  = addr;
            HWRITE = 1'b0;
            HTRANS = HTRANS_NONSEQ;
            HSIZE  = HSIZE_BYTE;
            HBURST = HBURST_SINGLE;
            HREADY = 1'b1;

            @(posedge HCLK);
            HTRANS = HTRANS_IDLE;

            @(posedge HCLK);
            data = HRDATA[7:0];
            HSEL = 1'b0;
        end
    endtask

    // AHB Write Burst (INCR4)
    task ahb_write_burst4;
        input [31:0] start_addr;
        input [7:0]  data0;
        input [7:0]  data1;
        input [7:0]  data2;
        input [7:0]  data3;
        begin
            // Beat 0 - NONSEQ
            @(posedge HCLK);
            HSEL   = 1'b1;
            HADDR  = start_addr;
            HWRITE = 1'b1;
            HTRANS = HTRANS_NONSEQ;
            HSIZE  = HSIZE_BYTE;
            HBURST = HBURST_INCR4;
            HREADY = 1'b1;

            // Beat 1 - SEQ
            @(posedge HCLK);
            HWDATA = {24'h0, data0};
            HADDR  = start_addr + 1;
            HTRANS = HTRANS_SEQ;

            // Beat 2 - SEQ
            @(posedge HCLK);
            HWDATA = {24'h0, data1};
            HADDR  = start_addr + 2;
            HTRANS = HTRANS_SEQ;

            // Beat 3 - SEQ
            @(posedge HCLK);
            HWDATA = {24'h0, data2};
            HADDR  = start_addr + 3;
            HTRANS = HTRANS_SEQ;

            // Final data
            @(posedge HCLK);
            HWDATA = {24'h0, data3};
            HTRANS = HTRANS_IDLE;

            @(posedge HCLK);
            HSEL = 1'b0;
        end
    endtask

    // AHB Read Burst (INCR4)
    task ahb_read_burst4;
        input  [31:0] start_addr;
        output [7:0]  data0;
        output [7:0]  data1;
        output [7:0]  data2;
        output [7:0]  data3;
        begin
            // Beat 0 - NONSEQ
            @(posedge HCLK);
            HSEL   = 1'b1;
            HADDR  = start_addr;
            HWRITE = 1'b0;
            HTRANS = HTRANS_NONSEQ;
            HSIZE  = HSIZE_BYTE;
            HBURST = HBURST_INCR4;
            HREADY = 1'b1;

            // Beat 1 - SEQ (data0 available)
            @(posedge HCLK);
            #1; // Let signals settle
            data0 = HRDATA[7:0];
            HADDR  = start_addr + 1;
            HTRANS = HTRANS_SEQ;

            // Beat 2 - SEQ (data1 available)
            @(posedge HCLK);
            #1;
            data1 = HRDATA[7:0];
            HADDR  = start_addr + 2;
            HTRANS = HTRANS_SEQ;

            // Beat 3 - SEQ (data2 available)
            @(posedge HCLK);
            #1;
            data2 = HRDATA[7:0];
            HADDR  = start_addr + 3;
            HTRANS = HTRANS_SEQ;

            // Final beat (data3 available)
            @(posedge HCLK);
            #1;
            data3 = HRDATA[7:0];
            HTRANS = HTRANS_IDLE;

            @(posedge HCLK);
            HSEL = 1'b0;
        end
    endtask

    //=========================================================
    // Test Scenarios
    //=========================================================
    initial begin
        // Initialize signals
        HRESETn = 0;
        rst_n   = 0;
        HSEL    = 0;
        HADDR   = 0;
        HWDATA  = 0;
        HWRITE  = 0;
        HTRANS  = HTRANS_IDLE;
        HSIZE   = HSIZE_BYTE;
        HBURST  = HBURST_SINGLE;
        HREADY  = 1;

        test_count  = 0;
        error_count = 0;

        // Generate VCD file
        $dumpfile("tb_ahb_bridge.vcd");
        $dumpvars(0, tb_ahb_bridge);

        // Reset
        #100;
        HRESETn = 1;
        rst_n   = 1;
        #100;

        $display("\n========================================");
        $display("AHB Bridge Test Started");
        $display("========================================\n");

        //------------------------------------
        // Test 1: Single Byte Write/Read - Page 0 (Character)
        //------------------------------------
        test_count = test_count + 1;
        $display("[Test %0d] Single Byte Write/Read - Page 0", test_count);
        ahb_write_byte(BASE_ADDR + 32'h0000, 8'h48);  // 'H'
        #50;
        begin
            reg [7:0] rdata;
            ahb_read_byte(BASE_ADDR + 32'h0000, rdata);
            #50;
            if (rdata == 8'h48) begin
                $display("  PASS: Read data = 0x%02h", rdata);
            end else begin
                $display("  FAIL: Expected 0x48, Got 0x%02h", rdata);
                error_count = error_count + 1;
            end
        end

        //------------------------------------
        // Test 2: Single Byte Write/Read - Page 1 (Red)
        //------------------------------------
        test_count = test_count + 1;
        $display("[Test %0d] Single Byte Write/Read - Page 1 (Red)", test_count);
        ahb_write_byte(BASE_ADDR + 32'h12C0, 8'hFF);  // Red = 255
        #50;
        begin
            reg [7:0] rdata;
            ahb_read_byte(BASE_ADDR + 32'h12C0, rdata);
            #50;
            if (rdata == 8'hFF) begin
                $display("  PASS: Read data = 0x%02h", rdata);
            end else begin
                $display("  FAIL: Expected 0xFF, Got 0x%02h", rdata);
                error_count = error_count + 1;
            end
        end

        //------------------------------------
        // Test 3: Individual Writes - "Hello"
        //------------------------------------
        test_count = test_count + 1;
        $display("[Test %0d] Individual Writes - Hello", test_count);
        ahb_write_byte(BASE_ADDR + 32'h0000, 8'h48);  // 'H'
        #50;
        ahb_write_byte(BASE_ADDR + 32'h0001, 8'h65);  // 'e'
        #50;
        ahb_write_byte(BASE_ADDR + 32'h0002, 8'h6C);  // 'l'
        #50;
        ahb_write_byte(BASE_ADDR + 32'h0003, 8'h6C);  // 'l'
        #50;
        ahb_write_byte(BASE_ADDR + 32'h0004, 8'h6F);  // 'o'
        #50;

        //------------------------------------
        // Test 4: Individual Reads - Verify "Hello"
        //------------------------------------
        test_count = test_count + 1;
        $display("[Test %0d] Individual Reads - Verify Hello", test_count);
        begin
            reg [7:0] rd0, rd1, rd2, rd3, rd4;
            ahb_read_byte(BASE_ADDR + 32'h0000, rd0);
            #50;
            ahb_read_byte(BASE_ADDR + 32'h0001, rd1);
            #50;
            ahb_read_byte(BASE_ADDR + 32'h0002, rd2);
            #50;
            ahb_read_byte(BASE_ADDR + 32'h0003, rd3);
            #50;
            ahb_read_byte(BASE_ADDR + 32'h0004, rd4);
            #50;
            if (rd0 == 8'h48 && rd1 == 8'h65 && rd2 == 8'h6C && rd3 == 8'h6C && rd4 == 8'h6F) begin
                $display("  PASS: Read 'Hello' = 0x%02h%02h%02h%02h%02h", rd0, rd1, rd2, rd3, rd4);
            end else begin
                $display("  FAIL: Expected 'Hello', Got 0x%02h%02h%02h%02h%02h", rd0, rd1, rd2, rd3, rd4);
                error_count = error_count + 1;
            end
        end

        //------------------------------------
        // Test 5: Page Boundary Access
        //------------------------------------
        test_count = test_count + 1;
        $display("[Test %0d] Page Boundary Access", test_count);
        ahb_write_byte(BASE_ADDR + 32'h12BF, 8'hAA);  // Last byte of Page 0
        ahb_write_byte(BASE_ADDR + 32'h12C0, 8'hBB);  // First byte of Page 1
        #50;
        begin
            reg [7:0] rdata0, rdata1;
            ahb_read_byte(BASE_ADDR + 32'h12BF, rdata0);
            #50;
            ahb_read_byte(BASE_ADDR + 32'h12C0, rdata1);
            #50;
            if (rdata0 == 8'hAA && rdata1 == 8'hBB) begin
                $display("  PASS: Boundary access OK");
            end else begin
                $display("  FAIL: Expected 0xAA, 0xBB, Got 0x%02h, 0x%02h", rdata0, rdata1);
                error_count = error_count + 1;
            end
        end

        //------------------------------------
        // Test 6: Out of Range Address (should return ERROR)
        //------------------------------------
        test_count = test_count + 1;
        $display("[Test %0d] Out of Range Address - Expect ERROR", test_count);
        @(posedge HCLK);
        HSEL   = 1'b1;
        HADDR  = BASE_ADDR + 32'h5000;  // Out of range
        HWRITE = 1'b0;
        HTRANS = HTRANS_NONSEQ;
        HSIZE  = HSIZE_BYTE;
        HBURST = HBURST_SINGLE;

        @(posedge HCLK);
        HTRANS = HTRANS_IDLE;
        #1; // Small delay to let nonblocking assignments settle
        // ERROR response starts here - HREADYOUT=0, HRESP=ERROR
        if (HRESP == HRESP_ERROR && HREADYOUT == 1'b0) begin
            $display("  PASS: ERROR response received (cycle 1)");
        end else begin
            $display("  FAIL: Expected ERROR with HREADYOUT=0, Got HRESP=%b HREADYOUT=%b", HRESP, HREADYOUT);
            error_count = error_count + 1;
        end

        @(posedge HCLK);
        // ERROR response cycle 2 - HREADYOUT=1, HRESP=ERROR
        HSEL = 1'b0;
        #50;

        //------------------------------------
        // Test 7: WRAP4 Burst (should return ERROR)
        //------------------------------------
        test_count = test_count + 1;
        $display("[Test %0d] WRAP4 Burst - Expect ERROR", test_count);
        @(posedge HCLK);
        HSEL   = 1'b1;
        HADDR  = BASE_ADDR;
        HWRITE = 1'b1;
        HTRANS = HTRANS_NONSEQ;
        HSIZE  = HSIZE_BYTE;
        HBURST = HBURST_WRAP4;  // Not supported

        @(posedge HCLK);
        HTRANS = HTRANS_IDLE;
        #1; // Small delay to let nonblocking assignments settle
        // ERROR response starts here
        if (HRESP == HRESP_ERROR && HREADYOUT == 1'b0) begin
            $display("  PASS: ERROR response received for WRAP4");
        end else begin
            $display("  FAIL: Expected ERROR with HREADYOUT=0, Got HRESP=%b HREADYOUT=%b", HRESP, HREADYOUT);
            error_count = error_count + 1;
        end

        @(posedge HCLK);
        HSEL = 1'b0;
        #50;

        //------------------------------------
        // Test 8: Write/Read All Pages
        //------------------------------------
        test_count = test_count + 1;
        $display("[Test %0d] Write/Read All Pages", test_count);
        ahb_write_byte(BASE_ADDR + 32'h0050, 8'h41);  // Page 0: 'A'
        ahb_write_byte(BASE_ADDR + 32'h1310, 8'hF0);  // Page 1: Red
        ahb_write_byte(BASE_ADDR + 32'h25D0, 8'h0F);  // Page 2: Green
        ahb_write_byte(BASE_ADDR + 32'h3890, 8'hAA);  // Page 3: Blue
        #50;
        begin
            reg [7:0] rd0, rd1, rd2, rd3;
            ahb_read_byte(BASE_ADDR + 32'h0050, rd0);
            #50;
            ahb_read_byte(BASE_ADDR + 32'h1310, rd1);
            #50;
            ahb_read_byte(BASE_ADDR + 32'h25D0, rd2);
            #50;
            ahb_read_byte(BASE_ADDR + 32'h3890, rd3);
            #50;
            if (rd0 == 8'h41 && rd1 == 8'hF0 && rd2 == 8'h0F && rd3 == 8'hAA) begin
                $display("  PASS: All pages accessible");
            end else begin
                $display("  FAIL: Page data mismatch");
                error_count = error_count + 1;
            end
        end

        //------------------------------------
        // Test Summary
        //------------------------------------
        #100;
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total Tests: %0d", test_count);
        $display("Errors:      %0d", error_count);
        if (error_count == 0) begin
            $display("\nALL TESTS PASSED!");
        end else begin
            $display("\nSOME TESTS FAILED!");
        end
        $display("========================================\n");

        #200;
        $finish;
    end

    // Timeout watchdog
    initial begin
        #100000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule
