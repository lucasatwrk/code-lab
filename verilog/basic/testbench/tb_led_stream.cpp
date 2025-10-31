#include "Vled_stream.h"
#include <memory>
#include <cstdio>
#include <verilated_vcd_c.h>
using namespace std;

#ifndef BASE_FREQ
#define BASE_FREQ    50000000
#endif
#define ACTIVE_MS    100
#define GROUP_SIZE   4
#define GROUP        0

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

    std::unique_ptr<Vled_stream> dut(new Vled_stream);
    VcdFilePtr vfp;
    bool enable_vcd = (getenv("DUMP_VCD") != nullptr);
    if (enable_vcd) {
        vfp.reset(new VerilatedVcdC());
        dut->trace(vfp.get(), 0);
        vfp->open(getenv("DUMP_VCD"));
        printf("[VCD] %s\n", getenv("DUMP_VCD"));
    }
    vluint64_t main_time = 0;

    constexpr int ACTIVE_CYCLE = BASE_FREQ / 1000 * ACTIVE_MS;
    const int CYCLE_RANGE = 10;
    printf("[BASE_FREQ] %d\n", BASE_FREQ);

    dut->rst_n = 1;
    while(main_time < BASE_FREQ && !Verilated::gotFinish()) {
        if(main_time == (int)(BASE_FREQ * 0.7)) {
            dut->rst_n = 0;
            dut->eval();
            dut->rst_n = 1;
        }
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        if ((main_time % ACTIVE_CYCLE) < CYCLE_RANGE || (main_time % ACTIVE_CYCLE) > (ACTIVE_CYCLE - CYCLE_RANGE)) {
            if(enable_vcd) {
                vfp->dump(main_time);
            }
            printf("CYCLE: %ld, ON[%d, %d, %d, %d]\n", main_time, (dut->on & 8) >> 3, (dut->on & 4) >> 2, (dut->on & 2) >> 1, dut->on & 1);
        }
        main_time++;
    }

    dut->final();
    
    return 0;
}
