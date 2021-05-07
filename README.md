# Programmable digital line

[test]
    [LS7212]
    https://www.fpga4student.com/2017/01/programmable-digital-delay-timer-in-Verilog.html
    cd test/LS7212
    iverilog -o ls7212 LS7212_TB.v LS7212.v
    vvp ls7212
    launch App gtkwave
        File New Tab
            Open test/LS7212/sim_out.vcd

    


    https://www.maximintegrated.com/en/design/technical-documents/app-notes/1/107.html


Input Clock : 100Mhz /period is 10ns

Input: trigger ( 2Hz External or Internal Trigger )

Input: Enable (High is active)

Output: out[0..7]
    delay_a/b is 32bit or 4Bytes register
    delay_a[0..7] :delay time between trigger and out[0..7]                          unit is :10ns 
    delay_b[0..7] :delay time between rising edge and falling edge of out[0..7]      unit is :10ns




