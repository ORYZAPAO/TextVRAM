// Text VRAM using BRAM
// Dual-port RAM for CPU write and display read

module text_vram #(
    parameter COLS = 80,            // Number of columns (characters)
    parameter ROWS = 60,            // Number of rows (characters)
    parameter ADDR_WIDTH = 13       // Address width (log2(COLS*ROWS))
)(
    // Display port (read only)
    input  wire                    clk,
    input  wire [ADDR_WIDTH-1:0]   disp_addr,
    output reg  [7:0]              disp_data,

    // CPU port (read/write)
    input  wire                    cpu_clk,
    input  wire                    cpu_we,
    input  wire [ADDR_WIDTH-1:0]   cpu_addr,
    input  wire [7:0]              cpu_wdata,
    output reg  [7:0]              cpu_rdata
);

    // Calculate total memory size
    localparam MEM_SIZE = COLS * ROWS;

    // BRAM for text data
    (* ram_style = "block" *)
    reg [7:0] vram [0:MEM_SIZE-1];

    // Initialize VRAM with spaces
    integer i;
    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            vram[i] = 8'h20;  // Space character
        end
    end

    // Display port - read
    always @(posedge clk) begin
        disp_data <= vram[disp_addr];
    end

    // CPU port - read/write
    always @(posedge cpu_clk) begin
        if (cpu_we) begin
            vram[cpu_addr] <= cpu_wdata;
        end
        cpu_rdata <= vram[cpu_addr];
    end

endmodule
