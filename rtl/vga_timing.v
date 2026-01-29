// VGA Timing Generator
// Generates HSYNC, VSYNC, and pixel enable signals

module vga_timing #(
    // Default: VGA 640x480 @ 60Hz (25.175MHz pixel clock)
    parameter H_ACTIVE      = 640,
    parameter H_FRONT_PORCH = 16,
    parameter H_SYNC_PULSE  = 96,
    parameter H_BACK_PORCH  = 48,
    parameter V_ACTIVE      = 480,
    parameter V_FRONT_PORCH = 10,
    parameter V_SYNC_PULSE  = 2,
    parameter V_BACK_PORCH  = 33,
    parameter H_SYNC_POL    = 0,    // 0: negative, 1: positive
    parameter V_SYNC_POL    = 0     // 0: negative, 1: positive
)(
    input  wire        clk,         // Pixel clock
    input  wire        rst_n,       // Active low reset
    output reg         hsync,       // Horizontal sync
    output reg         vsync,       // Vertical sync
    output wire        pixel_en,    // Pixel data enable (active area)
    output wire [11:0] pixel_x,     // Current pixel X coordinate
    output wire [11:0] pixel_y      // Current pixel Y coordinate
);

    // Total horizontal and vertical counts
    localparam H_TOTAL = H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
    localparam V_TOTAL = V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    // Counters
    reg [11:0] h_cnt;
    reg [11:0] v_cnt;

    // Horizontal counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            h_cnt <= 12'd0;
        end else begin
            if (h_cnt == H_TOTAL - 1)
                h_cnt <= 12'd0;
            else
                h_cnt <= h_cnt + 12'd1;
        end
    end

    // Vertical counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            v_cnt <= 12'd0;
        end else begin
            if (h_cnt == H_TOTAL - 1) begin
                if (v_cnt == V_TOTAL - 1)
                    v_cnt <= 12'd0;
                else
                    v_cnt <= v_cnt + 12'd1;
            end
        end
    end

    // HSYNC generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hsync <= ~H_SYNC_POL;
        end else begin
            if ((h_cnt >= H_ACTIVE + H_FRONT_PORCH) &&
                (h_cnt < H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE))
                hsync <= H_SYNC_POL;
            else
                hsync <= ~H_SYNC_POL;
        end
    end

    // VSYNC generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vsync <= ~V_SYNC_POL;
        end else begin
            if ((v_cnt >= V_ACTIVE + V_FRONT_PORCH) &&
                (v_cnt < V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE))
                vsync <= V_SYNC_POL;
            else
                vsync <= ~V_SYNC_POL;
        end
    end

    // Pixel enable - active during visible area
    assign pixel_en = (h_cnt < H_ACTIVE) && (v_cnt < V_ACTIVE);

    // Pixel coordinates
    assign pixel_x = h_cnt;
    assign pixel_y = v_cnt;

endmodule
