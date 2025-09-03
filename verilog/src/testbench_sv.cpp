#include "Vfa4.h"
#include <memory>
#include <iostream>
using namespace std;

int main(int, char**) {
    std::unique_ptr<Vfa4> dut(new Vfa4);

    dut->a = 10;
    dut->b = 4;
    dut->cin = 0;
    dut->eval();
    // printf("%d\n", dut->sum);
    printf("Init state: a: %2d, b: %2d, cin: %d, sum: %2d, cout: %d\n", dut->a, dut->b, dut->cin, dut->sum, dut->cout);
    for(int i = 0; i < 16; i++) {
        dut->b = i;
        dut->eval();
        // printf("%d\n", dut->sum);
        printf("[%2d] a: %2d, b: %2d, cin: %d, sum: %2d, cout: %d\n", i, dut->a, dut->b, dut->cin, dut->sum, dut->cout);
    }
    return 0;
}
