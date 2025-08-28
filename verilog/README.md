# Verilator

* https://hackmd.io/@chtsai/S1wLTsQvj

```sh
verilator --cc --main src/adder4.v src/fulladder.v src/testbench.cpp

make -c obj_dir -f Vadder4.mk

# with build
verilator --cc --build --exe src/adder4.v src/fulladder.v src/testbench.cpp
```
