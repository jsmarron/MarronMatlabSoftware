function [c, vu, vv] = modeIfitSM(mdata) 
%  MODEIFITSM, FIT of Individual MODE of Variation
%   Steve Marron's matlab function
%   For an input matrix of data, 
%   assumed to be appropriately centered (double centered?),
%   this calculates the best L2 fit by a single mode of variation
%   of the form:    c * u * v'
%   Really just first SVD component
%
% Inputs:
%
%   mdata    - d x n matrix of data
%
% Outputs:
%
%   c - scalar coefficient of mode of variation
%
%   vu - d x 1 column vector = left vector of mode
%
%   vv - n x 1 column vector - transpose is right vector of mode
%


%    Copyright (c) J. S. Marron 2026

[vu,c,vv] = svds(mdata,1) ;

