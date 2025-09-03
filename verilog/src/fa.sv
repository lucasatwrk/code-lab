module fa(
    input a, b, cin,
    output sum, cout);

    logic s1, c1, c2;

    xor g1(s1, a, b);
    xor g2(sum, s1, cin);
    and g3(c1, a,b);
    and g4(c2, s1, cin) ;
    xor g5(cout, c2, c1) ;
endmodule