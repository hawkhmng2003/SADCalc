library ieee;
use ieee.std_logic_1164.all;

entity tb_SAD_Calc is
end tb_SAD_Calc;

architecture tb of tb_SAD_Calc is

    component SAD_Calc
        generic (data_width : integer := 8);
        port (clk       : in std_logic;
              rst       : in std_logic;
              start     : in std_logic;
              done      : out std_logic;
              data_A_in : in std_logic_vector (data_width - 1 downto 0);
              data_B_in : in std_logic_vector (data_width - 1 downto 0);
              W_e       : out std_logic;
              R_e       : out std_logic;
              Z_i       : out std_logic;
              ld_i      : in std_logic;
              subzero   : out std_logic;
              i_enable  : in std_logic;
              data_out  : out std_logic_vector (15 downto 0));
    end component;

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal start     : std_logic := '0';
    signal done      : std_logic;
    signal data_A_in : std_logic_vector (7 downto 0) := (others => '0');
    signal data_B_in : std_logic_vector (7 downto 0) := (others => '0');
    signal W_e       : std_logic;
    signal R_e       : std_logic;
    signal Z_i       : std_logic;
    signal ld_i      : std_logic := '0';
    signal subzero   : std_logic;
    signal i_enable  : std_logic := '0';
    signal data_out  : std_logic_vector (15 downto 0);

    constant TbPeriod : time := 1000 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : SAD_Calc
        generic map (data_width => 8)
        port map (clk       => clk,
                  rst       => rst,
                  start     => start,
                  done      => done,
                  data_A_in => data_A_in,
                  data_B_in => data_B_in,
                  W_e       => W_e,
                  R_e       => R_e,
                  Z_i       => Z_i,
                  ld_i      => ld_i,
                  subzero   => subzero,
                  i_enable  => i_enable,
                  data_out  => data_out);

    TbClock <= not TbClock after TbPeriod / 2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

    stimuli : process
    begin
        start <= '0';
        data_A_in <= (others => '0');
        data_B_in <= (others => '0');
        ld_i <= '0';
        i_enable <= '0';

        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        wait for 100 * TbPeriod;
        
        start <= '1';
        data_A_in <= "00001111";
        data_B_in <= "00000001";
        wait for 10 * TbPeriod;

        start <= '0';

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_SAD_Calc of tb_SAD_Calc is
    for tb
    end for;
end cfg_tb_SAD_Calc;
