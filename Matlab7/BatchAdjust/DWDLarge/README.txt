

DWDLarge version 0: 
A MATLAB software for large scale distance weighted discrimination.
Copyright (c) 2016 by
Xin-Yee Lam, J.S. Marron, Defeng Sun, 
Kim-Chuan Toh (corresponding author)


This software package is for solving 
(P)  min  sum_j (1/rj^q) + C*<e,xi> 
     s.t  r = ZT*w + beta*y + xi, r > 0, xi>=0, norm(w)<=1

The main algorithm is a symmetric Gauss-Seidel based ADMM 
method applied to (P); details can be found in the following 
reference: 

[Reference]
Xin Yee Lam, J.S. Marron, Defeng Sun, Kim-Chuan Toh
Fast algorithms for large scale generalized distance weighted discrimination
arXiv:1604.05473

--------------------------------------------------------------
[Citation Information]
If you find the software DWDLarge useful, 
please cite the above paper in you publication.

--------------------------------------------------------------
[Copyright] 
See Copyright.txt

--------------------------------------------------------------
[Main functions]
See contents.m

--------------------------------------------------------------
[Installation] 
The software requires a few mex-files that you may need
to compile in MATLAB. 
To so, run MATALB in the directory "DWDLarge", then type: 

>> Installmex_DWD 

After that, to see whether you have installed the software
correctly, type the following in MATLAB: 

>> DWDdemo
--------------------------------------------------------------