#include <Rcpp.h>
using namespace Rcpp;

#include <map>

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

double Dist(double x1, double x2, double y1, double y2){
   return sqrt(pow((x1-x2),2.0)+pow((y1-y2),2.0));
}

//negative exponential dispersal kernel --> mean distance = alpha
double dnegExp2D(double r, double d_mean){
   return 1/(2*M_PI*d_mean*d_mean)*exp(-r/d_mean);
};

// [[Rcpp::export]]
DataFrame calc_connect(IntegerMatrix map, double cell_size, double alpha){

   int nrows = map.nrow();
   int ncols = map.ncol();

   std::map<int, int> frag_ncells;
   std::map<int, std::map<int, double> > connect_mat;

   int frag_id_target, frag_id_source;
   double d, cell_connect;

   //calculate integrals
   for (int itarget = 0; itarget < nrows; ++itarget){

      //Rcout << itarget << std::endl;
      Rcpp::checkUserInterrupt();

      for (int jtarget=0; jtarget < ncols; ++jtarget){

         frag_id_target = map(itarget, jtarget);

         if (frag_id_target != NA_INTEGER){
            ++frag_ncells[frag_id_target];
   //       Rcout << PatchID_target;
            for (int isource = 0; isource < nrows; ++isource){
               for (int jsource = 0; jsource < ncols; ++jsource){
                  frag_id_source = map(isource, jsource);

                  if ((frag_id_source != NA_INTEGER) && (frag_id_target != frag_id_source)){
                     d = Dist(itarget, isource, jtarget, jsource) * cell_size;
                     cell_connect = dnegExp2D(d, alpha)*cell_size*cell_size*cell_size*cell_size;
                     //cell_connect = d2Dt(d,Para.U_2Dt,Para.P_2Dt)*cell_size*cell_size*cell_size*cell_size;
                     connect_mat[frag_id_target][frag_id_source] += cell_connect;
                  } //if target not NAval && target != source

               } //jsource
            } //isource

         } //if target != NAval
      } // jtarget
   } // itarget

   IntegerVector frag_id(frag_ncells.size());
   NumericVector frag_area_ha(frag_ncells.size());
   NumericVector frag_connect(frag_ncells.size());

   std::map<int,int>::iterator frag_it1;
   std::map<int,int>::iterator frag_it2;

   int i = 0;
   for (frag_it1 = frag_ncells.begin() ; frag_it1 != frag_ncells.end(); ++frag_it1){
      frag_id[i] = frag_it1->first;
      frag_area_ha[i] = frag_it1->second * cell_size * cell_size/10000;
      for (frag_it2 = frag_ncells.begin() ; frag_it2 != frag_ncells.end(); ++frag_it2){
         frag_connect[i] += connect_mat[frag_it1->first][frag_it2->first];
      }
      ++i;
   }

   DataFrame con_dat = DataFrame::create(_["fragment_id"] = frag_id,
                                         _["area_ha"] = frag_area_ha,
                                         _["connectivity"] = frag_connect);

   return con_dat;
}
