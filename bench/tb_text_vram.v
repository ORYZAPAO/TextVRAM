// Testbench for Text VRAM Controller
`timescale 1ns / 1ps

module tb_text_vram;

    // Parameters
    parameter H_ACTIVE = 640;
    parameter V_ACTIVE = 480;
    parameter COLS = 80;
    parameter ROWS = 60;
    parameter ADDR_WIDTH = 13;

    // Clock period (25.175MHz -> ~39.72ns, use 40ns for simplicity)
    parameter CLK_PERIOD = 40;

    // Signals
    reg         pixel_clk;
    reg         rst_n;
    wire        hsync;
    wire        vsync;
    wire        pixel_en;
    wire        pixel_data;

    reg         cpu_clk;
    reg         cpu_we;
    reg  [ADDR_WIDTH-1:0] cpu_addr;
    reg  [7:0]  cpu_wdata;
    wire [7:0]  cpu_rdata;

    // DUT instantiation
    text_vram_top #(
        .H_ACTIVE   (H_ACTIVE),
        .V_ACTIVE   (V_ACTIVE),
        .COLS       (COLS),
        .ROWS       (ROWS),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) dut (
        .pixel_clk  (pixel_clk),
        .rst_n      (rst_n),
        .hsync      (hsync),
        .vsync      (vsync),
        .pixel_en   (pixel_en),
        .pixel_data (pixel_data),
        .cpu_clk    (cpu_clk),
        .cpu_we     (cpu_we),
        .cpu_addr   (cpu_addr),
        .cpu_wdata  (cpu_wdata),
        .cpu_rdata  (cpu_rdata)
    );

    // Clock generation
    initial begin
        pixel_clk = 0;
        forever #(CLK_PERIOD/2) pixel_clk = ~pixel_clk;
    end

    initial begin
        cpu_clk = 0;
        forever #(CLK_PERIOD/2) cpu_clk = ~cpu_clk;
    end

    // Stimulus
    initial begin
        // Initialize
        rst_n = 0;
        cpu_we = 0;
        cpu_addr = 0;
        cpu_wdata = 0;

        // Reset
        #(CLK_PERIOD * 10);
        rst_n = 1;
        #(CLK_PERIOD * 10);

        // Write "Hello" to VRAM starting at position (0, 0)
        write_char(0, "H");
        write_char(1, "e");
        write_char(2, "l");
        write_char(3, "l");
        write_char(4, "o");
        write_char(5, " ");
        write_char(6, "W");
        write_char(7, "o");
        write_char(8, "r");
        write_char(9, "l");
        write_char(10, "d");
        write_char(11, "!");

        // Write "FPGA" to row 1
        write_char(COLS + 0, "F");
        write_char(COLS + 1, "P");
        write_char(COLS + 2, "G");
        write_char(COLS + 3, "A");

        // Write some numbers
        write_char(COLS * 2 + 0, "0");
        write_char(COLS * 2 + 1, "1");
        write_char(COLS * 2 + 2, "2");
        write_char(COLS * 2 + 3, "3");
        write_char(COLS * 2 + 4, "4");
        write_char(COLS * 2 + 5, "5");
        write_char(COLS * 2 + 6, "6");
        write_char(COLS * 2 + 7, "7");
        write_char(COLS * 2 + 8, "8");
        write_char(COLS * 2 + 9, "9");

        // Wait for a few frames
        repeat(3) @(negedge vsync);

        $display("Simulation completed successfully!");
        $finish;
    end

    // Task to write a character to VRAM
    task write_char;
        input [ADDR_WIDTH-1:0] addr;
        input [7:0] data;
        begin
            @(posedge cpu_clk);
            cpu_addr <= addr;
            cpu_wdata <= data;
            cpu_we <= 1;
            @(posedge cpu_clk);
            cpu_we <= 0;
        end
    endtask

    // Monitor HSYNC/VSYNC edges
    reg prev_hsync, prev_vsync;
    integer h_count, v_count;

    always @(posedge pixel_clk) begin
        prev_hsync <= hsync;
        prev_vsync <= vsync;

        // Count HSYNC pulses
        if (hsync && !prev_hsync) begin
            h_count <= h_count + 1;
        end

        // Count VSYNC pulses
        if (vsync && !prev_vsync) begin
            v_count <= v_count + 1;
            $display("Frame %0d completed, HSYNC count: %0d", v_count, h_count);
            h_count <= 0;
        end
    end

    initial begin
        h_count = 0;
        v_count = 0;
    end

    // Waveform dump
    initial begin
        $dumpfile("tb_text_vram.vcd");
        $dumpvars(0, tb_text_vram);
    end

    // Timeout
    initial begin
        #(CLK_PERIOD * 800 * 525 * 4);  // ~4 frames
        $display("Simulation timeout!");
        $finish;
    end

endmodule
