module tb_top();

  `define DUT ip_v4_header_crc
  `include "dut_if.sv"

  logic clk;
  logic reset;

  dut_if mi();

  `DUT DUT (
    .clk      (clk),
    .reset    (reset),

    .d_in     (mi.d_in),
    .d_in_vld (mi.d_in_vld),
    .start    (mi.start),

    .crc      (mi.crc),
    .crc_vld  (mi.crc_vld)
  );

  initial begin
    bit [31:0] pkt [];

    reset = 0;
    clk = 0;
    #10
    reset = 1;
    #50
    @(posedge clk);
    reset = 0;

    test_packet(pkt);
    send_data(pkt);
    test_packet(pkt);
    send_data(pkt);
    test_packet(pkt);
    send_data(pkt);
    test_packet(pkt);
    send_data(pkt);
  end

  task send_data(bit [31:0] packet []);
    mi.start = 1;
    @(posedge clk);
    mi.start = 0;
    for (int i = 0; i < packet.size(); i += 1) begin
      mi.d_in = packet[i];
      mi.d_in_vld = 1;
      @(posedge clk);
    end
    mi.d_in_vld = 0;
  endtask

  task test_packet(output bit [31 : 0] packet []);
    bit [31:0] pkt [];

    pkt = new[8];
    pkt = '{32'h4500_0073, 32'h0000_4000, 32'h4011_b861, 32'hc0a8_0001, 32'hc0a8_00c7, 32'h0035_e97c, 32'h005f_279f, 32'h1e4b_8180};

    packet = pkt;
  endtask

  always #5ns clk = ~clk;

endmodule