#include "Vfa4.h"
#include <systemc>
#include <iostream>
#include <memory>
#include <cstdlib> // for getenv
using namespace sc_core;
using sc_dt::sc_uint;
using namespace std;

const char *VCD_FILE = "wave"; // systemc will append .vcd as wave.vcd

struct VcdFileDeleter {
    void operator()(sc_trace_file* file) const {
        if (file) {
            sc_close_vcd_trace_file(file);
            cout << "VCD file closed" << endl;
        }
    }
};
using VcdFilePtr = unique_ptr<sc_trace_file, VcdFileDeleter>;

// SC_MODULE(Testbench) {  // class Testbench : public sc_module
class Testbench : public sc_module {
    unique_ptr<Vfa4> dut;
    sc_signal<uint32_t> sig_a, sig_b, sig_sum;
    sc_signal<bool> sig_cin, sig_cout;
    // sc_clock clk;
    VcdFilePtr vcd_file;

    // SC_CTOR(Testbench) { // Testbench(sc_module_name name) : sc_module(name)
    public:
    sc_in<bool> clk;
    Testbench(sc_module_name name, const char *vcd_file_name = "wave") : sc_module(name)/*, clk("clk", 10, SC_NS, 0.5)*/ {
        dut = make_unique<Vfa4>("top");
        bool enable_vcd = (getenv("DUMP_VCD") != nullptr);
        if (enable_vcd) {
            cout << "VCD file enabled" << endl;
            vcd_file.reset(sc_create_vcd_trace_file(vcd_file_name));
            vcd_file->set_time_unit(1, SC_NS);

            sc_trace(vcd_file.get(), clk, "clk");
            sc_trace(vcd_file.get(), sig_a, "a");
            sc_trace(vcd_file.get(), sig_b, "b");
            sc_trace(vcd_file.get(), sig_cin, "cin");
            sc_trace(vcd_file.get(), sig_sum, "sum");
            sc_trace(vcd_file.get(), sig_cout, "cout");
        }

        dut->a(sig_a);
        dut->b(sig_b);
        dut->cin(sig_cin);
        dut->sum(sig_sum);
        dut->cout(sig_cout);

        SC_THREAD(stim_thread);
        // SC_THREAD(monitor_thread);
        SC_METHOD(monitor_outputs);
        sensitive << clk.pos(); // require SC_METHOD with `sc_in<bool> clk`
    }

    void stim_thread() {
        sig_a.write(10);
        sig_b.write(4);
        sig_cin.write(0);

        sc_uint<4> b{4};

        for (int i = 0; i < 16; i++) {
            b = 4 + i;
            sig_b.write(b);

            // Wait for rising edge of clock signal
            wait(clk.posedge_event());
            // cout << "Time: " << sc_time_stamp() << ", Sum: " << sig_sum.read() << ", Cout: " << sig_cout.read() << endl;
        }
        sc_stop(); // stop simulation
    }

    void monitor_thread() {
        while (true) {
            // wait(10, SC_NS);
            // cout << "Sum: " << sum.read() << ", Carry out: " << cout.read() << std::endl;

            // Wait for rising edge of clock signal
            wait(clk.posedge_event());
            // cout << "Time: " << sc_time_stamp() << ", A: " << sig_a.read() << ", B: " << sig_b.read() << ", Cin: " << sig_cin.read() << ", Sum: " << sig_sum.read() << ", Cout: " << sig_cout.read() << endl;
            // cout << "[" << sc_time_stamp().to_string() << "] ";
            printf("[%6s] a: %2d, b: %2d, cin: %d, sum: %2d, cout: %d\n", sc_time_stamp().to_string().c_str(), sig_a.read(), sig_b.read(), sig_cin.read(), sig_sum.read(), sig_cout.read());
        }
    }

    void monitor_outputs() {
        printf("[%6s] a: %2d, b: %2d, cin: %d, sum: %2d, cout: %d\n", sc_time_stamp().to_string().c_str(), sig_a.read(), sig_b.read(), sig_cin.read(), sig_sum.read(), sig_cout.read());
    }
};

int sc_main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Testbench tb("tb");

    sc_clock clk("clk", 10, SC_NS, 0.5);
    tb.clk(clk);

    sc_start(); // start simulation
    return 0;
}