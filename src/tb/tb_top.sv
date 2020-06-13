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
    bit [15:0] checksum;
    int errors;

    reset = 0;
    clk = 0;
    #10
    reset = 1;
    #50
    @(posedge clk);
    reset = 0;

    errors = 0;
    for (int i = 0; i < 10000; i += 1) begin
      if (i == 0) begin
        gold_packet(pkt);
      end else begin
        random_packet(pkt);
      end
      fork
        send_data(pkt);
        recv_checksum(checksum);
      join
      update_pkt(pkt, checksum);
      errors += verifying_checksum(pkt);
    end

    if (errors == 0) begin
      $display("TESTS PASSED SUCCESSFULLY WITH 0 ERRORS!");
    end else begin
      $display("TESTS FAILED WITH %0d ERRORS!", errors);
    end
    $stop;
  end

  task send_data(bit [31:0] packet [], bit enable_delays = 0);
    mi.start = 1;
    @(posedge clk);
    mi.start = 0;
    for (int i = 0; i < packet.size(); i += 1) begin
      if (enable_delays == 1) begin
        repeat($urandom()%10) @(posedge clk);
      end
      mi.d_in = packet[i];
      mi.d_in_vld = 1;
      @(posedge clk);
      mi.d_in_vld = 0;
    end
    mi.d_in_vld = 0;
  endtask

  task gold_packet(output bit [31 : 0] packet []);
    bit [31:0] pkt [];

    pkt = new[8];
    pkt = '{32'h4500_0073, 32'h0000_4000, 32'h4011_b861, 32'hc0a8_0001, 32'hc0a8_00c7, 32'h0035_e97c, 32'h005f_279f, 32'h1e4b_8180};

    packet = pkt;
  endtask

  task random_packet(output bit [31 : 0] packet []);
    bit [31:0] pkt [];
    int pkt_size;

    pkt_size = ($urandom() % 1019) + 5;
    pkt = new[pkt_size];
    for (int i = 0; i < pkt_size; i += 1) begin
      pkt[i] = $urandom();
    end
    
    packet = pkt;
  endtask

  task recv_checksum(output bit [15:0] checksum);
    @(posedge clk iff mi.crc_vld == 1);
    checksum = mi.crc;
  endtask

  task automatic update_pkt(ref bit [31:0] pkt [], input bit [15:0] checksum);
    pkt[2][15:0] = checksum;
  endtask
  
  function int verifying_checksum(bit [31:0] pkt []);
    int sum;

    sum = 0;
    for (int i = 0; i < 5; i += 1) begin
      sum += pkt[i][15:0] + pkt[i][31:16];
    end
    sum = sum[15:0] + sum[31:16];
    if (sum == 16'hFFFF) begin
      // $display(">>> %8tps | Header checksum is correct.", $time());
      return 0;
    end else begin
      $display("Received packet: %p", pkt);
      $error(">>> %8tps | Header checksum is incorrect.", $time());
      return 1;
    end
  endfunction

  always #5ns clk = ~clk;

endmodule