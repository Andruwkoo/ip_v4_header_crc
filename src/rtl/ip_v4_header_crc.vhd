library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ip_v4_header_crc is
    port (
        clk   : in std_logic;
        reset : in std_logic;

        d_in        : in std_logic_vector(31 downto 0);
        d_in_vld    : in std_logic;
        start       : in std_logic;

        crc         : out std_logic_vector(15 downto 0);
        crc_vld     : out std_logic
    );
end entity;

architecture rtl of ip_v4_header_crc is

    signal acc          : std_logic_vector(19 downto 0) := (others => '0');
    signal carry_acc    : std_logic_vector(15 downto 0) := (others => '0');
    signal cnt          : std_logic_vector(4 downto 0)  := (others => '0');
    signal work         : std_logic;
    signal carry        : std_logic;
    signal carry_z      : std_logic;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            work <= '0';
        elsif rising_edge(clk) then
            if start = '1' and work = '0' then
                work  <= '1';
            elsif cnt = 4 and d_in_vld = '1' then
                work  <= '0';
                carry <= '1';
            else
                carry <= '0';
            end if;

            if start = '1' and work = '0' then
                cnt <= (others => '0');
            elsif work = '1' and d_in_vld = '1' then
                cnt <= cnt + x"1";
            end if;
        end if;
    end process;

    process(clk, reset)
        variable tmp_carry_acc : std_logic_Vector(16 downto 0);
    begin
        if reset = '1' then
            carry_z <= '0';
        elsif rising_edge(clk) then
            carry_z <= carry;

            if work = '0' then
                acc <= (others => '0');
            elsif cnt /= 2 and d_in_vld = '1' then
                acc <= acc + d_in(15 downto 0) + d_in(31 downto 16);
            elsif d_in_vld = '1' then
                acc <= acc + d_in(31 downto 16);
            end if;

            if carry = '1' then
                tmp_carry_acc := ext(("0" & acc(15 downto 0)) + acc(19 downto 16), tmp_carry_acc'length);
                carry_acc <= tmp_carry_acc(15 downto 0) + tmp_carry_acc(16);
            end if;

            if carry_z = '1' then
                crc     <= not carry_acc;
                crc_vld <= '1';
            else
                crc_vld <= '0';
            end if;
        end if;
    end process;

end architecture;