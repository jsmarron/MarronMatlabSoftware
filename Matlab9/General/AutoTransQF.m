function [transformed_data, transformation, vbeta] = AutoTransQF(mdata, paramstruct)
% This program will automatically transform each row of inputt data set
% to make the distribution of each row vector closer to the standard normal
% distribution
%
% The transformation function belongs to a new parametrization of the 
% shifted logarithm family, in which the transformation parameter is 
% chosen to minimize the skewness/Anderson-Darling Statistic of the 
% transformed data vector
%
% Inputs:
%         mdata - d x n matrix of data, 
%                 the n columns: each column is a sample (data object)
%                         Need n > 7 to compute Anderson Darling Statistic
%                 the d rows: each row represents a feature
%
%   paramstruct - a Matlab structure of input parameters
%                    Use: "help struct" and "help datatypes" to
%                         learn about these.
%                    Create one, using commands of the form:
%
%       paramstruct = struct('field1',values1,...
%                            'field2',values2,...
%                            'field3',values3) ;
%
%                          where any of the following can be used,
%                          these are optional, misspecified values
%                          revert to defaults
%
%                    Version for easy copying and modification:
%    paramstruct = struct('',, ...
%                         '',, ...
%                         '',) ;
%
%    fields             Values
%
%    istat               Criterion for selecting the parameter of
%                           transformation funtion 
%                           1: Anderson-Darling Test Statistics (default)
%                           2: Skewness                            
%
%    iscreenwrite       0 for no screenwrites (default)
%                       1 to write progress to screen
%
%    FeatureNames       Feature names of each data vector
%                                      default setting: 'Feature1' 
%                                      use strvcat to write each feature
%                                      name into each row 
%                                      Note: Matlab does tex interpretation,
%                                            which turns '_' into subscripts.
%                                            To turn this off, use:
%                                      set(gcf,'defaulttextinterpreter','none')
%
% Outputs:
%    transformed_data   Shifted Log Tranformed Version of the data
%                           with Winsorization to limit size of large values
%                           and Normalization to zero mean and unit variance
%
%    transformation     Cell Array of Output text, summarizing transformation
%                           Each line appears as output when iscreenwrite = 1
%
%    vbeta              d x 1 column vector of original beta paramters of
%                           shifted log transformation in form developed in:
%                           Feng, Hannig, Marron (2016) Stat, 5(1), 82-87.
%
% Assumes path can find personal functions:
% autotransfuncQF.m
% ADStatQF.m

%    Copyright (c) Qing Feng & J. S. Marron 2014-2024


[d, n] = size(mdata) ;
transformed_data = zeros(d, n) ;
transformation = {} ;

%  First set all parameters to defaults
istat = 1 ;
iscreenwrite = 0;
FeatureNames = [] ;
for i=1:d
    FeatureNames = char(FeatureNames, ['Feature' num2str(i)]) ;
end

if nargin>1
    
    if isfield(paramstruct, 'istat')
        istat = paramstruct.istat;
    end
    
    if isfield(paramstruct, 'iscreenwrite')
        iscreenwrite = paramstruct.iscreenwrite;
    end
    
    if isfield(paramstruct, 'FeatureNames')
        FeatureNames = paramstruct.FeatureNames;
    end
    
    %when the number of feature names is unmatched with number of features
    %needed to perform transformation, use default feature names 
    if d ~= size(FeatureNames, 1)
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        disp('!!! Warning: Number of Feature Names!!!!!');
        disp('!!! Unmatched with Number of Features!!!!');
        disp('!!! Use Default Set for Feature Names!!!!!!!');
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        FeatureNames=[];
        for i=1:d
            FeatureNames = char(FeatureNames, ['Feature' num2str(i)]) ;
        end
    end

end 



parfor i = 1 : size(mdata,1)
    
    vari = mdata(i, :) ;


    if sum(isnan(vari))
        disp ('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        disp ('!!!   Warning from AutoTransQF.m:   !!!') ;
        disp (['!!! ' FeatureNames(i, :) ' Contains a Missing Value !!!']) ;
        disp ('!!!       Returning Original Data          !!!') ;
        disp ('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        final_vari = vari;
        text_k =  'Return original vector';
        
        transformed_data(i, :) = final_vari;
        transformation{i, 1} = [ FeatureNames(i, :) ': ' text_k] ;
        vbeta(i) = 0 ;
        
        continue;
    elseif abs(std(vari)) < 1e-6    %if number of unique values is greater then 2    
        disp ('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!IIIIIIIIIIIIIIIII!!!!!!!!!!') ;
        disp ('!!!    Warning from AutoTransQF.m:   !!!') ;
        disp ('!!!          Standard deviation = 0            !!!') ;
        disp ('!!!              Returning all zeros              !!!') ;
        disp ('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!IIIIIIIIIIIIIIIII!!!!!!!!!!') ;
        final_vari = zeros(d, n);
        text_k =  'Return zero vector';
        
        transformed_data(i, :) = final_vari;
        transformation{i, 1} = [ FeatureNames(i, :) ': ' text_k] ;
        vbeta(i) = 0 ;

        continue;
        
    elseif length(unique(vari))<=2    % binary data
        disp ('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        disp ('!!!   Warning from AutoTransQF.m:    !!!') ;
        disp ('!!!   Binary Variable                !!!') ;
        disp ('!!!   Return original values         !!!') ;
        disp ('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        final_vari = vari;
        text_k =  'No Transformation';
        
        transformed_data(i, :) = final_vari;
        transformation{i, 1} = [ FeatureNames(i, :) ': ' text_k] ;
        vbeta(i) = 0 ;

        continue;
        
    else
        
        if skewness(vari) > 0
            arrayindx = [0, 0.01:0.01:9] ;
        else
            arrayindx = -[0, 0.01:0.01:9] ;
        end
        
        func = @(paraindex) autotransfuncQF(vari, istat, paraindex) ;
        [~, eval] = arrayfun(func, arrayindx, 'UniformOutput', false);
        [~, index] = min(cell2mat(eval));
        beta = sign(arrayindx(index))*(exp(abs(arrayindx(index)))-1);     

%        [final_vari, value] = autotransfuncQF(vari, istat, arrayindx(index));
        [final_vari, ~] = autotransfuncQF(vari, istat, arrayindx(index));
        text_k =  [' transformation Parameter Beta =' num2str(beta)];
        
        transformed_data(i, :) = final_vari;
        transformation{i, 1} = [ FeatureNames(i, :) ': ' text_k] ;
        vbeta(i) = beta ;
     
    
    end
    



    %%  Display transformation information on screen 

    if iscreenwrite == 1

        disp(' ') ;
        if istat == 1
            disp(['************ Transformation of ' FeatureNames(i, :) ' **********']);
            disp (['Transformation Criterion: Minimize Log ' ...
                         '(Anderson_Darling Test Statistic) (Standard Normal)']) ;
        elseif istat == 2
            disp(['************ Transformation of ' FeatureNames(i, :) ' **********']);
            disp ( 'Transformation Criterion: Minimize Skewness' ) ;
        end
        
        disp( ['Log A-D Stat Before Transformation: ' num2str(log(ADStatQF(vari)))] ) ;  
        disp( ['Skewness Before Transformation: ' num2str(skewness(vari))]) ; 
        disp( ['Selected Transformation: ' text_k] );
        disp( ['Skewness After Transformation: ' num2str(skewness(final_vari))] );
        disp( ['Log A-D Stat After Transformation: ' num2str(log(ADStatQF(final_vari)))] );
        disp('*****************************************************') ;
      
    end


end  

end

