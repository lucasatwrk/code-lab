#include "Vrom.h"
#include <memory>
#include <cstdio>

int main(int argc, char*argv[]) {
    std::unique_ptr<Vrom> dut(new Vrom);

    const int DEPTH = 16;
    for (int i = 0; i < DEPTH; i++) {
        dut->addr = i;
        dut->eval();
        printf("0x%02X: %02X\n", i, dut->data);
    }
    return 0;
}