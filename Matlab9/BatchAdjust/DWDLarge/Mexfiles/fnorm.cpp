/***********************************************************************
 * Compute Frobenius norm
 ***********************************************************************/

//#include <Rcpp.h>
#include <math.h>
#include <string.h> /* needed for memcpy() */
#include <iostream>
#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace arma;
using namespace std;
using namespace Rcpp;

#if !defined(SQR)
#define SQR(x) ((x)*(x))
#endif

// [[Rcpp::export]]

/**********************************************************
* 
***********************************************************/
double fnorm(RObject x) {
  double norm = 0;
  if (!x.isS4()){
    Rcpp::NumericVector vecX(x);
    int n = vecX.size();
    
    for (int i = 0; i < n; i++) {
      norm = SQR(REAL(vecX)[i]) + norm;
    }
  }
  else{
    if (Rf_inherits(x,"dgCMatrix")){
      arma::sp_mat X;
      X = as<arma::sp_mat>(x);
      arma::sp_mat product;
      product = X.t()*X;
      norm = trace(product);
    }
  }
  return sqrt(norm);
}


// /*** R
// Z = sparseMatrix(i=1:2,j=1:2,x=c(1,2))
// fnorm(Z)
// */
