// Text VRAM using BRAM
// Dual-port RAM for CPU write and display read


//
// Page Size = [COLS x ROWS] byte
//
// 000 +-------------------------------+
//     | Page 0: Character(ASCII code) |
//     +-------------------------------+
//     | Page 1: Red                   |
//     +-------------------------------+
//     | Page 2: GREEN                 |
//     +-------------------------------+
//     | Page 3: BLUE                  |
//     +-------------------------------+
////
module text_vram #(
    parameter COLS = 80,            // Number of columns (characters)
    parameter ROWS = 60,            // Number of rows (characters)
    parameter ADDR_WIDTH = $clog2((COLS * ROWS) * 4)   // Address width  (log2(COLS*ROWSi*4))
  )(
    // Display port (read only)
    input  wire                    clk,
    input  wire [ADDR_WIDTH-1:0]   disp_addr,
    output reg  [7:0]              disp_data,
    output reg  [7:0]              disp_r,
    output reg  [7:0]              disp_g,
    output reg  [7:0]              disp_b,

    // CPU port (read/write)
    input  wire                    cpu_clk,
    input  wire                    cpu_we,
    input  wire [ADDR_WIDTH-1:0]   cpu_addr,
    input  wire [7:0]              cpu_wdata,
    output reg  [7:0]              cpu_rdata
);

    // Calculate total memory size
    localparam PAGE_SIZE    = COLS * ROWS;
    localparam NUM_OF_PAGES = 4;
    localparam MEM_SIZE     = PAGE_SIZE * NUM_OF_PAGES;  

    // 
    wire [ADDR_WIDTH-1:0] ind;

    // BRAM for text data
    (* ram_style = "block" *)
    reg [7:0] vram [0:MEM_SIZE-1];

    // Initialize VRAM with spaces
    integer i,j;
    initial begin
        for (i = 0; i < PAGE_SIZE; i = i + 1) begin
            vram[i] = 8'h20;             // Space character
            vram[i+PAGE_SIZE]   = 24'hFF_FF_FF;  // Red 
            vram[i+PAGE_SIZE*2] = 24'hFF_FF_FF;  // Green 
            vram[i+PAGE_SIZE*3] = 24'hFF_FF_FF;  // Blue 
          end
    end

    // Display port - read
    assign ind[ADDR_WIDTH-1:0] = disp_addr % PAGE_SIZE; 
    always @(posedge clk) begin
        disp_data <= vram[ind];
        disp_r    <= vram[ind+PAGE_SIZE];
        disp_g    <= vram[ind+PAGE_SIZE * 2];
        disp_b    <= vram[ind+PAGE_SIZE * 3];
    end

    // CPU port - read/write
    always @(posedge cpu_clk) begin  
      if (cpu_we) begin
            vram[cpu_addr] <= cpu_wdata;
        end
        cpu_rdata <= vram[cpu_addr];
    end

endmodule
