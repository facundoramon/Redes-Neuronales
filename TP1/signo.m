function sal = signo(A)

B = A;
J = B == 0;
B(J) = -1;
B = sign(B);

sal = B;