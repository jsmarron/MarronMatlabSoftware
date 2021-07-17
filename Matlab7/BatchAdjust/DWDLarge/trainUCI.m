%%********************************************************************
%% trainUCI: test the LIBSVM dataset
%%********************************************************************
%% Read file
% m: the number of samples,  n: the number of features
% y: m by 1 vector of training labels
% X: m by n matrix of m training samples with n features.
%
% libsvmread('Data-LIBSVM/filename') read a dataset in Data-LIBSVM/
%********************************************************************
clear all
home = pwd; %% The folder in which trainUCI.m is residing in. 
addpath(genpath([home,'\DWDsolver']))
addpath(genpath([home,'\DWDlib']))
addpath(genpath([home,'\Mexfiles']))
addpath(genpath([home,'\LIBSVM']))
addpath(genpath([home,'\LIBLINEAR']))
UCIdataDirectory = 'D:\SDPdata\UCIdata';

fname{1} = 'a8a'; nuset(1) = 0.365; penalty(1) = 0.041; CLIBLINEAR(1) = 0.031;
fname{2} = 'a9a'; nuset(2) = 0.362; penalty(2) = 0.025; CLIBLINEAR(2) = 0.008;
fname{3} = 'covtype';   nuset(3) = 0.592; penalty(3) = 0.032; CLIBLINEAR(3) = 0.031;
fname{4} = 'gisette';   nuset(4) = 0.109; penalty(4) = 0.006; CLIBLINEAR(4) = 0.002;
fname{5} = 'ijcnn1';    nuset(5) = 0.194; penalty(5) = 0.126; CLIBLINEAR(5) = 0.5;
fname{6} = 'mushrooms'; nuset(6) = 0.010; penalty(6) = 0.179; CLIBLINEAR(6) = 0.125;
fname{7} = 'real-sim'; nuset(7) = 0.134; penalty(7) = 0.608; CLIBLINEAR(7) = 1;
fname{8} = 'w7a';   nuset(8) = 0.038; penalty(8) = 0.356; CLIBLINEAR(8) = 1;
fname{9} = 'w8a';   nuset(9) = 0.038; penalty(9) = 0.160; CLIBLINEAR(9) = 8;
fname{10} = 'rcv1'; nuset(10) = 0.106; penalty(10) = 0.148; CLIBLINEAR(10) = 0.125;
fname{11} = 'leu'; nuset(11) = 0.023; penalty(11) = 0.140; CLIBLINEAR(11) = 0.004;
fname{12} = 'colon'; nuset(12) = 0.294; penalty(12) = 0.160; CLIBLINEAR(12) = 0.016;
fname{13} = 'prostate'; nuset(13) = 0.1; penalty(13) = 0.364; CLIBLINEAR(13) = 0.016;
fname{14} = 'srbct'; nuset(14) = 0.1; penalty(14) = 0.235; CLIBLINEAR(14) = 0.5;
fname{15} = 'farm-ads'; nuset(15) = 0.02; penalty(15) = 9.496; CLIBLINEAR(15) = 0.063;
fname{16} = 'dorothea'; nuset(16) = 0.1; penalty(16) = 0.031; CLIBLINEAR(16) = 0.063;
fname{17} = 'url-svm';nuset(17) = 0.1; penalty(17) = 1024; CLIBLINEAR(17) = 32;
fname{18} = 'gisette-scale'; nuset(18) = 0.1;   penalty(18) = 0.006;
%% Choose algorithm:
%  1: our inexact sGS-ADMM
%  2: directly extended ADMM
%  3: interior point method
%  4: LIBSVM
%  5: LIBLINEAR
algorithm = 1; 
saveyes = 0;    
expon = 1;   

for fid = [3]; [1:11,13,15,16,17];
    %% read train data
    tstart = clock;
    probname = [UCIdataDirectory,filesep,fname{fid}]; 
    hasTestFile = 0;
    if algorithm == 1
       savefname = ['results-UCI',filesep,'DWD'];
    elseif algorithm == 2
       savefname = ['results-UCI',filesep,'directADMM'];
    elseif algorithm == 3
       savefname = ['results-UCI',filesep,'ipm'];
    elseif algorithm == 4
       savefname = ['results-UCI',filesep,'LIBSVM'];
    else
       savefname = ['results-UCI',filesep,'LIBLINEAR'];
    end
    if ~exist(savefname,'dir') %creat director if necessary
       mkdir(savefname);  
    end
    savefname = [savefname,filesep,fname{fid},'-',num2str(expon)];
    if exist([savefname,'.mat'])
       eval(['load ',savefname,'.mat'])
    end    
    if exist(probname) 
       if strcmp(fname{fid},'url-svm');
          [y,XT0] = libsvmread([probname,filesep,'Day0.svm']);
          numNZ = 1e9; 
          rr = zeros(numNZ,1); cc = zeros(numNZ,1); vv = zeros(numNZ,1);  
          [rr2,cc2,vv2] = find(XT0);           
          cnt = length(y); 
          len = length(rr2); 
          rr(1:len) = rr2; cc(1:len) = cc2; vv(1:len) = vv2;
          Dayinterval = 10; %Dayinterval = 2; 
          for Day = [Dayinterval:Dayinterval:120]
             [y2,XT2] = libsvmread([probname,filesep,'Day',num2str(Day),'.svm']);             
             [rr2,cc2,vv2] = find(XT2);
             idx = len+[1:length(rr2)];
             rr(idx) = rr2+cnt; cc(idx) = cc2; vv(idx) = vv2;
             y(cnt+[1:length(y2)]) = y2;              
             len = len + length(rr2); 
             cnt = cnt + length(y2);              
          end 
          rr = rr(1:len); cc = cc(1:len); vv = vv(1:len);
          XT = spconvert([rr,cc,vv; max(rr),3231961,0]);
       else
          [y,XT] = libsvmread(probname);
       end
    elseif exist([probname,'.txt'])
       [y,XT] = libsvmread([probname,'.txt']);
    elseif exist([probname,'X.txt']) || exist([probname,'X']);
       if strcmp(fname{fid},'dorothea')
          [y,XT] = readformatDorothea(probname);         
       else
          [y,XT] = readformatA(probname);   
       end
    end   
    rtime = etime(clock,tstart);    
    %% test file
    if exist([probname,'-t'])
       [testy,testXT] = libsvmread([probname,'-t']);
       if strcmp(fname{fid},'gisette')
          testy = -testy;
       end
       hasTestFile = 1;
    elseif exist([probname,'-tX.txt']) || exist([probname,'-tX']);
       if strcmp(fname{fid},'dorothea')
          [testy,testXT] = readformatDorothea([probname,'-t']);     
       end
       hasTestFile = 1;
    end        
%%
%% remove zero features
%%
    normXT = sqrt(sum(XT.*XT)); 
    nzcol = find(normXT>0); 
    if (length(nzcol) < length(normXT)) %%&& (fid~=17)
       XT = [XT(:,nzcol), 0*ones(size(XT,1),1)]; 
       fprintf('\n removed %2.0f zero features',length(normXT)-length(nzcol));
       if (hasTestFile)
          testXT = [testXT(:,nzcol), 0*ones(size(testXT,1),1)]; 
       end     
    end
    [sampsize,dim] = size(XT); 
%%
%% Apply DWD to the data
%%
    if (algorithm <= 3) && ~strcmp(fname{fid},'gisette-scale')
       fprintf('\n Run DWD: exponent = %1.0f',expon);
       scalefeature = 0; DD = 1;    
       if (dim > 0.5*sampsize) %% important
          %% scale the features to have roughly same magnitude
          normXT = full(sqrt(sum(XT.*XT)))';       
          fprintf('\n max-normXT, min-normXT = %3.2e, %3.2e',max(normXT),min(normXT));
          if (max(normXT) > 2*min(normXT))
             if (dim > 3*sampsize) 
                fprintf('\n Scale columns of XT to have moderate norm...');               
                DD = spdiags(1./max(1,sqrt(normXT)),0,dim,dim);
             else
                fprintf('\n Scale columns of XT to have unit norm...'); 
                DD = spdiags(1./max(1,normXT),0,dim,dim);              
             end
             XT = XT*DD; 
             scalefeature = 1;           
          end
       end
       fprintf('\n %s: time taken to read and scale training data = %3.2f',fname{fid},rtime);
    end
%%
    tstart = clock;
    X = XT'; % Here we put the samples as columns 
    if (algorithm == 1) || (algorithm == 2)
        fprintf('\n compute penalty parameter...');
        [C,ddist] = penaltyParameter(X,y,expon);
        if strcmp(fname{fid},'farm-ads'); C = 5*C; end %%important
        if strcmp(fname{fid},'url-svm')
           C = 50*C;            
           if (Dayinterval <= 5); C = 5*C; end            
        end   
        if strcmp(fname{fid},'gisette-scale');
           if (expon==1); C=1e2; elseif (expon==2); C=1e3; end
        end
        options.method = algorithm; 
        [w,betaHat,xi,r,alpha,info,runhist] = genDWDweighted(X,y,C,expon,options);
        ttime = etime(clock,tstart);
        info.r = r; info.alpha = alpha;
        info.w = w; info.betaHat = betaHat; info.xi = xi; 
        info.normXT = normXT; 
        res = XT*w+betaHat;    
        error = length(find(y.*sign(res)<=0))/length(res);    
        info.trainerr = error*100;
        iter = info.iter;
    elseif (algorithm == 3)
        fprintf('\n compute penalty parameter...');
        [C,ddist]=penaltyParameter(X,y,expon);
        if (2*sampsize < dim)
           C = C*3;
        end
        if (expon == 1)
           [w,betaHat,xi,info] = DWDr1_ipm(X,y,C);
        elseif (expon ==2)
           [w,betaHat,xi,info] = DWDr2_ipm(X,y,C);
        else
           [w,betaHat,xi,info] = DWDrq_ipm(X,y,C,expon);
        end
        ttime = etime(clock,tstart);
        info.w = w; info.betaHat = betaHat; info.xi = xi; 
        info.normXT = normXT; 
        res = XT*w+betaHat;    
        error = length(find(y.*sign(res)<=0))/length(res);    
        info.trainerr = error*100;
        iter = info.iter;
    elseif (algorithm == 4)
        %% Compare to the solver for LIBSVM
        if (fid==14)
           y(find(y>0)) = 1;
        end
        nu = nuset(fid);
        options.kernel = 'lin';
        options.method = 'LIBSVM'; 
        %options.d = 2;       
        %options.b = [];
        options.eps = 1e-5; 
        % heuristic: whether to use the shrinking heuristics of LIBSVM (0 or 1)
        options.heuristic = 0;
        if (fid~=17)
           info = SVMsolve(y,XT,nu,options);
        else
           info.time = '>24hrs';
           info.accuracy = 'not solved';
        end
        ttime = etime(clock,tstart);
        info.sampsize = sampsize;
        info.dimension = dim;
        info.betaHat = info.b;
        iter = info.model.iter;
        error = 1-info.accuracy/100;
        fprintf('\n time take for SVM = %3.2f',info.time);
    elseif (algorithm == 5)
        %% Compare to the solver for LIBLINEAR
        if (fid==14)
           y(find(y>0)) = 1;
        end
        options.kernel = 'lin';
        options.method = 'LIBLINEAR';
        %options.b = -1;
        options.eps = 1e-5;
        info = SVMsolve(y,sparse(XT),penalty(fid),options);
        ttime = etime(clock,tstart);
        info.sampsize = sampsize;
        info.dimension = dim;
        info.w = info.model.w(1:dim)'; 
        info.betaHat = 0;
        res = XT*info.w+info.betaHat;
        error = length(find(y.*sign(res)<0))/length(res);
        info.accuracy = error*100;
        iter = info.model.iter;
        fprintf('\n time take for linear SVM = %3.2f',ttime);
    end
    info.readTime = rtime;
    info.totalTime = rtime + ttime;
    if hasTestFile
       beta = info.betaHat;
       testres = testXT*info.w +beta;        
       testerr = length(find(testy.*sign(testres)<=0))/length(testres);    
       info.testerr = testerr*100;
       info.testsamp = size(testXT,1);
       fprintf('\n error of classification (testing)  = %3.2f (%%)',testerr*100);
    end
    %% print results    
    idxpos = find(y>0); idxneg = find(y<0);
    fprintf('\n dataset = %s',fname{fid});
    fprintf('\n sample size = %3.0f, feature dimension = %3.0f',sampsize,dim);
    fprintf('\n positve sample = %3.0f, negative sample = %3.0f',length(idxpos),length(idxneg)); 
    fprintf('\n total training time (including I/O)   = %3.2f',info.totalTime); 
    fprintf('\n number of iteration  = %3.0f',iter);
    fprintf('\n error of classification (training) = %3.2f (%%)',error*100);
    fprintf('\n------------------------------------------------------\n');
    %% save results
    [user,sys] = memory;
    if algorithm == 3 || algorithm == 4 || algorithm == 5
        if (saveyes)
            eval(['save ',savefname,' info'])       
        end
    else
        runhist1 = []; runhist2 = []; runhist4 = []; 
        info1 = []; info2 = []; info4 = [];
        eval(['info',num2str(expon),'=info;']);
        eval(['runhist',num2str(expon),'=runhist;']);
        if (saveyes)
           eval(['save ',savefname,' info1 info2 info4 runhist1 runhist2 runhist4'])       
        end
    end
end    
%********************************************************************