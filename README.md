# Programmable digital line

## Verilog Quick Reference Guide
https://sutherland-hdl.com/pdfs/verilog_2001_ref_guide.pdf


https://athena.ecs.csus.edu/~changw/class_docs/VerilogManual/delays.html
https://web.eecs.umich.edu/~prabal/teaching/eecs373-f10/labs/lab5/index.html

## TEST
### LS7212

https://www.fpga4student.com/2017/01/programmable-digital-delay-timer-in-Verilog.html

```
cd test/LS7212
iverilog -o ls7212 LS7212_TB.v LS7212.v
vvp ls7212
launch App gtkwave
    File New Tab
        Open test/LS7212/sim_out.vcd

```


https://www.maximintegrated.com/en/design/technical-documents/app-notes/1/107.html


## Module Design

- Input Clock : 100Mhz /period is 10ns

- Input: trigger ( 2Hz External or Internal Trigger )

- Input: Enable (High is active)

- Output: out[0..7]
    - dl/wb is 32bit or 4Bytes register
    - dl[0..7] :delay time between trigger and out[0..7]                          unit is :10ns 
    - wd[0..7] :delay time between rising edge and falling edge of out[0..7]      unit is :10ns




