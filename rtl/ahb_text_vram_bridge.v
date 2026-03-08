// =========================================================
// AHB to Text VRAM Bridge Module
//
// AHB (AMBA 2.0) slave interface to Text VRAM CPU port
// Converts 32-bit AHB transactions to 8-bit VRAM accesses
//
// Licensed under the MIT Licensed
//
// Copyright (c) 2026 by ORYZA (https://github.com/ORYZAPAO)
//
// =========================================================

module ahb_text_vram_bridge #(
    parameter BASE_ADDR  = 32'h40000000,  // AHB base address
    parameter ADDR_WIDTH = 15,             // VRAM address width (80x60x4 = 19200 = 0x4B00)
    parameter MEM_SIZE   = 32'h4B00        // Total VRAM size in bytes
)(
    // AHB slave interface
    input  wire        HCLK,
    input  wire        HRESETn,
    input  wire        HSEL,               // Slave select
    input  wire [31:0] HADDR,              // Address bus
    input  wire [31:0] HWDATA,             // Write data bus
    input  wire        HWRITE,             // Write/read transaction
    input  wire [1:0]  HTRANS,             // Transfer type
    input  wire [2:0]  HSIZE,              // Transfer size
    input  wire [2:0]  HBURST,             // Burst type
    input  wire        HREADY,             // Transfer done (from previous slave)

    output reg  [31:0] HRDATA,             // Read data bus
    output reg         HREADYOUT,          // Transfer done
    output reg  [1:0]  HRESP,              // Transfer response

    // VRAM CPU interface
    output wire        cpu_clk,            // CPU clock (= HCLK)
    output reg         cpu_we,             // Write enable
    output reg  [ADDR_WIDTH-1:0] cpu_addr, // Address
    output reg  [7:0]  cpu_wdata,          // Write data
    input  wire [7:0]  cpu_rdata           // Read data
);

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
    localparam HBURST_WRAP8  = 3'b100;
    localparam HBURST_INCR8  = 3'b101;
    localparam HBURST_WRAP16 = 3'b110;
    localparam HBURST_INCR16 = 3'b111;

    // AHB transfer size
    localparam HSIZE_BYTE = 3'b000;  // 8-bit
    localparam HSIZE_HALF = 3'b001;  // 16-bit
    localparam HSIZE_WORD = 3'b010;  // 32-bit

    // AHB response
    localparam HRESP_OKAY  = 2'b00;
    localparam HRESP_ERROR = 2'b01;

    // Address phase registers (pipeline stage)
    reg [31:0] addr_reg;
    reg        write_reg;
    reg [2:0]  size_reg;
    reg        trans_valid_reg;
    reg        error_reg;
    reg        error_resp_reg;  // Second cycle of ERROR response

    // Address decode
    wire [31:0] addr_offset;
    wire        addr_valid;
    wire        trans_valid;
    wire        wrap_burst;
    wire        addr_error;   // Combined error signal

    // Byte lane selection
    wire [1:0] byte_lane;

    // CPU clock is same as AHB clock (no CDC required)
    assign cpu_clk = HCLK;

    // Detect valid transfer
    assign trans_valid = HSEL && HREADY && (HTRANS == HTRANS_NONSEQ || HTRANS == HTRANS_SEQ);

    // Check for WRAP burst (not supported)
    assign wrap_burst = (HBURST == HBURST_WRAP4 || HBURST == HBURST_WRAP8 || HBURST == HBURST_WRAP16);

    // Address decode logic
    assign addr_offset = HADDR - BASE_ADDR;
    assign addr_valid  = (HADDR >= BASE_ADDR) && (addr_offset < MEM_SIZE);

    // Combined error detection
    assign addr_error = !addr_valid || wrap_burst;

    // Byte lane from address
    assign byte_lane = addr_reg[1:0];

    //=========================================================
    // Address Phase Pipeline Register
    // Captures control signals during address phase
    //=========================================================
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            addr_reg        <= 32'h0;
            write_reg       <= 1'b0;
            size_reg        <= 3'b0;
            trans_valid_reg <= 1'b0;
            error_reg       <= 1'b0;
            error_resp_reg  <= 1'b0;
        end else begin
            if (trans_valid) begin
                // Capture address phase
                addr_reg        <= HADDR;
                write_reg       <= HWRITE;
                size_reg        <= HSIZE;
                trans_valid_reg <= 1'b1;
                // Check for errors
                error_reg       <= addr_error;
            end else begin
                trans_valid_reg <= 1'b0;
                error_reg       <= 1'b0;
            end

            // Second cycle of ERROR response
            error_resp_reg <= error_reg;
        end
    end

    //=========================================================
    // VRAM Address Generation
    //=========================================================
    always @(*) begin
        cpu_addr = addr_reg[ADDR_WIDTH-1:0];
    end

    //=========================================================
    // Write Data Path (32-bit AHB -> 8-bit VRAM)
    //=========================================================
    always @(*) begin
        case (size_reg)
            HSIZE_BYTE: begin
                // Select appropriate byte based on address
                case (byte_lane)
                    2'b00: cpu_wdata = HWDATA[7:0];
                    2'b01: cpu_wdata = HWDATA[15:8];
                    2'b10: cpu_wdata = HWDATA[23:16];
                    2'b11: cpu_wdata = HWDATA[31:24];
                endcase
            end
            HSIZE_HALF: begin
                // Halfword access - use lower byte of selected halfword
                case (byte_lane[1])
                    1'b0: cpu_wdata = HWDATA[7:0];
                    1'b1: cpu_wdata = HWDATA[23:16];
                endcase
            end
            HSIZE_WORD: begin
                // Word access - use lowest byte
                cpu_wdata = HWDATA[7:0];
            end
            default: begin
                cpu_wdata = HWDATA[7:0];
            end
        endcase
    end

    //=========================================================
    // Write Enable Generation (Combinational)
    // Assert during data phase for write transactions
    //=========================================================
    always @(*) begin
        // Write enable asserted during data phase
        if (trans_valid_reg && write_reg && !error_reg) begin
            cpu_we = 1'b1;
        end else begin
            cpu_we = 1'b0;
        end
    end

    //=========================================================
    // Read Data Path (8-bit VRAM -> 32-bit AHB)
    // cpu_rdata is combinational, so we can read it immediately
    //=========================================================
    always @(*) begin
        if (trans_valid_reg && !write_reg && !error_reg) begin
            // Read transaction - align data based on size and address
            case (size_reg)
                HSIZE_BYTE: begin
                    // Place byte in appropriate lane
                    case (byte_lane)
                        2'b00: HRDATA = {24'h0, cpu_rdata};
                        2'b01: HRDATA = {16'h0, cpu_rdata, 8'h0};
                        2'b10: HRDATA = {8'h0, cpu_rdata, 16'h0};
                        2'b11: HRDATA = {cpu_rdata, 24'h0};
                    endcase
                end
                HSIZE_HALF: begin
                    // Place byte in appropriate halfword
                    case (byte_lane[1])
                        1'b0: HRDATA = {16'h0, 8'h0, cpu_rdata};
                        1'b1: HRDATA = {8'h0, cpu_rdata, 16'h0};
                    endcase
                end
                HSIZE_WORD: begin
                    // Place in lowest byte
                    HRDATA = {24'h0, cpu_rdata};
                end
                default: begin
                    HRDATA = {24'h0, cpu_rdata};
                end
            endcase
        end else begin
            HRDATA = 32'h0;
        end
    end

    //=========================================================
    // AHB Response Generation (Combinational)
    // ERROR response takes 2 cycles per AHB spec
    //=========================================================
    always @(*) begin
        if (error_reg || error_resp_reg) begin
            HRESP = HRESP_ERROR;
        end else begin
            HRESP = HRESP_OKAY;
        end
    end

    //=========================================================
    // HREADYOUT Generation (Combinational)
    // Hold low during first cycle of ERROR response
    //=========================================================
    always @(*) begin
        // Hold HREADYOUT low during first ERROR cycle
        if (error_reg && !error_resp_reg) begin
            HREADYOUT = 1'b0;
        end else begin
            HREADYOUT = 1'b1;
        end
    end

endmodule
