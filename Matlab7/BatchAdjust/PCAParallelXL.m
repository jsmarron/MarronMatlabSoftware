%%%% Draw plots for Wistar data
%%%% Before and after adjustment 
%%%% Use forth direction as parallel direction

part = 1 ;  % 1  Raw data, Raw axes, 3 PCA and 1 Parallel direction
           % 2  DWDstd data, Same axes as before
           % 3  DWDstd data, current axes. 
           
           
%%%%%%%%%%%%%  First load data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load  Ha05;  %% in Ha05, A39 is missing 
           outlierIndex = [4,10,19,38] ; 
           ID= ID_Ha05;
           batch1=Values_Ha05(:,logical(~ismember(1:38,outlierIndex)));
                    %% Delet outliers A4,A10, A19, A38
           batch2=Values_Ha05(:,logical([zeros(1,38),~ismember(1:38,outlierIndex)]));
           Array1 = [Sample_Ha05(logical(~ismember(1:38,outlierIndex)))];
           Array2 = [Sample_Ha05(logical([zeros(1,38),~ismember(1:38,outlierIndex)]))];
           n = size(batch1,2);
           N = size(batch1,1);
           index_ttA = [10,11,16,17,22,23,24,26:30,33,34];    
           index_A = 1:n ; 
           index_utA = index_A(logical(~ismember(index_A,index_ttA)));
 %  this creates:
    %      batch1   -   N x (n)  Protocol A.
    %      batch2   -   N x (n)  Protocol S.
    %      Array1   -   Arraynames for batch1
    %      Array2   -   Arraynames for batch2
    %      ID1 for batch1
    %      ID2 for batch2
    
 %% DAta transformation
 %% Log10 transformation 
 %% Make negative values to 0.002
 %% Refer to statistics of the data 
     for i=1:n
        for j= 1:N
           if batch1(j,i)<0.002 
            batch1(j,i)=0.002;
           end
            batch1(j,i)=log10(batch1(j,i));
        end
     end
     
     for i=1:n
        for j= 1:N
           if batch2(j,i)<0.002 
            batch2(j,i)=0.002;
           end
            batch2(j,i)=log10(batch2(j,i));  
        end
     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Data for each step %%%%%%%%%
     Rawdata=[batch1,batch2]; 
     disp('RawData')   
 %%% INDEX
     index_tt =[index_ttA,index_ttA+n];   
     index_ut =[index_utA,index_utA+n]; 
     flag_tt = logical(ismember(1:2*n,index_tt)); 
     flag_ut = ~flag_tt ; 
     flag_ttA = logical([ismember(1:n,index_ttA),zeros(1,n)]); 
     flag_utA = logical([ismember(1:n,index_utA),zeros(1,n)]) ; 
     flag_ttS = logical([zeros(1,n),flag_ttA(1:n)] ); 
     flag_utS = logical([zeros(1,n),flag_utA(1:n)]) ; 
     index_ttS = index_ttA + n ; 
 %%%%%%%%%%%%%%%%%%% Finish data loading 
 
 if part == 1 
     data = Rawdata ; 
 else
      %  Operation e  DWD
     baparamstruct = struct('viplot',zeros(4,1), ...
                       'iscreenwrite',1) ;  
     DWDdata = batcHadjustSM(Rawdata,[-ones(1,n), ones(1,n)],baparamstruct) ;
     disp('Got Data12')   
   %%%%% After DWD  substract column mean
     data13=DWDdata-vec2matSM(mean(DWDdata,1),N);
     disp('Got Data13')   
   %%%%%After DWD colmean subtracted, divide by column sd
     DWDcoldata=data13./vec2matSM(std(data13,0,1),N);
     data = DWDcoldata ;   
 end 
 
 
 %%%% Different parameters for different parts ; 
 if part == 1 
     pcaparamstruct = struct('npc',2, ...
                        'viout',[0 1 0 0 1], ...
                        'iscreenwrite',1) ;
    outstruct = pcaSM(Rawdata,pcaparamstruct) ;
    mdir = getfield(outstruct,'meigvec') ;  
    [pdir,val]= parallelXL(Rawdata,2) ; 
    mdir(:,3) = pdir(:,2) ; 
    mdir(:,4) = pdir(:,1) ; 
    savecolstr = ['PCAParallel-' num2str(part)] ; 
    titcstr = {{ [savecolstr]  'Rawdata(Delet outliers)' ... 
       ' Protocol A: + ; S: o'  ' Raw PCA and Parallel Axes'}} ;
    labelcellstr={{'PC1Direction';'PC2Direction';'Raw Parallel1'; ...
                    'Raw Parallel2'}};
 elseif part == 2 
    pcaparamstruct = struct('npc',2, ...
                        'viout',[0 1 0 0 1], ...
                        'iscreenwrite',1) ;
    outstruct = pcaSM(Rawdata,pcaparamstruct) ;
    mdir = getfield(outstruct,'meigvec') ;  
    [pdir,val]= parallelXL(Rawdata,2) ; 
    mdir(:,3) = pdir(:,2) ; 
    mdir(:,4) = pdir(:,1) ; 
    savecolstr = ['PCAParallel-' num2str(part)] ; 
    titcstr = {{ [savecolstr]  'DWDdata(Delet outliers)' ... 
       ' Protocol A: + ; S: o'  ' Raw PCA and Parallel Axes'}} ;
    labelcellstr={{'PC1Direction';'PC2Direction';'Raw Parallel1'; ...
                    'Raw Parallel2'}};
  elseif part == 3 
    pcaparamstruct = struct('npc',2, ...
                        'viout',[0 1 0 0 1], ...
                        'iscreenwrite',1) ;
    outstruct = pcaSM(DWDcoldata,pcaparamstruct) ;
    mdir = getfield(outstruct,'meigvec') ;  
    [pdir,val]= parallelXL(DWDcoldata,2) ; 
    mdir(:,3) = pdir(:,2) ; 
    mdir(:,4) = pdir(:,1) ;  
    savecolstr = ['PCAParallel-' num2str(part)] ; 
    titcstr = {{ [savecolstr]  'DWDdata(Delet outliers)' ... 
       ' Protocol A: + ; S: o'  ' Current PCA and Parallel Axes'}} ;
    labelcellstr={{'PC1Direction';'PC2Direction';'Current Parallel1'; ...
                    'Current Parallel2'}};
 end               
                    
 %%%%%different symbols for different Groups of Arrays: 
%%%%%%  + for Protocol A, o for Protocol S
  markerstr = '+' ;
 for i = 1:(n-1) ;
    markerstr = strvcat(markerstr,'+') ;
  end ;
for i = (n+1):2*n ;
    markerstr = strvcat(markerstr,'o') ;
end

%% Different colors for different Protocol  
%  purple for Protocol A, green for Protocol S
    mlegcol = [[1 0 0]; [1 0 1]] ;
    dolmax = 0.8 ;
    dolmin = 0.2 ;
    dccolstr = ones(n,1)*[1 0 1] ;   
    mcolor = ones(2*n,1)*[1 0 1];
         for i = index_ttA
        mcolor(i,:) = [1 0 0];
        dccolstr(i,:) = [1 0 0]; 
        mcolor(i+n,:) = [1 0 0];
          end 
%%% Collect Matched arrays for two batchs
mdataconn = [(1:n)',((n+1):2*n)'] ;
        
 maxaxis = [];
%%%%%% set parameters in the plots 

 savestr = [savecolstr] ;
 %%%%%%%%%%%%% Draw plots%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',markerstr, ...
                       'isubpopkde',1, ...
                       'idataconn',mdataconn, ...
                       'idataconncolor',dccolstr,...
                       'idataconntype','--', ...
                       'datovlaymax',dolmax, ...
                       'datovlaymin',dolmin, ...
                       'legendcellstr',{{'Treated' 'Untreated'}}, ...
                       'labelcellstr',labelcellstr,...
                       'mlegendcolor',mlegcol, ...
                       'maxlim',maxaxis,...
                       'titlecellstr',titcstr, ...
                       'savestr',savestr, ...
                       'iscreenwrite',1) ;
   scatplotSM(data,mdir,paramstruct) ;
 
 if ~isempty(savestr) ;   %  then create postscript file
    orient landscape ;
    print('-dpsc',savestr) ;
end ;

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
     