#include "Vkeypad.h"
#include <memory>
#include <cstdio>
#include <cmath>
#include <vector>
#include <verilated_vcd_c.h>

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

    std::unique_ptr<Vkeypad> dut(new Vkeypad);
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
    for(int i = 0; i < 32; i++) {
        dut->clk = 0;
        dut->row = (i % 3 == 0) ? ~(1 << ((i % 16) / 4)) : 0xF;
        dut->eval();
        if(enable_vcd) { vfp->dump(main_time); }
        main_time++;
        dut->clk = 1;
        dut->eval();
        if(enable_vcd) { vfp->dump(main_time); }
        main_time++;
    }

    dut->final();
    
    return 0;
}