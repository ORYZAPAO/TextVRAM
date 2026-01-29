// 8x8 ASCII Font ROM
// Contains basic ASCII characters (0x20-0x7F)

module font_rom (
    input  wire        clk,
    input  wire [6:0]  char_code,   // ASCII code (0x00-0x7F)
    input  wire [2:0]  row,         // Row within character (0-7)
    output reg  [7:0]  font_data    // 8 pixels of font data
);

    // Font ROM: 128 characters x 8 rows = 1024 entries
    reg [7:0] font_mem [0:1023];

    // Loop variable (must be at module level for Verilog-2001)
    integer i;

    // Read font data
    always @(posedge clk) begin
        font_data <= font_mem[{char_code, row}];
    end

    // Initialize font data
    // Basic 8x8 ASCII font (printable characters 0x20-0x7F)
    initial begin
        // Initialize all to 0
        for (i = 0; i < 1024; i = i + 1)
            font_mem[i] = 8'h00;

        // Space (0x20)
        font_mem[{7'h20, 3'd0}] = 8'b00000000;
        font_mem[{7'h20, 3'd1}] = 8'b00000000;
        font_mem[{7'h20, 3'd2}] = 8'b00000000;
        font_mem[{7'h20, 3'd3}] = 8'b00000000;
        font_mem[{7'h20, 3'd4}] = 8'b00000000;
        font_mem[{7'h20, 3'd5}] = 8'b00000000;
        font_mem[{7'h20, 3'd6}] = 8'b00000000;
        font_mem[{7'h20, 3'd7}] = 8'b00000000;

        // ! (0x21)
        font_mem[{7'h21, 3'd0}] = 8'b00011000;
        font_mem[{7'h21, 3'd1}] = 8'b00011000;
        font_mem[{7'h21, 3'd2}] = 8'b00011000;
        font_mem[{7'h21, 3'd3}] = 8'b00011000;
        font_mem[{7'h21, 3'd4}] = 8'b00011000;
        font_mem[{7'h21, 3'd5}] = 8'b00000000;
        font_mem[{7'h21, 3'd6}] = 8'b00011000;
        font_mem[{7'h21, 3'd7}] = 8'b00000000;

        // " (0x22)
        font_mem[{7'h22, 3'd0}] = 8'b01100110;
        font_mem[{7'h22, 3'd1}] = 8'b01100110;
        font_mem[{7'h22, 3'd2}] = 8'b01100110;
        font_mem[{7'h22, 3'd3}] = 8'b00000000;
        font_mem[{7'h22, 3'd4}] = 8'b00000000;
        font_mem[{7'h22, 3'd5}] = 8'b00000000;
        font_mem[{7'h22, 3'd6}] = 8'b00000000;
        font_mem[{7'h22, 3'd7}] = 8'b00000000;

        // # (0x23)
        font_mem[{7'h23, 3'd0}] = 8'b01100110;
        font_mem[{7'h23, 3'd1}] = 8'b01100110;
        font_mem[{7'h23, 3'd2}] = 8'b11111111;
        font_mem[{7'h23, 3'd3}] = 8'b01100110;
        font_mem[{7'h23, 3'd4}] = 8'b11111111;
        font_mem[{7'h23, 3'd5}] = 8'b01100110;
        font_mem[{7'h23, 3'd6}] = 8'b01100110;
        font_mem[{7'h23, 3'd7}] = 8'b00000000;

        // 0 (0x30)
        font_mem[{7'h30, 3'd0}] = 8'b00111100;
        font_mem[{7'h30, 3'd1}] = 8'b01100110;
        font_mem[{7'h30, 3'd2}] = 8'b01101110;
        font_mem[{7'h30, 3'd3}] = 8'b01110110;
        font_mem[{7'h30, 3'd4}] = 8'b01100110;
        font_mem[{7'h30, 3'd5}] = 8'b01100110;
        font_mem[{7'h30, 3'd6}] = 8'b00111100;
        font_mem[{7'h30, 3'd7}] = 8'b00000000;

        // 1 (0x31)
        font_mem[{7'h31, 3'd0}] = 8'b00011000;
        font_mem[{7'h31, 3'd1}] = 8'b00111000;
        font_mem[{7'h31, 3'd2}] = 8'b00011000;
        font_mem[{7'h31, 3'd3}] = 8'b00011000;
        font_mem[{7'h31, 3'd4}] = 8'b00011000;
        font_mem[{7'h31, 3'd5}] = 8'b00011000;
        font_mem[{7'h31, 3'd6}] = 8'b01111110;
        font_mem[{7'h31, 3'd7}] = 8'b00000000;

        // 2 (0x32)
        font_mem[{7'h32, 3'd0}] = 8'b00111100;
        font_mem[{7'h32, 3'd1}] = 8'b01100110;
        font_mem[{7'h32, 3'd2}] = 8'b00000110;
        font_mem[{7'h32, 3'd3}] = 8'b00001100;
        font_mem[{7'h32, 3'd4}] = 8'b00110000;
        font_mem[{7'h32, 3'd5}] = 8'b01100000;
        font_mem[{7'h32, 3'd6}] = 8'b01111110;
        font_mem[{7'h32, 3'd7}] = 8'b00000000;

        // 3 (0x33)
        font_mem[{7'h33, 3'd0}] = 8'b00111100;
        font_mem[{7'h33, 3'd1}] = 8'b01100110;
        font_mem[{7'h33, 3'd2}] = 8'b00000110;
        font_mem[{7'h33, 3'd3}] = 8'b00011100;
        font_mem[{7'h33, 3'd4}] = 8'b00000110;
        font_mem[{7'h33, 3'd5}] = 8'b01100110;
        font_mem[{7'h33, 3'd6}] = 8'b00111100;
        font_mem[{7'h33, 3'd7}] = 8'b00000000;

        // 4 (0x34)
        font_mem[{7'h34, 3'd0}] = 8'b00001100;
        font_mem[{7'h34, 3'd1}] = 8'b00011100;
        font_mem[{7'h34, 3'd2}] = 8'b00101100;
        font_mem[{7'h34, 3'd3}] = 8'b01001100;
        font_mem[{7'h34, 3'd4}] = 8'b01111110;
        font_mem[{7'h34, 3'd5}] = 8'b00001100;
        font_mem[{7'h34, 3'd6}] = 8'b00001100;
        font_mem[{7'h34, 3'd7}] = 8'b00000000;

        // 5 (0x35)
        font_mem[{7'h35, 3'd0}] = 8'b01111110;
        font_mem[{7'h35, 3'd1}] = 8'b01100000;
        font_mem[{7'h35, 3'd2}] = 8'b01111100;
        font_mem[{7'h35, 3'd3}] = 8'b00000110;
        font_mem[{7'h35, 3'd4}] = 8'b00000110;
        font_mem[{7'h35, 3'd5}] = 8'b01100110;
        font_mem[{7'h35, 3'd6}] = 8'b00111100;
        font_mem[{7'h35, 3'd7}] = 8'b00000000;

        // 6 (0x36)
        font_mem[{7'h36, 3'd0}] = 8'b00111100;
        font_mem[{7'h36, 3'd1}] = 8'b01100000;
        font_mem[{7'h36, 3'd2}] = 8'b01100000;
        font_mem[{7'h36, 3'd3}] = 8'b01111100;
        font_mem[{7'h36, 3'd4}] = 8'b01100110;
        font_mem[{7'h36, 3'd5}] = 8'b01100110;
        font_mem[{7'h36, 3'd6}] = 8'b00111100;
        font_mem[{7'h36, 3'd7}] = 8'b00000000;

        // 7 (0x37)
        font_mem[{7'h37, 3'd0}] = 8'b01111110;
        font_mem[{7'h37, 3'd1}] = 8'b00000110;
        font_mem[{7'h37, 3'd2}] = 8'b00001100;
        font_mem[{7'h37, 3'd3}] = 8'b00011000;
        font_mem[{7'h37, 3'd4}] = 8'b00110000;
        font_mem[{7'h37, 3'd5}] = 8'b00110000;
        font_mem[{7'h37, 3'd6}] = 8'b00110000;
        font_mem[{7'h37, 3'd7}] = 8'b00000000;

        // 8 (0x38)
        font_mem[{7'h38, 3'd0}] = 8'b00111100;
        font_mem[{7'h38, 3'd1}] = 8'b01100110;
        font_mem[{7'h38, 3'd2}] = 8'b01100110;
        font_mem[{7'h38, 3'd3}] = 8'b00111100;
        font_mem[{7'h38, 3'd4}] = 8'b01100110;
        font_mem[{7'h38, 3'd5}] = 8'b01100110;
        font_mem[{7'h38, 3'd6}] = 8'b00111100;
        font_mem[{7'h38, 3'd7}] = 8'b00000000;

        // 9 (0x39)
        font_mem[{7'h39, 3'd0}] = 8'b00111100;
        font_mem[{7'h39, 3'd1}] = 8'b01100110;
        font_mem[{7'h39, 3'd2}] = 8'b01100110;
        font_mem[{7'h39, 3'd3}] = 8'b00111110;
        font_mem[{7'h39, 3'd4}] = 8'b00000110;
        font_mem[{7'h39, 3'd5}] = 8'b00000110;
        font_mem[{7'h39, 3'd6}] = 8'b00111100;
        font_mem[{7'h39, 3'd7}] = 8'b00000000;

        // A (0x41)
        font_mem[{7'h41, 3'd0}] = 8'b00011000;
        font_mem[{7'h41, 3'd1}] = 8'b00111100;
        font_mem[{7'h41, 3'd2}] = 8'b01100110;
        font_mem[{7'h41, 3'd3}] = 8'b01100110;
        font_mem[{7'h41, 3'd4}] = 8'b01111110;
        font_mem[{7'h41, 3'd5}] = 8'b01100110;
        font_mem[{7'h41, 3'd6}] = 8'b01100110;
        font_mem[{7'h41, 3'd7}] = 8'b00000000;

        // B (0x42)
        font_mem[{7'h42, 3'd0}] = 8'b01111100;
        font_mem[{7'h42, 3'd1}] = 8'b01100110;
        font_mem[{7'h42, 3'd2}] = 8'b01100110;
        font_mem[{7'h42, 3'd3}] = 8'b01111100;
        font_mem[{7'h42, 3'd4}] = 8'b01100110;
        font_mem[{7'h42, 3'd5}] = 8'b01100110;
        font_mem[{7'h42, 3'd6}] = 8'b01111100;
        font_mem[{7'h42, 3'd7}] = 8'b00000000;

        // C (0x43)
        font_mem[{7'h43, 3'd0}] = 8'b00111100;
        font_mem[{7'h43, 3'd1}] = 8'b01100110;
        font_mem[{7'h43, 3'd2}] = 8'b01100000;
        font_mem[{7'h43, 3'd3}] = 8'b01100000;
        font_mem[{7'h43, 3'd4}] = 8'b01100000;
        font_mem[{7'h43, 3'd5}] = 8'b01100110;
        font_mem[{7'h43, 3'd6}] = 8'b00111100;
        font_mem[{7'h43, 3'd7}] = 8'b00000000;

        // D (0x44)
        font_mem[{7'h44, 3'd0}] = 8'b01111000;
        font_mem[{7'h44, 3'd1}] = 8'b01101100;
        font_mem[{7'h44, 3'd2}] = 8'b01100110;
        font_mem[{7'h44, 3'd3}] = 8'b01100110;
        font_mem[{7'h44, 3'd4}] = 8'b01100110;
        font_mem[{7'h44, 3'd5}] = 8'b01101100;
        font_mem[{7'h44, 3'd6}] = 8'b01111000;
        font_mem[{7'h44, 3'd7}] = 8'b00000000;

        // E (0x45)
        font_mem[{7'h45, 3'd0}] = 8'b01111110;
        font_mem[{7'h45, 3'd1}] = 8'b01100000;
        font_mem[{7'h45, 3'd2}] = 8'b01100000;
        font_mem[{7'h45, 3'd3}] = 8'b01111000;
        font_mem[{7'h45, 3'd4}] = 8'b01100000;
        font_mem[{7'h45, 3'd5}] = 8'b01100000;
        font_mem[{7'h45, 3'd6}] = 8'b01111110;
        font_mem[{7'h45, 3'd7}] = 8'b00000000;

        // F (0x46)
        font_mem[{7'h46, 3'd0}] = 8'b01111110;
        font_mem[{7'h46, 3'd1}] = 8'b01100000;
        font_mem[{7'h46, 3'd2}] = 8'b01100000;
        font_mem[{7'h46, 3'd3}] = 8'b01111000;
        font_mem[{7'h46, 3'd4}] = 8'b01100000;
        font_mem[{7'h46, 3'd5}] = 8'b01100000;
        font_mem[{7'h46, 3'd6}] = 8'b01100000;
        font_mem[{7'h46, 3'd7}] = 8'b00000000;

        // G (0x47)
        font_mem[{7'h47, 3'd0}] = 8'b00111100;
        font_mem[{7'h47, 3'd1}] = 8'b01100110;
        font_mem[{7'h47, 3'd2}] = 8'b01100000;
        font_mem[{7'h47, 3'd3}] = 8'b01101110;
        font_mem[{7'h47, 3'd4}] = 8'b01100110;
        font_mem[{7'h47, 3'd5}] = 8'b01100110;
        font_mem[{7'h47, 3'd6}] = 8'b00111100;
        font_mem[{7'h47, 3'd7}] = 8'b00000000;

        // H (0x48)
        font_mem[{7'h48, 3'd0}] = 8'b01100110;
        font_mem[{7'h48, 3'd1}] = 8'b01100110;
        font_mem[{7'h48, 3'd2}] = 8'b01100110;
        font_mem[{7'h48, 3'd3}] = 8'b01111110;
        font_mem[{7'h48, 3'd4}] = 8'b01100110;
        font_mem[{7'h48, 3'd5}] = 8'b01100110;
        font_mem[{7'h48, 3'd6}] = 8'b01100110;
        font_mem[{7'h48, 3'd7}] = 8'b00000000;

        // I (0x49)
        font_mem[{7'h49, 3'd0}] = 8'b01111110;
        font_mem[{7'h49, 3'd1}] = 8'b00011000;
        font_mem[{7'h49, 3'd2}] = 8'b00011000;
        font_mem[{7'h49, 3'd3}] = 8'b00011000;
        font_mem[{7'h49, 3'd4}] = 8'b00011000;
        font_mem[{7'h49, 3'd5}] = 8'b00011000;
        font_mem[{7'h49, 3'd6}] = 8'b01111110;
        font_mem[{7'h49, 3'd7}] = 8'b00000000;

        // J (0x4A)
        font_mem[{7'h4A, 3'd0}] = 8'b00011110;
        font_mem[{7'h4A, 3'd1}] = 8'b00000110;
        font_mem[{7'h4A, 3'd2}] = 8'b00000110;
        font_mem[{7'h4A, 3'd3}] = 8'b00000110;
        font_mem[{7'h4A, 3'd4}] = 8'b01100110;
        font_mem[{7'h4A, 3'd5}] = 8'b01100110;
        font_mem[{7'h4A, 3'd6}] = 8'b00111100;
        font_mem[{7'h4A, 3'd7}] = 8'b00000000;

        // K (0x4B)
        font_mem[{7'h4B, 3'd0}] = 8'b01100110;
        font_mem[{7'h4B, 3'd1}] = 8'b01101100;
        font_mem[{7'h4B, 3'd2}] = 8'b01111000;
        font_mem[{7'h4B, 3'd3}] = 8'b01110000;
        font_mem[{7'h4B, 3'd4}] = 8'b01111000;
        font_mem[{7'h4B, 3'd5}] = 8'b01101100;
        font_mem[{7'h4B, 3'd6}] = 8'b01100110;
        font_mem[{7'h4B, 3'd7}] = 8'b00000000;

        // L (0x4C)
        font_mem[{7'h4C, 3'd0}] = 8'b01100000;
        font_mem[{7'h4C, 3'd1}] = 8'b01100000;
        font_mem[{7'h4C, 3'd2}] = 8'b01100000;
        font_mem[{7'h4C, 3'd3}] = 8'b01100000;
        font_mem[{7'h4C, 3'd4}] = 8'b01100000;
        font_mem[{7'h4C, 3'd5}] = 8'b01100000;
        font_mem[{7'h4C, 3'd6}] = 8'b01111110;
        font_mem[{7'h4C, 3'd7}] = 8'b00000000;

        // M (0x4D)
        font_mem[{7'h4D, 3'd0}] = 8'b01100011;
        font_mem[{7'h4D, 3'd1}] = 8'b01110111;
        font_mem[{7'h4D, 3'd2}] = 8'b01111111;
        font_mem[{7'h4D, 3'd3}] = 8'b01101011;
        font_mem[{7'h4D, 3'd4}] = 8'b01100011;
        font_mem[{7'h4D, 3'd5}] = 8'b01100011;
        font_mem[{7'h4D, 3'd6}] = 8'b01100011;
        font_mem[{7'h4D, 3'd7}] = 8'b00000000;

        // N (0x4E)
        font_mem[{7'h4E, 3'd0}] = 8'b01100110;
        font_mem[{7'h4E, 3'd1}] = 8'b01110110;
        font_mem[{7'h4E, 3'd2}] = 8'b01111110;
        font_mem[{7'h4E, 3'd3}] = 8'b01111110;
        font_mem[{7'h4E, 3'd4}] = 8'b01101110;
        font_mem[{7'h4E, 3'd5}] = 8'b01100110;
        font_mem[{7'h4E, 3'd6}] = 8'b01100110;
        font_mem[{7'h4E, 3'd7}] = 8'b00000000;

        // O (0x4F)
        font_mem[{7'h4F, 3'd0}] = 8'b00111100;
        font_mem[{7'h4F, 3'd1}] = 8'b01100110;
        font_mem[{7'h4F, 3'd2}] = 8'b01100110;
        font_mem[{7'h4F, 3'd3}] = 8'b01100110;
        font_mem[{7'h4F, 3'd4}] = 8'b01100110;
        font_mem[{7'h4F, 3'd5}] = 8'b01100110;
        font_mem[{7'h4F, 3'd6}] = 8'b00111100;
        font_mem[{7'h4F, 3'd7}] = 8'b00000000;

        // P (0x50)
        font_mem[{7'h50, 3'd0}] = 8'b01111100;
        font_mem[{7'h50, 3'd1}] = 8'b01100110;
        font_mem[{7'h50, 3'd2}] = 8'b01100110;
        font_mem[{7'h50, 3'd3}] = 8'b01111100;
        font_mem[{7'h50, 3'd4}] = 8'b01100000;
        font_mem[{7'h50, 3'd5}] = 8'b01100000;
        font_mem[{7'h50, 3'd6}] = 8'b01100000;
        font_mem[{7'h50, 3'd7}] = 8'b00000000;

        // Q (0x51)
        font_mem[{7'h51, 3'd0}] = 8'b00111100;
        font_mem[{7'h51, 3'd1}] = 8'b01100110;
        font_mem[{7'h51, 3'd2}] = 8'b01100110;
        font_mem[{7'h51, 3'd3}] = 8'b01100110;
        font_mem[{7'h51, 3'd4}] = 8'b01101110;
        font_mem[{7'h51, 3'd5}] = 8'b00111100;
        font_mem[{7'h51, 3'd6}] = 8'b00000110;
        font_mem[{7'h51, 3'd7}] = 8'b00000000;

        // R (0x52)
        font_mem[{7'h52, 3'd0}] = 8'b01111100;
        font_mem[{7'h52, 3'd1}] = 8'b01100110;
        font_mem[{7'h52, 3'd2}] = 8'b01100110;
        font_mem[{7'h52, 3'd3}] = 8'b01111100;
        font_mem[{7'h52, 3'd4}] = 8'b01101100;
        font_mem[{7'h52, 3'd5}] = 8'b01100110;
        font_mem[{7'h52, 3'd6}] = 8'b01100110;
        font_mem[{7'h52, 3'd7}] = 8'b00000000;

        // S (0x53)
        font_mem[{7'h53, 3'd0}] = 8'b00111100;
        font_mem[{7'h53, 3'd1}] = 8'b01100110;
        font_mem[{7'h53, 3'd2}] = 8'b01100000;
        font_mem[{7'h53, 3'd3}] = 8'b00111100;
        font_mem[{7'h53, 3'd4}] = 8'b00000110;
        font_mem[{7'h53, 3'd5}] = 8'b01100110;
        font_mem[{7'h53, 3'd6}] = 8'b00111100;
        font_mem[{7'h53, 3'd7}] = 8'b00000000;

        // T (0x54)
        font_mem[{7'h54, 3'd0}] = 8'b01111110;
        font_mem[{7'h54, 3'd1}] = 8'b00011000;
        font_mem[{7'h54, 3'd2}] = 8'b00011000;
        font_mem[{7'h54, 3'd3}] = 8'b00011000;
        font_mem[{7'h54, 3'd4}] = 8'b00011000;
        font_mem[{7'h54, 3'd5}] = 8'b00011000;
        font_mem[{7'h54, 3'd6}] = 8'b00011000;
        font_mem[{7'h54, 3'd7}] = 8'b00000000;

        // U (0x55)
        font_mem[{7'h55, 3'd0}] = 8'b01100110;
        font_mem[{7'h55, 3'd1}] = 8'b01100110;
        font_mem[{7'h55, 3'd2}] = 8'b01100110;
        font_mem[{7'h55, 3'd3}] = 8'b01100110;
        font_mem[{7'h55, 3'd4}] = 8'b01100110;
        font_mem[{7'h55, 3'd5}] = 8'b01100110;
        font_mem[{7'h55, 3'd6}] = 8'b00111100;
        font_mem[{7'h55, 3'd7}] = 8'b00000000;

        // V (0x56)
        font_mem[{7'h56, 3'd0}] = 8'b01100110;
        font_mem[{7'h56, 3'd1}] = 8'b01100110;
        font_mem[{7'h56, 3'd2}] = 8'b01100110;
        font_mem[{7'h56, 3'd3}] = 8'b01100110;
        font_mem[{7'h56, 3'd4}] = 8'b01100110;
        font_mem[{7'h56, 3'd5}] = 8'b00111100;
        font_mem[{7'h56, 3'd6}] = 8'b00011000;
        font_mem[{7'h56, 3'd7}] = 8'b00000000;

        // W (0x57)
        font_mem[{7'h57, 3'd0}] = 8'b01100011;
        font_mem[{7'h57, 3'd1}] = 8'b01100011;
        font_mem[{7'h57, 3'd2}] = 8'b01100011;
        font_mem[{7'h57, 3'd3}] = 8'b01101011;
        font_mem[{7'h57, 3'd4}] = 8'b01111111;
        font_mem[{7'h57, 3'd5}] = 8'b01110111;
        font_mem[{7'h57, 3'd6}] = 8'b01100011;
        font_mem[{7'h57, 3'd7}] = 8'b00000000;

        // X (0x58)
        font_mem[{7'h58, 3'd0}] = 8'b01100110;
        font_mem[{7'h58, 3'd1}] = 8'b01100110;
        font_mem[{7'h58, 3'd2}] = 8'b00111100;
        font_mem[{7'h58, 3'd3}] = 8'b00011000;
        font_mem[{7'h58, 3'd4}] = 8'b00111100;
        font_mem[{7'h58, 3'd5}] = 8'b01100110;
        font_mem[{7'h58, 3'd6}] = 8'b01100110;
        font_mem[{7'h58, 3'd7}] = 8'b00000000;

        // Y (0x59)
        font_mem[{7'h59, 3'd0}] = 8'b01100110;
        font_mem[{7'h59, 3'd1}] = 8'b01100110;
        font_mem[{7'h59, 3'd2}] = 8'b01100110;
        font_mem[{7'h59, 3'd3}] = 8'b00111100;
        font_mem[{7'h59, 3'd4}] = 8'b00011000;
        font_mem[{7'h59, 3'd5}] = 8'b00011000;
        font_mem[{7'h59, 3'd6}] = 8'b00011000;
        font_mem[{7'h59, 3'd7}] = 8'b00000000;

        // Z (0x5A)
        font_mem[{7'h5A, 3'd0}] = 8'b01111110;
        font_mem[{7'h5A, 3'd1}] = 8'b00000110;
        font_mem[{7'h5A, 3'd2}] = 8'b00001100;
        font_mem[{7'h5A, 3'd3}] = 8'b00011000;
        font_mem[{7'h5A, 3'd4}] = 8'b00110000;
        font_mem[{7'h5A, 3'd5}] = 8'b01100000;
        font_mem[{7'h5A, 3'd6}] = 8'b01111110;
        font_mem[{7'h5A, 3'd7}] = 8'b00000000;

        // a (0x61)
        font_mem[{7'h61, 3'd0}] = 8'b00000000;
        font_mem[{7'h61, 3'd1}] = 8'b00000000;
        font_mem[{7'h61, 3'd2}] = 8'b00111100;
        font_mem[{7'h61, 3'd3}] = 8'b00000110;
        font_mem[{7'h61, 3'd4}] = 8'b00111110;
        font_mem[{7'h61, 3'd5}] = 8'b01100110;
        font_mem[{7'h61, 3'd6}] = 8'b00111110;
        font_mem[{7'h61, 3'd7}] = 8'b00000000;

        // b (0x62)
        font_mem[{7'h62, 3'd0}] = 8'b01100000;
        font_mem[{7'h62, 3'd1}] = 8'b01100000;
        font_mem[{7'h62, 3'd2}] = 8'b01111100;
        font_mem[{7'h62, 3'd3}] = 8'b01100110;
        font_mem[{7'h62, 3'd4}] = 8'b01100110;
        font_mem[{7'h62, 3'd5}] = 8'b01100110;
        font_mem[{7'h62, 3'd6}] = 8'b01111100;
        font_mem[{7'h62, 3'd7}] = 8'b00000000;

        // c (0x63)
        font_mem[{7'h63, 3'd0}] = 8'b00000000;
        font_mem[{7'h63, 3'd1}] = 8'b00000000;
        font_mem[{7'h63, 3'd2}] = 8'b00111100;
        font_mem[{7'h63, 3'd3}] = 8'b01100000;
        font_mem[{7'h63, 3'd4}] = 8'b01100000;
        font_mem[{7'h63, 3'd5}] = 8'b01100000;
        font_mem[{7'h63, 3'd6}] = 8'b00111100;
        font_mem[{7'h63, 3'd7}] = 8'b00000000;

        // d (0x64)
        font_mem[{7'h64, 3'd0}] = 8'b00000110;
        font_mem[{7'h64, 3'd1}] = 8'b00000110;
        font_mem[{7'h64, 3'd2}] = 8'b00111110;
        font_mem[{7'h64, 3'd3}] = 8'b01100110;
        font_mem[{7'h64, 3'd4}] = 8'b01100110;
        font_mem[{7'h64, 3'd5}] = 8'b01100110;
        font_mem[{7'h64, 3'd6}] = 8'b00111110;
        font_mem[{7'h64, 3'd7}] = 8'b00000000;

        // e (0x65)
        font_mem[{7'h65, 3'd0}] = 8'b00000000;
        font_mem[{7'h65, 3'd1}] = 8'b00000000;
        font_mem[{7'h65, 3'd2}] = 8'b00111100;
        font_mem[{7'h65, 3'd3}] = 8'b01100110;
        font_mem[{7'h65, 3'd4}] = 8'b01111110;
        font_mem[{7'h65, 3'd5}] = 8'b01100000;
        font_mem[{7'h65, 3'd6}] = 8'b00111100;
        font_mem[{7'h65, 3'd7}] = 8'b00000000;

        // f (0x66)
        font_mem[{7'h66, 3'd0}] = 8'b00011100;
        font_mem[{7'h66, 3'd1}] = 8'b00110000;
        font_mem[{7'h66, 3'd2}] = 8'b00110000;
        font_mem[{7'h66, 3'd3}] = 8'b01111100;
        font_mem[{7'h66, 3'd4}] = 8'b00110000;
        font_mem[{7'h66, 3'd5}] = 8'b00110000;
        font_mem[{7'h66, 3'd6}] = 8'b00110000;
        font_mem[{7'h66, 3'd7}] = 8'b00000000;

        // g (0x67)
        font_mem[{7'h67, 3'd0}] = 8'b00000000;
        font_mem[{7'h67, 3'd1}] = 8'b00000000;
        font_mem[{7'h67, 3'd2}] = 8'b00111110;
        font_mem[{7'h67, 3'd3}] = 8'b01100110;
        font_mem[{7'h67, 3'd4}] = 8'b01100110;
        font_mem[{7'h67, 3'd5}] = 8'b00111110;
        font_mem[{7'h67, 3'd6}] = 8'b00000110;
        font_mem[{7'h67, 3'd7}] = 8'b00111100;

        // h (0x68)
        font_mem[{7'h68, 3'd0}] = 8'b01100000;
        font_mem[{7'h68, 3'd1}] = 8'b01100000;
        font_mem[{7'h68, 3'd2}] = 8'b01111100;
        font_mem[{7'h68, 3'd3}] = 8'b01100110;
        font_mem[{7'h68, 3'd4}] = 8'b01100110;
        font_mem[{7'h68, 3'd5}] = 8'b01100110;
        font_mem[{7'h68, 3'd6}] = 8'b01100110;
        font_mem[{7'h68, 3'd7}] = 8'b00000000;

        // i (0x69)
        font_mem[{7'h69, 3'd0}] = 8'b00011000;
        font_mem[{7'h69, 3'd1}] = 8'b00000000;
        font_mem[{7'h69, 3'd2}] = 8'b00111000;
        font_mem[{7'h69, 3'd3}] = 8'b00011000;
        font_mem[{7'h69, 3'd4}] = 8'b00011000;
        font_mem[{7'h69, 3'd5}] = 8'b00011000;
        font_mem[{7'h69, 3'd6}] = 8'b00111100;
        font_mem[{7'h69, 3'd7}] = 8'b00000000;

        // j (0x6A)
        font_mem[{7'h6A, 3'd0}] = 8'b00001100;
        font_mem[{7'h6A, 3'd1}] = 8'b00000000;
        font_mem[{7'h6A, 3'd2}] = 8'b00011100;
        font_mem[{7'h6A, 3'd3}] = 8'b00001100;
        font_mem[{7'h6A, 3'd4}] = 8'b00001100;
        font_mem[{7'h6A, 3'd5}] = 8'b01001100;
        font_mem[{7'h6A, 3'd6}] = 8'b00111000;
        font_mem[{7'h6A, 3'd7}] = 8'b00000000;

        // k (0x6B)
        font_mem[{7'h6B, 3'd0}] = 8'b01100000;
        font_mem[{7'h6B, 3'd1}] = 8'b01100000;
        font_mem[{7'h6B, 3'd2}] = 8'b01100110;
        font_mem[{7'h6B, 3'd3}] = 8'b01101100;
        font_mem[{7'h6B, 3'd4}] = 8'b01111000;
        font_mem[{7'h6B, 3'd5}] = 8'b01101100;
        font_mem[{7'h6B, 3'd6}] = 8'b01100110;
        font_mem[{7'h6B, 3'd7}] = 8'b00000000;

        // l (0x6C)
        font_mem[{7'h6C, 3'd0}] = 8'b00111000;
        font_mem[{7'h6C, 3'd1}] = 8'b00011000;
        font_mem[{7'h6C, 3'd2}] = 8'b00011000;
        font_mem[{7'h6C, 3'd3}] = 8'b00011000;
        font_mem[{7'h6C, 3'd4}] = 8'b00011000;
        font_mem[{7'h6C, 3'd5}] = 8'b00011000;
        font_mem[{7'h6C, 3'd6}] = 8'b00111100;
        font_mem[{7'h6C, 3'd7}] = 8'b00000000;

        // m (0x6D)
        font_mem[{7'h6D, 3'd0}] = 8'b00000000;
        font_mem[{7'h6D, 3'd1}] = 8'b00000000;
        font_mem[{7'h6D, 3'd2}] = 8'b01100110;
        font_mem[{7'h6D, 3'd3}] = 8'b01111111;
        font_mem[{7'h6D, 3'd4}] = 8'b01111111;
        font_mem[{7'h6D, 3'd5}] = 8'b01101011;
        font_mem[{7'h6D, 3'd6}] = 8'b01100011;
        font_mem[{7'h6D, 3'd7}] = 8'b00000000;

        // n (0x6E)
        font_mem[{7'h6E, 3'd0}] = 8'b00000000;
        font_mem[{7'h6E, 3'd1}] = 8'b00000000;
        font_mem[{7'h6E, 3'd2}] = 8'b01111100;
        font_mem[{7'h6E, 3'd3}] = 8'b01100110;
        font_mem[{7'h6E, 3'd4}] = 8'b01100110;
        font_mem[{7'h6E, 3'd5}] = 8'b01100110;
        font_mem[{7'h6E, 3'd6}] = 8'b01100110;
        font_mem[{7'h6E, 3'd7}] = 8'b00000000;

        // o (0x6F)
        font_mem[{7'h6F, 3'd0}] = 8'b00000000;
        font_mem[{7'h6F, 3'd1}] = 8'b00000000;
        font_mem[{7'h6F, 3'd2}] = 8'b00111100;
        font_mem[{7'h6F, 3'd3}] = 8'b01100110;
        font_mem[{7'h6F, 3'd4}] = 8'b01100110;
        font_mem[{7'h6F, 3'd5}] = 8'b01100110;
        font_mem[{7'h6F, 3'd6}] = 8'b00111100;
        font_mem[{7'h6F, 3'd7}] = 8'b00000000;

        // p (0x70)
        font_mem[{7'h70, 3'd0}] = 8'b00000000;
        font_mem[{7'h70, 3'd1}] = 8'b00000000;
        font_mem[{7'h70, 3'd2}] = 8'b01111100;
        font_mem[{7'h70, 3'd3}] = 8'b01100110;
        font_mem[{7'h70, 3'd4}] = 8'b01100110;
        font_mem[{7'h70, 3'd5}] = 8'b01111100;
        font_mem[{7'h70, 3'd6}] = 8'b01100000;
        font_mem[{7'h70, 3'd7}] = 8'b01100000;

        // q (0x71)
        font_mem[{7'h71, 3'd0}] = 8'b00000000;
        font_mem[{7'h71, 3'd1}] = 8'b00000000;
        font_mem[{7'h71, 3'd2}] = 8'b00111110;
        font_mem[{7'h71, 3'd3}] = 8'b01100110;
        font_mem[{7'h71, 3'd4}] = 8'b01100110;
        font_mem[{7'h71, 3'd5}] = 8'b00111110;
        font_mem[{7'h71, 3'd6}] = 8'b00000110;
        font_mem[{7'h71, 3'd7}] = 8'b00000110;

        // r (0x72)
        font_mem[{7'h72, 3'd0}] = 8'b00000000;
        font_mem[{7'h72, 3'd1}] = 8'b00000000;
        font_mem[{7'h72, 3'd2}] = 8'b01111100;
        font_mem[{7'h72, 3'd3}] = 8'b01100110;
        font_mem[{7'h72, 3'd4}] = 8'b01100000;
        font_mem[{7'h72, 3'd5}] = 8'b01100000;
        font_mem[{7'h72, 3'd6}] = 8'b01100000;
        font_mem[{7'h72, 3'd7}] = 8'b00000000;

        // s (0x73)
        font_mem[{7'h73, 3'd0}] = 8'b00000000;
        font_mem[{7'h73, 3'd1}] = 8'b00000000;
        font_mem[{7'h73, 3'd2}] = 8'b00111110;
        font_mem[{7'h73, 3'd3}] = 8'b01100000;
        font_mem[{7'h73, 3'd4}] = 8'b00111100;
        font_mem[{7'h73, 3'd5}] = 8'b00000110;
        font_mem[{7'h73, 3'd6}] = 8'b01111100;
        font_mem[{7'h73, 3'd7}] = 8'b00000000;

        // t (0x74)
        font_mem[{7'h74, 3'd0}] = 8'b00110000;
        font_mem[{7'h74, 3'd1}] = 8'b00110000;
        font_mem[{7'h74, 3'd2}] = 8'b01111100;
        font_mem[{7'h74, 3'd3}] = 8'b00110000;
        font_mem[{7'h74, 3'd4}] = 8'b00110000;
        font_mem[{7'h74, 3'd5}] = 8'b00110000;
        font_mem[{7'h74, 3'd6}] = 8'b00011100;
        font_mem[{7'h74, 3'd7}] = 8'b00000000;

        // u (0x75)
        font_mem[{7'h75, 3'd0}] = 8'b00000000;
        font_mem[{7'h75, 3'd1}] = 8'b00000000;
        font_mem[{7'h75, 3'd2}] = 8'b01100110;
        font_mem[{7'h75, 3'd3}] = 8'b01100110;
        font_mem[{7'h75, 3'd4}] = 8'b01100110;
        font_mem[{7'h75, 3'd5}] = 8'b01100110;
        font_mem[{7'h75, 3'd6}] = 8'b00111110;
        font_mem[{7'h75, 3'd7}] = 8'b00000000;

        // v (0x76)
        font_mem[{7'h76, 3'd0}] = 8'b00000000;
        font_mem[{7'h76, 3'd1}] = 8'b00000000;
        font_mem[{7'h76, 3'd2}] = 8'b01100110;
        font_mem[{7'h76, 3'd3}] = 8'b01100110;
        font_mem[{7'h76, 3'd4}] = 8'b01100110;
        font_mem[{7'h76, 3'd5}] = 8'b00111100;
        font_mem[{7'h76, 3'd6}] = 8'b00011000;
        font_mem[{7'h76, 3'd7}] = 8'b00000000;

        // w (0x77)
        font_mem[{7'h77, 3'd0}] = 8'b00000000;
        font_mem[{7'h77, 3'd1}] = 8'b00000000;
        font_mem[{7'h77, 3'd2}] = 8'b01100011;
        font_mem[{7'h77, 3'd3}] = 8'b01101011;
        font_mem[{7'h77, 3'd4}] = 8'b01111111;
        font_mem[{7'h77, 3'd5}] = 8'b01111111;
        font_mem[{7'h77, 3'd6}] = 8'b00110110;
        font_mem[{7'h77, 3'd7}] = 8'b00000000;

        // x (0x78)
        font_mem[{7'h78, 3'd0}] = 8'b00000000;
        font_mem[{7'h78, 3'd1}] = 8'b00000000;
        font_mem[{7'h78, 3'd2}] = 8'b01100110;
        font_mem[{7'h78, 3'd3}] = 8'b00111100;
        font_mem[{7'h78, 3'd4}] = 8'b00011000;
        font_mem[{7'h78, 3'd5}] = 8'b00111100;
        font_mem[{7'h78, 3'd6}] = 8'b01100110;
        font_mem[{7'h78, 3'd7}] = 8'b00000000;

        // y (0x79)
        font_mem[{7'h79, 3'd0}] = 8'b00000000;
        font_mem[{7'h79, 3'd1}] = 8'b00000000;
        font_mem[{7'h79, 3'd2}] = 8'b01100110;
        font_mem[{7'h79, 3'd3}] = 8'b01100110;
        font_mem[{7'h79, 3'd4}] = 8'b01100110;
        font_mem[{7'h79, 3'd5}] = 8'b00111110;
        font_mem[{7'h79, 3'd6}] = 8'b00000110;
        font_mem[{7'h79, 3'd7}] = 8'b00111100;

        // z (0x7A)
        font_mem[{7'h7A, 3'd0}] = 8'b00000000;
        font_mem[{7'h7A, 3'd1}] = 8'b00000000;
        font_mem[{7'h7A, 3'd2}] = 8'b01111110;
        font_mem[{7'h7A, 3'd3}] = 8'b00001100;
        font_mem[{7'h7A, 3'd4}] = 8'b00011000;
        font_mem[{7'h7A, 3'd5}] = 8'b00110000;
        font_mem[{7'h7A, 3'd6}] = 8'b01111110;
        font_mem[{7'h7A, 3'd7}] = 8'b00000000;

        // : (0x3A)
        font_mem[{7'h3A, 3'd0}] = 8'b00000000;
        font_mem[{7'h3A, 3'd1}] = 8'b00011000;
        font_mem[{7'h3A, 3'd2}] = 8'b00011000;
        font_mem[{7'h3A, 3'd3}] = 8'b00000000;
        font_mem[{7'h3A, 3'd4}] = 8'b00000000;
        font_mem[{7'h3A, 3'd5}] = 8'b00011000;
        font_mem[{7'h3A, 3'd6}] = 8'b00011000;
        font_mem[{7'h3A, 3'd7}] = 8'b00000000;

        // ; (0x3B)
        font_mem[{7'h3B, 3'd0}] = 8'b00000000;
        font_mem[{7'h3B, 3'd1}] = 8'b00011000;
        font_mem[{7'h3B, 3'd2}] = 8'b00011000;
        font_mem[{7'h3B, 3'd3}] = 8'b00000000;
        font_mem[{7'h3B, 3'd4}] = 8'b00000000;
        font_mem[{7'h3B, 3'd5}] = 8'b00011000;
        font_mem[{7'h3B, 3'd6}] = 8'b00011000;
        font_mem[{7'h3B, 3'd7}] = 8'b00110000;

        // . (0x2E)
        font_mem[{7'h2E, 3'd0}] = 8'b00000000;
        font_mem[{7'h2E, 3'd1}] = 8'b00000000;
        font_mem[{7'h2E, 3'd2}] = 8'b00000000;
        font_mem[{7'h2E, 3'd3}] = 8'b00000000;
        font_mem[{7'h2E, 3'd4}] = 8'b00000000;
        font_mem[{7'h2E, 3'd5}] = 8'b00011000;
        font_mem[{7'h2E, 3'd6}] = 8'b00011000;
        font_mem[{7'h2E, 3'd7}] = 8'b00000000;

        // , (0x2C)
        font_mem[{7'h2C, 3'd0}] = 8'b00000000;
        font_mem[{7'h2C, 3'd1}] = 8'b00000000;
        font_mem[{7'h2C, 3'd2}] = 8'b00000000;
        font_mem[{7'h2C, 3'd3}] = 8'b00000000;
        font_mem[{7'h2C, 3'd4}] = 8'b00000000;
        font_mem[{7'h2C, 3'd5}] = 8'b00011000;
        font_mem[{7'h2C, 3'd6}] = 8'b00011000;
        font_mem[{7'h2C, 3'd7}] = 8'b00110000;

        // - (0x2D)
        font_mem[{7'h2D, 3'd0}] = 8'b00000000;
        font_mem[{7'h2D, 3'd1}] = 8'b00000000;
        font_mem[{7'h2D, 3'd2}] = 8'b00000000;
        font_mem[{7'h2D, 3'd3}] = 8'b01111110;
        font_mem[{7'h2D, 3'd4}] = 8'b00000000;
        font_mem[{7'h2D, 3'd5}] = 8'b00000000;
        font_mem[{7'h2D, 3'd6}] = 8'b00000000;
        font_mem[{7'h2D, 3'd7}] = 8'b00000000;

        // + (0x2B)
        font_mem[{7'h2B, 3'd0}] = 8'b00000000;
        font_mem[{7'h2B, 3'd1}] = 8'b00011000;
        font_mem[{7'h2B, 3'd2}] = 8'b00011000;
        font_mem[{7'h2B, 3'd3}] = 8'b01111110;
        font_mem[{7'h2B, 3'd4}] = 8'b00011000;
        font_mem[{7'h2B, 3'd5}] = 8'b00011000;
        font_mem[{7'h2B, 3'd6}] = 8'b00000000;
        font_mem[{7'h2B, 3'd7}] = 8'b00000000;

        // = (0x3D)
        font_mem[{7'h3D, 3'd0}] = 8'b00000000;
        font_mem[{7'h3D, 3'd1}] = 8'b00000000;
        font_mem[{7'h3D, 3'd2}] = 8'b01111110;
        font_mem[{7'h3D, 3'd3}] = 8'b00000000;
        font_mem[{7'h3D, 3'd4}] = 8'b01111110;
        font_mem[{7'h3D, 3'd5}] = 8'b00000000;
        font_mem[{7'h3D, 3'd6}] = 8'b00000000;
        font_mem[{7'h3D, 3'd7}] = 8'b00000000;

        // / (0x2F)
        font_mem[{7'h2F, 3'd0}] = 8'b00000110;
        font_mem[{7'h2F, 3'd1}] = 8'b00001100;
        font_mem[{7'h2F, 3'd2}] = 8'b00011000;
        font_mem[{7'h2F, 3'd3}] = 8'b00110000;
        font_mem[{7'h2F, 3'd4}] = 8'b01100000;
        font_mem[{7'h2F, 3'd5}] = 8'b11000000;
        font_mem[{7'h2F, 3'd6}] = 8'b00000000;
        font_mem[{7'h2F, 3'd7}] = 8'b00000000;

        // ( (0x28)
        font_mem[{7'h28, 3'd0}] = 8'b00001100;
        font_mem[{7'h28, 3'd1}] = 8'b00011000;
        font_mem[{7'h28, 3'd2}] = 8'b00110000;
        font_mem[{7'h28, 3'd3}] = 8'b00110000;
        font_mem[{7'h28, 3'd4}] = 8'b00110000;
        font_mem[{7'h28, 3'd5}] = 8'b00011000;
        font_mem[{7'h28, 3'd6}] = 8'b00001100;
        font_mem[{7'h28, 3'd7}] = 8'b00000000;

        // ) (0x29)
        font_mem[{7'h29, 3'd0}] = 8'b00110000;
        font_mem[{7'h29, 3'd1}] = 8'b00011000;
        font_mem[{7'h29, 3'd2}] = 8'b00001100;
        font_mem[{7'h29, 3'd3}] = 8'b00001100;
        font_mem[{7'h29, 3'd4}] = 8'b00001100;
        font_mem[{7'h29, 3'd5}] = 8'b00011000;
        font_mem[{7'h29, 3'd6}] = 8'b00110000;
        font_mem[{7'h29, 3'd7}] = 8'b00000000;

        // [ (0x5B)
        font_mem[{7'h5B, 3'd0}] = 8'b00111100;
        font_mem[{7'h5B, 3'd1}] = 8'b00110000;
        font_mem[{7'h5B, 3'd2}] = 8'b00110000;
        font_mem[{7'h5B, 3'd3}] = 8'b00110000;
        font_mem[{7'h5B, 3'd4}] = 8'b00110000;
        font_mem[{7'h5B, 3'd5}] = 8'b00110000;
        font_mem[{7'h5B, 3'd6}] = 8'b00111100;
        font_mem[{7'h5B, 3'd7}] = 8'b00000000;

        // ] (0x5D)
        font_mem[{7'h5D, 3'd0}] = 8'b00111100;
        font_mem[{7'h5D, 3'd1}] = 8'b00001100;
        font_mem[{7'h5D, 3'd2}] = 8'b00001100;
        font_mem[{7'h5D, 3'd3}] = 8'b00001100;
        font_mem[{7'h5D, 3'd4}] = 8'b00001100;
        font_mem[{7'h5D, 3'd5}] = 8'b00001100;
        font_mem[{7'h5D, 3'd6}] = 8'b00111100;
        font_mem[{7'h5D, 3'd7}] = 8'b00000000;

        // ? (0x3F)
        font_mem[{7'h3F, 3'd0}] = 8'b00111100;
        font_mem[{7'h3F, 3'd1}] = 8'b01100110;
        font_mem[{7'h3F, 3'd2}] = 8'b00000110;
        font_mem[{7'h3F, 3'd3}] = 8'b00001100;
        font_mem[{7'h3F, 3'd4}] = 8'b00011000;
        font_mem[{7'h3F, 3'd5}] = 8'b00000000;
        font_mem[{7'h3F, 3'd6}] = 8'b00011000;
        font_mem[{7'h3F, 3'd7}] = 8'b00000000;

        // * (0x2A)
        font_mem[{7'h2A, 3'd0}] = 8'b00000000;
        font_mem[{7'h2A, 3'd1}] = 8'b01100110;
        font_mem[{7'h2A, 3'd2}] = 8'b00111100;
        font_mem[{7'h2A, 3'd3}] = 8'b11111111;
        font_mem[{7'h2A, 3'd4}] = 8'b00111100;
        font_mem[{7'h2A, 3'd5}] = 8'b01100110;
        font_mem[{7'h2A, 3'd6}] = 8'b00000000;
        font_mem[{7'h2A, 3'd7}] = 8'b00000000;

        // @ (0x40)
        font_mem[{7'h40, 3'd0}] = 8'b00111100;
        font_mem[{7'h40, 3'd1}] = 8'b01100110;
        font_mem[{7'h40, 3'd2}] = 8'b01101110;
        font_mem[{7'h40, 3'd3}] = 8'b01101010;
        font_mem[{7'h40, 3'd4}] = 8'b01101110;
        font_mem[{7'h40, 3'd5}] = 8'b01100000;
        font_mem[{7'h40, 3'd6}] = 8'b00111100;
        font_mem[{7'h40, 3'd7}] = 8'b00000000;

        // _ (0x5F)
        font_mem[{7'h5F, 3'd0}] = 8'b00000000;
        font_mem[{7'h5F, 3'd1}] = 8'b00000000;
        font_mem[{7'h5F, 3'd2}] = 8'b00000000;
        font_mem[{7'h5F, 3'd3}] = 8'b00000000;
        font_mem[{7'h5F, 3'd4}] = 8'b00000000;
        font_mem[{7'h5F, 3'd5}] = 8'b00000000;
        font_mem[{7'h5F, 3'd6}] = 8'b00000000;
        font_mem[{7'h5F, 3'd7}] = 8'b11111111;

        // ' (0x27)
        font_mem[{7'h27, 3'd0}] = 8'b00011000;
        font_mem[{7'h27, 3'd1}] = 8'b00011000;
        font_mem[{7'h27, 3'd2}] = 8'b00011000;
        font_mem[{7'h27, 3'd3}] = 8'b00000000;
        font_mem[{7'h27, 3'd4}] = 8'b00000000;
        font_mem[{7'h27, 3'd5}] = 8'b00000000;
        font_mem[{7'h27, 3'd6}] = 8'b00000000;
        font_mem[{7'h27, 3'd7}] = 8'b00000000;
    end

endmodule
