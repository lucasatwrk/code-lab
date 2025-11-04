#include "Vsegment_driver.h"
#include <memory>
#include <cstdio>
#include <cmath>
#include <verilated_vcd_c.h>
using namespace std;

constexpr int SIMU_LOOP = 1000;
constexpr int NUM_COUNT = 16;
const int BCD_MAP[NUM_COUNT] = {
        0x3f, // 0
        0x06, // 1
        0x5b, // 2
        0x4f, // 3
        0x66, // 4
        0x6d, // 5
        0x7d, // 6
        0x07, // 7
        0x7f, // 8
        0x6f, // 9
        0x77, // a
        0x7c, // b
        0x39, // c
        0x5e, // d
        0x79, // e
        0x71  // f
};

struct VcdFileDeleter {
    void operator()(VerilatedVcdC* tfp) const {
        if (tfp) {
            tfp->close();
        }
    }
};
using VcdFilePtr = std::unique_ptr<VerilatedVcdC, VcdFileDeleter>;

int main(int argc, char*argv[]) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    std::unique_ptr<Vsegment_driver> dut(new Vsegment_driver);
    VcdFilePtr vfp;
    bool enable_vcd = (getenv("DUMP_VCD") != nullptr);
    if (enable_vcd) {
        vfp.reset(new VerilatedVcdC());
        dut->trace(vfp.get(), 0);
        vfp->open(getenv("DUMP_VCD"));
        printf("[VCD] %s\n", getenv("DUMP_VCD"));
    }
    vluint64_t main_time = 0;

    dut->clk = 0;
    dut->num = 123456;
    dut->dp = 0b101011;
    for(int i = 0; i < SIMU_LOOP; i++, main_time++) {
        dut->clk = 1;
        dut->eval();
        dut->clk = 0;
        dut->eval();
        printf("[%03d] NUM: %06d, DP: %06b, SEL: %06b(%d), DIG[NUM]: %02X, DIG[DP]: %d\n", i, dut->num, dut->dp, dut->sel, (uint8_t)log2(dut->sel) + 1, (dut->dig & 0x7F), (dut->dig & 0x80) >> 7);

        if(enable_vcd) {
            vfp->dump(main_time);
        }
    }

    dut->final();
    
    return 0;
}
