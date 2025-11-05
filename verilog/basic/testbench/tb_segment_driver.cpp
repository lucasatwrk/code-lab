#include "Vsegment_driver.h"
#include <memory>
#include <cstdio>
#include <cmath>
#include <vector>
#include <verilated_vcd_c.h>
using namespace std;

#ifndef BASE_FREQ
#define BASE_FREQ    50000000
#endif
constexpr int ACTIVE_RATE = 100;
constexpr int ACTIVE_CYCLE = BASE_FREQ / ACTIVE_RATE;
constexpr int FULL_CYCLE = ACTIVE_CYCLE * 6;
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

struct ErrInfo {
    int cycle;
    int dut_dig;
    int dut_sel;
    int exp_dig;
    int exp_num;
    int exp_dp;
    ErrInfo(int cycle, int dut_dig, int dut_sel, int exp_dig, int exp_num, int exp_dp) : 
        cycle(cycle), dut_dig(dut_dig), dut_sel(dut_sel), exp_dig(exp_dig), exp_num(exp_num), exp_dp(exp_dp) {}
};

int bcd(int num, int dig) {
    return (int)(num / pow(10, dig)) % 10;
}

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
    vector<unique_ptr<ErrInfo>> err_list;

    dut->clk = 0;
    dut->num = 123456;
    dut->dp = 0b101011;
    if(enable_vcd) { vfp->dump(main_time); }
    for(int i = 0; i < BASE_FREQ; i++) {
        dut->clk = 1;
        dut->eval();
        main_time++;
        if(enable_vcd) { vfp->dump(main_time); }

        dut->clk = 0;
        dut->eval();
        main_time++;

        const auto sel_id = (uint8_t)log2(dut->sel);
        const auto sel_no = sel_id + 1;
        const auto dig_num = dut->dig & 0x7F;
        const auto dig_dp = (dut->dig & 0x80) >> 7;
        const auto exp_dig = (i % FULL_CYCLE) / ACTIVE_CYCLE;
        const auto exp_num = BCD_MAP[bcd(dut->num, exp_dig)];
        const auto exp_dp = (dut->dp >> exp_dig) & 1;
        printf("EXP_dig: %d, Exp_num: %d, EXP_seg: %X\n", exp_dig, bcd(dut->num, exp_dig), exp_num);
        printf("[%03d] NUM: %06d, DP: %06b", i, dut->num, dut->dp);
        printf(", SEL: %06b(%d)", dut->sel, sel_no);
        const auto num_pass = (dig_num == exp_num);
        printf(", DIG[NUM]: %02X (%s)", dig_num, num_pass ? "PASS" : "ERR");
        const auto dp_pass = (dig_dp == exp_dp);
        printf(", DIG[DP]: %d (%s)", dig_dp, dp_pass ? "PASS" : "ERR");
        printf("\n");

        if(!(num_pass && dp_pass)) {
            ErrInfo ei = { i, dut->dig, dut->sel, exp_dig, exp_num, exp_dp };
            auto err = make_unique<ErrInfo>(ei);
            err_list.emplace_back(move(err));
        }

        if(enable_vcd) { vfp->dump(main_time); }
    }

    dut->final();

    printf(" --- \nError cycles: %ld\n", err_list.size());
    if(getenv("LIST_ERR") != nullptr) {
        for(auto &ei : err_list) {
            printf("Cycle: %d, DIG: %02X, SEL: %06b, EXP[dig]: %d, EXP[num]: %d, EXP[dp]: %d\n",
                ei->cycle, ei->dut_dig, ei->dut_sel, ei->exp_dig, ei->exp_num, ei->exp_dp);
        }
    }
    
    return 0;
}
