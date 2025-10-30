#include "Vram.h"
#include <memory>
#include <cstdio>

int main(int argc, char*argv[]) {
    std::unique_ptr<Vram> dut(new Vram);

    dut->clk = 0;
    dut->rst = 0;
    dut->eval();
    dut->rst = 1;
    dut->eval();
    const int DEPTH = 8;
    const int DATA_BASE = 0xA;
    for (int i = 0; i < DEPTH; i++) {
        dut->clk = 1;
        dut->we = 1;
        dut->addr = i;
        dut->din = DATA_BASE + i;
        printf("[write] 0x%02X <= %02X\n", i, dut->din);
        dut->eval();
        dut->clk = 0;
        dut->eval();
    }
    for (int i = 0; i < DEPTH; i++) {
        dut->clk = 1;
        dut->we = 0;
        dut->addr = i;
        dut->eval();
        printf("[read] 0x%02X: %02X\n", i, dut->dout);
        dut->clk = 0;
        dut->eval();
    }
    printf(" --- reset ---\n");
    dut->rst = 0;
    dut->eval();
    dut->rst = 1;
    dut->eval();
    for (int i = 0; i < DEPTH; i++) {
        dut->clk = 1;
        dut->addr = i;
        dut->eval();
        printf("0x%02X: %02X\n", i, dut->dout);
        dut->clk = 0;
        dut->eval();
    }
    return 0;
}