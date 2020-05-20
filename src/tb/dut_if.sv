interface dut_if;
  bit [31 : 0]  d_in      = 0;
  bit           d_in_vld  = 0;
  bit           start     = 0;
  bit [15 : 0]  crc;
  bit           crc_vld;
endinterface