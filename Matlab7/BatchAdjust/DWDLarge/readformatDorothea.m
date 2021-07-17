 function [y,X] = readformatB(fname)

  fid = fopen([fname,'Y.txt'],'r');
  if (fid == -1); 
      Y = [];
      fprintf('file cannot be opened \n');
      return;
  end
  [datavec,count] = fscanf(fid,'%c');
  fclose(fid); 
  linefeeds = findstr(datavec,char(10));
  datavec(linefeeds) = blanks(length(linefeeds)); 
  y = sscanf(datavec,'%f'); 
  N = length(y); 
%%  
  fid = fopen([fname,'X.txt'],'r');
  if (fid == -1); 
      X = [];
      fprintf('file cannot be opened \n');
      return;
  end
  rowcnt = 0; col = []; row = []; Xmax = 0; 
  while (true)
      line = fgetl(fid);
      [coltmp,numentry] = sscanf(line,'%f');
      Xmax = max(Xmax,max(abs(coltmp))); 
      col = [col; coltmp]; 
      rowcnt = rowcnt+1;
      row = [row; rowcnt*ones(numentry,1)]; 
      if feof(fid); break; end
  end
  fclose(fid); 
  X = spconvert([row,col,ones(length(col),1);rowcnt,max(col),0]);
  idx = find(y==0); 
  if ~isempty(idx)
     y(idx) = -1; 
  end
  meanX = mean(X);
  if max(abs(meanX)) > 0.1*Xmax;     
     X = X-ones(size(X,1),1)*meanX; 
  end
  normX = sqrt(sum(X.*X))';
  N = length(normX); 
  X = X*spdiags(sqrt(N)./normX,0,N,N); 
  
