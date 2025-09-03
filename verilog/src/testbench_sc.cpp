// WIP...
#include "Vfa4.h"
#include <systemc>
#include <iostream>

int sc_main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vfa4 top("top");
    
    // time unit
    sc_core::sc_time STEP(10, sc_core::SC_NS);

    struct TestVector {
        uint8_t a;
        uint8_t b;
    };

    TestVector tests[] = {
        {10, 5},
        {10, 6},
        {10, 7}
    };

    for (auto &t : tests) {
        top.a.write(t.a);
        top.b.write(t.b);
        // top->cin = false;
        // top->eval();
        printf("time: %d, a: %d, b: %d, sum: %d\n", sc_core::sc_time_stamp(), (int)top.a, (int)top.b, (int)top.sum);
    }

    sc_core::sc_start(STEP); // time move forward

    // delete top;
    return 0;
}