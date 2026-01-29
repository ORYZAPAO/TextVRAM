// Text VRAM Controller Top Module
// Integrates VGA timing, Font ROM, and Text VRAM

module text_vram_top #(
    // Display resolution (default: VGA 640x480)
    parameter H_ACTIVE      = 640,
    parameter H_FRONT_PORCH = 16,
    parameter H_SYNC_PULSE  = 96,
    parameter H_BACK_PORCH  = 48,
    parameter V_ACTIVE      = 480,
    parameter V_FRONT_PORCH = 10,
    parameter V_SYNC_PULSE  = 2,
    parameter V_BACK_PORCH  = 33,
    parameter H_SYNC_POL    = 0,    // 0: negative, 1: positive
    parameter V_SYNC_POL    = 0,    // 0: negative, 1: positive

    // Character parameters
    parameter CHAR_WIDTH    = 8,    // Character width in pixels
    parameter CHAR_HEIGHT   = 8,    // Character height in pixels

    // Text screen size (calculated from display and character size)
    parameter COLS = H_ACTIVE / CHAR_WIDTH,   // 80 columns for 640px
    parameter ROWS = V_ACTIVE / CHAR_HEIGHT,  // 60 rows for 480px
    parameter ADDR_WIDTH = $clog2(COLS * ROWS)
)(
    // Clocks and reset
    input  wire        pixel_clk,       // Pixel clock (25.175MHz for VGA)
    input  wire        rst_n,           // Active low reset

    // VGA output
    output wire        hsync,           // Horizontal sync
    output wire        vsync,           // Vertical sync
    output wire        pixel_en,        // Pixel data valid
    output reg         pixel_data,      // Monochrome pixel output

    // CPU interface for VRAM access
    input  wire        cpu_clk,         // CPU clock
    input  wire        cpu_we,          // Write enable
    input  wire [ADDR_WIDTH-1:0] cpu_addr,   // Address
    input  wire [7:0]  cpu_wdata,       // Write data
    output wire [7:0]  cpu_rdata        // Read data
);

    // Internal signals
    wire [11:0] pixel_x;
    wire [11:0] pixel_y;
    wire        vga_pixel_en;

    // Character position
    wire [6:0]  char_col;   // Current character column
    wire [6:0]  char_row;   // Current character row
    wire [2:0]  char_x;     // X position within character (0-7)
    wire [2:0]  char_y;     // Y position within character (0-7)

    // VRAM signals
    wire [ADDR_WIDTH-1:0] vram_addr;
    wire [7:0]  char_code;

    // Font ROM signals
    wire [7:0]  font_row_data;

    // Pipeline registers for timing alignment
    reg [2:0]   char_x_d1, char_x_d2;
    reg         pixel_en_d1, pixel_en_d2;
    reg         hsync_d1, hsync_d2;
    reg         vsync_d1, vsync_d2;

    // Calculate character position from pixel position
    assign char_col = pixel_x[9:3];  // pixel_x / 8
    assign char_row = pixel_y[9:3];  // pixel_y / 8
    assign char_x   = pixel_x[2:0];  // pixel_x % 8
    assign char_y   = pixel_y[2:0];  // pixel_y % 8

    // VRAM address = row * COLS + col
    assign vram_addr = char_row * COLS + char_col;

    // VGA Timing Generator
    vga_timing #(
        .H_ACTIVE       (H_ACTIVE),
        .H_FRONT_PORCH  (H_FRONT_PORCH),
        .H_SYNC_PULSE   (H_SYNC_PULSE),
        .H_BACK_PORCH   (H_BACK_PORCH),
        .V_ACTIVE       (V_ACTIVE),
        .V_FRONT_PORCH  (V_FRONT_PORCH),
        .V_SYNC_PULSE   (V_SYNC_PULSE),
        .V_BACK_PORCH   (V_BACK_PORCH),
        .H_SYNC_POL     (H_SYNC_POL),
        .V_SYNC_POL     (V_SYNC_POL)
    ) u_vga_timing (
        .clk        (pixel_clk),
        .rst_n      (rst_n),
        .hsync      (hsync_raw),
        .vsync      (vsync_raw),
        .pixel_en   (vga_pixel_en),
        .pixel_x    (pixel_x),
        .pixel_y    (pixel_y)
    );

    wire hsync_raw, vsync_raw;

    // Text VRAM
    text_vram #(
        .COLS       (COLS),
        .ROWS       (ROWS),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) u_text_vram (
        .clk        (pixel_clk),
        .disp_addr  (vram_addr),
        .disp_data  (char_code),
        .cpu_clk    (cpu_clk),
        .cpu_we     (cpu_we),
        .cpu_addr   (cpu_addr),
        .cpu_wdata  (cpu_wdata),
        .cpu_rdata  (cpu_rdata)
    );

    // Font ROM
    font_rom u_font_rom (
        .clk        (pixel_clk),
        .char_code  (char_code[6:0]),  // 7-bit ASCII
        .row        (char_y),
        .font_data  (font_row_data)
    );

    // Pipeline for timing alignment
    // Stage 1: VRAM read (1 cycle delay)
    // Stage 2: Font ROM read (1 cycle delay)
    always @(posedge pixel_clk or negedge rst_n) begin
        if (!rst_n) begin
            char_x_d1   <= 3'd0;
            char_x_d2   <= 3'd0;
            pixel_en_d1 <= 1'b0;
            pixel_en_d2 <= 1'b0;
            hsync_d1    <= ~H_SYNC_POL;
            hsync_d2    <= ~H_SYNC_POL;
            vsync_d1    <= ~V_SYNC_POL;
            vsync_d2    <= ~V_SYNC_POL;
        end else begin
            // Stage 1
            char_x_d1   <= char_x;
            pixel_en_d1 <= vga_pixel_en;
            hsync_d1    <= hsync_raw;
            vsync_d1    <= vsync_raw;

            // Stage 2
            char_x_d2   <= char_x_d1;
            pixel_en_d2 <= pixel_en_d1;
            hsync_d2    <= hsync_d1;
            vsync_d2    <= vsync_d1;
        end
    end

    // Pixel output - select bit from font row data
    // Font data is MSB first (bit 7 = leftmost pixel)
    always @(posedge pixel_clk or negedge rst_n) begin
        if (!rst_n) begin
            pixel_data <= 1'b0;
        end else begin
            pixel_data <= font_row_data[7 - char_x_d2];
        end
    end

    // Output signals with proper pipeline delay
    assign hsync    = hsync_d2;
    assign vsync    = vsync_d2;
    assign pixel_en = pixel_en_d2;

endmodule
