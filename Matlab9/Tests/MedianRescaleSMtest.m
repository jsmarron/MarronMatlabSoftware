disp('Running MATLAB script file MedianRescaleSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION MedianRescaleSM,
%    interquartile range

itest = 111 ;     %  1,...,10 - simple parameter tests
                  %  101 - simplest pairwise toy alternative splicing example
                  %  102 - Gaussian noise pairwise toy alternative splicing example
                  %  103 - Systematic noise pairwise toy alternative splicing example
                  %  104 - Systematic nonegative noise pairwise toy alternative splicing example
                  %  111 - Multiple Curve alternative splicing example 


if itest < 100 ;

  if itest == 1 ;   

    disp(' ') ;
    disp('Check simple one first') ;

    CurveIn = [2 2 4]
    Target = [3 3 1]

    CurveOut = MedianRescaleSM(CurveIn,Target) 


  elseif itest == 2 ;

    disp(' ') ;
    disp('Check tied case') ;

    CurveIn = [1 2 5]
    Target = [2 1 1]

    CurveOut = MedianRescaleSM(CurveIn,Target) 


  elseif itest == 3 ;

    disp(' ') ;
    disp('Check opposite tied case') ;

    CurveIn = [1 2 1]
    Target = [2 1 5]

    CurveOut = MedianRescaleSM(CurveIn,Target) 


  elseif itest == 4 ;

    disp(' ') ;
    disp('Check uneven input lengths') ;

    CurveIn = [1 2 1 8]
    Target = [2 1 5]

    CurveOut = MedianRescaleSM(CurveIn,Target) 


  elseif itest == 5 ;

    disp(' ') ;
    disp('Check behavior with 0s') ;

    CurveIn = [1 1 0 1 1]
    Target = [2 2 1 0 5]

    CurveOut = MedianRescaleSM(CurveIn,Target) 


  elseif itest == 6 ;

    disp(' ') ;
    disp('Check behavior with all but one 0s') ;

    CurveIn = [0 0 0 1 1]
    Target = [2 0 1 0 5]

    CurveOut = MedianRescaleSM(CurveIn,Target) 


  elseif itest == 7 ;

    disp(' ') ;
    disp('Check behavior with all 0s') ;

    CurveIn = [0 0 0 1 1]
    Target = [2 0 1 0 0]

    CurveOut = MedianRescaleSM(CurveIn,Target) 


  elseif itest == 8 ;

    disp(' ') ;
    disp('Check behavior with Column Inputs') ;

    CurveIn = [2; 2; 4]
    Target = [3; 3; 1]

    CurveOut = MedianRescaleSM(CurveIn,Target) 


  elseif itest == 9 ;

    disp(' ') ;
    disp('Check behavior with Matrix Input') ;

    CurveIn = [[2 2 4]; [1 1 5]] 
    Target = [3 3 1]

    CurveOut = MedianRescaleSM(CurveIn,Target) 


  elseif itest == 10 ;

    disp(' ') ;
    disp('Check Row and Column inputs') ;

    CurveIn = [2 2 4]
    Target = [3; 3; 1]

    CurveOut = MedianRescaleSM(CurveIn,Target) 


  end ;



else ;    %  do more complicated examples

  figure(1) ;
  clf ;

  if  itest == 101  | ...
      itest == 102  | ...
      itest == 103  | ...
      itest == 104  ;

    randn('state',93287049873) ;
    if itest == 101 ;    % simplest pairwise toy alternative splicing example

      target = [zeros(10,1); ones(50,1); zeros(15,1); ones(60,1); zeros(10,1); ...
                ones(80,1); zeros(15,1); ones(50,1); zeros(10,1)] ;
      cin = 2.5 * [zeros(10,1); ones(50,1); zeros(15,1); ones(60,1); zeros(10,1); ...
                zeros(80,1); zeros(15,1); ones(50,1); zeros(10,1)] ;
      d = length(target) ;
      titstr = 'Simplest' ;

    elseif itest == 102 ;    % Gaussian noise pairwise toy alternative splicing example

      target = [zeros(10,1); ones(50,1); zeros(15,1); ones(60,1); zeros(10,1); ...
                ones(80,1); zeros(15,1); ones(50,1); zeros(10,1)] ;
      cin = 2.5 * [zeros(10,1); ones(50,1); zeros(15,1); ones(60,1); zeros(10,1); ...
                zeros(80,1); zeros(15,1); ones(50,1); zeros(10,1)] ;
      d = length(target) ;

      %  Add Gaussian noise
      %
      sig = 0.05 ;
      target = target + sig * randn(d,1) ;
      cin = cin + sig * randn(d,1) ;
      titstr = 'Gaussian noise' ;

    elseif itest == 103 ;    % Systematic noise pairwise toy alternative splicing example

      target = [zeros(10,1); ones(50,1); zeros(15,1); ones(60,1); zeros(10,1); ...
                ones(80,1); zeros(15,1); ones(50,1); zeros(10,1)] ;
      cin = 2.5 * [zeros(10,1); ones(50,1); zeros(15,1); ones(60,1); zeros(10,1); ...
                zeros(80,1); zeros(15,1); ones(50,1); zeros(10,1)] ;
      d = length(target) ;

      %  Multiply by systematic noise
      %
      rand('state',983475093784) ;
      pts = randi(d,[50 1]) ;
        paramstruct = struct('vh',5,...
                             'vxgrid',[1 d d]) ;
      factor = kdeSM(pts,paramstruct) ;
      target = 180 * factor .* target ;
      cin = 180 * factor .* cin ;

      %  Add Gaussian noise on top
      %
      sig = 0.05 ;
      target = target + sig * randn(d,1) ;
      cin = cin + sig * randn(d,1) ;
      titstr = 'Systematic noise' ;

    elseif itest == 104 ;    % Systematic nonnegative noise pairwise toy alternative splicing example

      target = [zeros(10,1); ones(50,1); zeros(15,1); ones(60,1); zeros(10,1); ...
                ones(80,1); zeros(15,1); ones(50,1); zeros(10,1)] ;
      cin = 2.5 * [zeros(10,1); ones(50,1); zeros(15,1); ones(60,1); zeros(10,1); ...
                zeros(80,1); zeros(15,1); ones(50,1); zeros(10,1)] ;
      d = length(target) ;

      %  Multiply by systematic noise
      %
      rand('state',983475093784) ;
      pts = randi(d,[50 1]) ;
        paramstruct = struct('vh',5,...
                             'vxgrid',[1 d d]) ;
      factor = kdeSM(pts,paramstruct) ;
      target = 180 * factor .* target ;
      cin = 180 * factor .* cin ;

      %  Add Gaussian noise on top
      %
      sig = 0.05 ;
      target = abs(target + sig * randn(d,1)) ;
      cin = abs(cin + sig * randn(d,1)) ;
      titstr = 'Systematic nonnegative noise' ;

    end ;


    subplot(3,1,1) ;
      plot((1:d)',target,'b-',(1:d)',cin,'r--','LineWidth',3) ;
      axis([0 d+1 -0.3 3.5]) ;
      title([titstr ' Toy Alternative Splicing Example, before normalization']) ;
      legend({'Target','Input'}) ;

    cars = cin * sum(target) / sum(cin) ;
    subplot(3,1,2) ;
      plot((1:d)',target,'b-',(1:d)',cars,'r--','LineWidth',3) ;
      axis([0 d+1 -0.3 3.5]) ;
      title([titstr ' Toy Alternative Splicing Example, area rescaled']) ;
      legend({'Target','Input'}) ;

    cout = MedianRescaleSM(cin,target) ;
    subplot(3,1,3) ;
      plot((1:d)',target,'b-',(1:d)',cout,'r--','LineWidth',3) ;
      axis([0 d+1 -0.3 3.5]) ;
      title([titstr ' Toy Alternative Splicing Example, median rescaled']) ;
      legend({'Target','Input'}) ;

    orient tall ;
    print('-dpsc2',['MedianRescaleSMTestIT' num2str(itest)]) ;


  elseif itest == 111 ;    %  Multiple Curve alternative splicing example

      target = [zeros(10,1); ones(50,1); zeros(15,1); ones(60,1); zeros(10,1); ...
                ones(80,1); zeros(15,1); ones(50,1); zeros(10,1)] ;
      cin = 2.5 * [zeros(10,1); ones(50,1); zeros(15,1); ones(60,1); zeros(10,1); ...
                zeros(80,1); zeros(15,1); ones(50,1); zeros(10,1)] ;
      d = length(target) ;

      %  Multiply by systematic noise
      %
      rand('state',983475093784) ;
      pts = randi(d,[50 1]) ;
        paramstruct = struct('vh',5,...
                             'vxgrid',[1 d d]) ;
      factor = kdeSM(pts,paramstruct) ;
      target = 100 * factor .* target ;
      cin = 100 * factor .* cin ;

      %  Replicate and rescale
      %
      randn('state',983475093784) ;
      mcurve = vec2matSM(target,5) .* vec2matSM(0.7 * randn(1,5) + 4,d) ;
      mcurve = [mcurve (vec2matSM(cin,5) .* vec2matSM(1.0 * randn(1,5) + 2,d))] ;

      %  Add Gaussian noise on top
      %
      sig = 0.05 ;
      mcurve = abs(mcurve + sig * randn(d,10)) ;
      titstr = 'Replicated' ;


      %  Do rescaling
      %
      n = size(mcurve,2) ;
      vcts = sum(mcurve,1) ;
          %  total of all counts, for each curve
      [maxcts,imax] = max(vcts) ;
          % index of curve with biggest counts

      mars = [] ;
      mrsc = [] ;
      for i = 1:n ;
        mars = [mars (mcurve(:,i) * maxcts / vcts(i))] ;
        mrsc = [mrsc MedianRescaleSM(mcurve(:,i),mcurve(:,imax))] ;
      end ;


      subplot(3,1,1) ;
        plot((1:d)',mcurve(:,1:5),'b-',(1:d)',mcurve(:,6:10),'r--','LineWidth',1) ;
        title([titstr ' Toy Alternative Splicing Example, before normalization']) ;

      subplot(3,1,2) ;
        plot((1:d)',mars(:,1:5),'b-',(1:d)',mars(:,6:10),'r--','LineWidth',1) ;
        title([titstr ' Toy Alternative Splicing Example, area rescaled']) ;

      subplot(3,1,3) ;
        plot((1:d)',mrsc(:,1:5),'b-',(1:d)',mrsc(:,6:10),'r--','LineWidth',1) ;
        title([titstr ' Toy Alternative Splicing Example, median rescaled']) ;

      orient tall ;
      print('-dpsc2',['MedianRescaleSMTestIT' num2str(itest)]) ;



  end ;


end ;
