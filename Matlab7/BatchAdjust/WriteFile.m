function WriteFile (adjdata, batchlabels);

% Write data from matrix adjdtat back to the textfile

%dlmwrite ('DWD_cut_out_ez.txt', adjdata, 'delimiter', '\t', 'precision', '%6.3f');
%dlmwrite ('DWD_cut_out_ez.txt', adjdata, 'delimiter', '\t');

% Output tab delimited text file

  fileName ='DWD_cut_out_ez.txt';
  fid = fopen(fileName,'wt') ;

  if (fid<0)
      error ('Could not open the file for saving data');
  end;
% 'wt' is for "delete contents of this file and open 
% for writing" (with 't' for "text").

  %n = length(vBatch);
  %d = length(batchlabels);
  [n d]= size (adjdata);
% Print header lines
% cntbytes = fprintf(fid,'\t%1s','batch') ;
  for i = 1:(d-1) ;
        cntbytes = fprintf(fid,'%1.0f\t',batchlabels(i)) ;
  end ;
  cntbytes = fprintf(fid,'%1.0f\t\n',batchlabels(d)) ;

% Loop through remaining lines
  for i = 1:n;
      for j = 1:(d-1) ;
          cntbytes = fprintf(fid,'%6.3f\t',adjdata(i,j)) ;
      end ;
      cntbytes = fprintf(fid,'%6.3f\t\n',adjdata(i,d)) ;
  end ;

  fclose(fid) ;