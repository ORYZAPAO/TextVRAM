// =========================================================
// Text VRAM Controller 
//
// Text VRAM using BRAM
// Dual-port RAM for CPU write and display read
//
// Licensed under the MIT Licensed
//
// Copyright (c) 2026 by ORYZA (https://github.com/ORYZAPAO) 
//
// =========================================================

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
    //parameter ADDR_WIDTH = $clog2((COLS * ROWS) * 4)   // AddreVss width  (log2(COLS*ROWSi*4)u)    //parameter ADDR_WIDTH = $clog2((COLS * ROWS) * 4)   // Address width  (log2(COLS*ROWSi*4))
    parameter ADDR_WIDTH = 15   // AddreVss width  (log2(COLS*ROWSi*4)u)    //parameter ADDR_WIDTH = $clog2((COLS * ROWS) * 4)   // Address width  (log2(COLS*ROWSi*4))
  )(
    // Display port (read only)
    input  wire                    clk,
    input  wire [ADDR_WIDTH-1:0]   vram_addr,
    output reg  [7:0]              vram_data,
    output reg  [7:0]              r,
    output reg  [7:0]              g,
    output reg  [7:0]              b,

    // CPU port (read/write)
    input  wire                    cpu_clk,
    input  wire                    cpu_we,
    input  wire [ADDR_WIDTH-1:0]   cpu_addr,
    input  wire [7:0]              cpu_wdata,
    output wire [7:0]              cpu_rdata
);

    // Calculate total memory size
    localparam PAGE_SIZE    = COLS * ROWS;
    localparam NUM_OF_PAGES = 4;
    localparam MEM_SIZE     = PAGE_SIZE;  

    // 
    wire [ADDR_WIDTH-1:0] vram_offset;
    wire [ADDR_WIDTH-1:0] cpu_offset;

//------------------------------------------------------------- 
//
// VRAM
//
//-------------------------------------------------------------

    // BRAM for text data
    (* ram_style = "block" *) reg [7:0] vram [0:MEM_SIZE-1];
    (* ram_style = "block" *) reg [7:0] vram_r [0:MEM_SIZE-1];
    (* ram_style = "block" *) reg [7:0] vram_g [0:MEM_SIZE-1];
    (* ram_style = "block" *) reg [7:0] vram_b [0:MEM_SIZE-1];

    // Initialize VRAM with spaces
    integer i,j;
    initial begin
        for (i = 0; i < PAGE_SIZE; i = i + 1) begin
            vram[i]   = 8'h20;  // " " SPC
            vram_r[i] = 8'hFF;  // Red 
            vram_g[i] = 8'hFF;  // Green 
            vram_b[i] = 8'hFF;  // Blue 
          end
    end

//------------------------------------------------------------- 
//
// CPU
//
//-------------------------------------------------------------

    // CPU Address Decorder
    assign vram_en   =                               (cpu_addr < PAGE_SIZE )  ; 
    assign vram_r_en = ((cpu_addr >= PAGE_SIZE  ) && (cpu_addr < PAGE_SIZE*2));
    assign vram_g_en = ((cpu_addr >= PAGE_SIZE*2) && (cpu_addr < PAGE_SIZE*3));
    assign vram_b_en = ((cpu_addr >= PAGE_SIZE*3) && (cpu_addr < PAGE_SIZE*4));
    
    // CPU port - write
    assign cpu_offset = cpu_addr % PAGE_SIZE;

    always @(posedge cpu_clk) begin  
      if (cpu_we) begin        
        vram[cpu_offset]   <= (vram_en  ) ? cpu_wdata : vram[cpu_offset];
        vram_r[cpu_offset] <= (vram_r_en) ? cpu_wdata : vram_r[cpu_offset];
        vram_g[cpu_offset] <= (vram_g_en) ? cpu_wdata : vram_g[cpu_offset];
        vram_b[cpu_offset] <= (vram_b_en) ? cpu_wdata : vram_b[cpu_offset];
      end
      else begin
        vram[cpu_offset]   <= vram[cpu_offset];
        vram_r[cpu_offset] <= vram_r[cpu_offset];
        vram_g[cpu_offset] <= vram_g[cpu_offset];
        vram_b[cpu_offset] <= vram_b[cpu_offset];
      end
    end

    // CPU port - read
  //  always_comb begin  
  //      cpu_rdata =                               (cpu_addr < PAGE_SIZE )   ? vram[cpu_offset]   :
  //                  ((cpu_addr >= PAGE_SIZE  ) && (cpu_addr < PAGE_SIZE*2)) ? vram_r[cpu_offset] :
  //                  ((cpu_addr >= PAGE_SIZE*2) && (cpu_addr < PAGE_SIZE*3)) ? vram_g[cpu_offset] :
  //                  ((cpu_addr >= PAGE_SIZE*3) && (cpu_addr < PAGE_SIZE*4)) ? vram_b[cpu_offset] :
  //                  8'h00;
  //  end
    assign cpu_rdata = (vram_en  ) ? vram[cpu_offset]   :
                       (vram_r_en) ? vram_r[cpu_offset] :
                       (vram_g_en) ? vram_g[cpu_offset] :
                       (vram_b_en) ? vram_b[cpu_offset] :
                       8'h00;


//------------------------------------------------------------- 
//
//  VRAM Out
//
//-------------------------------------------------------------

    // Display port - read
    assign vram_offset[ADDR_WIDTH-1:0] = vram_addr % PAGE_SIZE; 
    always @(posedge clk) begin
        vram_data <= vram[vram_offset];
        r    <= vram_r[vram_offset];
        g    <= vram_g[vram_offset];
        b    <= vram_b[vram_offset];
    end

// for Debuf
//wire [7:0] dbg_vran000 = vram[0]; 
//wire [7:0] dbg_vran001 = vram[1]; 

  endmodule
