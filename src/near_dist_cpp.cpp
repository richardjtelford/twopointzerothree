#include <Rcpp.h>
using namespace Rcpp;
//' @title Detect rows that are (within tolerance) identical
//' @name near_dist
//' @description This function takes a numeric matrix and runs a pairwise comparison
//' of rows, reporting whether they are identical or not, with a tolerance for small differences.
//' 
//' @param k Numeric vector
//' @param tolerance Numeric The tolerance for comparing values.
//' @param rev boolean Test for reversed duplicates e.g ABC matches CBA
//' @param negate boolean Also test for negative duplicates.
//' @return A distance object containing TRUE for rows that are identical (within tolerance), false otherwise
//' @export
// [[Rcpp::export]]

LogicalVector near_dist_cpp(NumericMatrix k,
                            double tolerance, 
                            bool rev,
                            bool negate) {
  
  const int n = k.nrow();
  const int p = k.ncol();
  const int m = n * (n - 1) / 2;
  
  LogicalVector out(m);
  
  int idx = 0;
  
   for (int i = 0; i < n; ++i) {
    for (int j = i + 1; j < n; ++j) {
      
      bool same = true;
      
      for (int c = 0; c < p; ++c) {
        if(!rev) {
          if (std::abs(k(i, c) - k(j, c)) >= tolerance) {
            same = false;
            break;
          }
        } else {
          if (std::abs(k(i, c) - k(j, p - 1 - c)) >= tolerance) {
            same = false;
            break;
          }
        }
      }
      
      out[idx++] = same;
    }
  }
// hunt for -v = v to allow for negative multipliers
  if (negate) {
    LogicalVector out2(m);
    
    int idx2 = 0;
    
    for (int i = 0; i < n; ++i) {
      for (int j = i + 1; j < n; ++j) {
        
        bool same = true;
        
        for (int c = 0; c < p; ++c) {
          if(!rev) {
            if (std::abs(k(i, c) + k(j, c)) >= tolerance) {
              same = false;
              break;
            }
          } else {
            if (std::abs(k(i, c) + k(j, p - 1 - c)) >= tolerance) {
              same = false;
              break;
            }
          }
        }
        
        out2[idx2++] = same;
      }
    }
    //  OR on out vs out2
    // Perform element-wise Logical OR
    for (int a = 0; a < m; a++) {
      out[a] = out[a] || out2[a];
    }
 
  }
  
  out.attr("Size") = n;
  out.attr("Diag") = false;
  out.attr("Upper") = false;
  out.attr("class") = "dist";
  
  return out;
}