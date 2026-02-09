
%%%%%% Inputs %%%%%%%%%%
% c = ratio of dims
% singVals = singular values of data
% folderName = name of folder to save plots, crossing points, and set sizes
% alpha1 = Number between 0 and 1. Tuning parameter for percentile of MP distribution to choose for
% lower bound of Shatsigma window. 
% alpha2 = Number between 0 and 1.  Tuning parameter for percentile of MP distribution to choose for
% upper bound of Shatsigma window (note upperbound is 1-alpha2). 
% omega = Number between 0 and 1. Tuning parameter which says how large the cardinality of Shatsigma
% must be to be in consideration. 
% sve = true or false save plot in folder Pathplots as well as set sizes
% and crossing points

%%%%%%% Outputs %%%%%%%%%%
% Rho = ratio of empirical and scaled theoretical median for each candidate
% sigma = list of candidates in search grid
% sigHatEJC = TriME 

% -------------------------------------------------------------------------
% TriME Noise Estimation
%
% This file contains supporting functions modified from those in the
% `optimal_shrinkage.m` code by:
%     Matan Gavish and David Donoho (Stanford University, 2013)
%
% Author: Emma Mitchell emmamit@email.unc.edu, 2025
%
% This program is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation, either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License along with
% this program.  If not, see <http://www.gnu.org/licenses/>.
% -------------------------------------------------------------------------


function [sigHatEJC, Rho, sigma] = TriME(c, singVals, number, folderName, alpha1, alpha2, omega, sve)
    
    if sve == true
        % Create or check for existence of the folder to save plots
        if ~exist(folderName, 'dir')
            mkdir(folderName);
        end
        
        if ~exist([folderName '/pathPlots'], 'dir')
            mkdir([folderName '/pathPlots']);
        end
    end

    % set values of sigma to search over
    upper = 2*max(singVals)/(1+sqrt(c));
    lower = min(singVals)/ (1+sqrt(c));
    sigma = lower:.001:upper;

    % preallocate arrays
    S = cell(length(sigma), 1);
    medS = zeros(length(sigma), 1);
    Rho = zeros(length(sigma), 1);
    crossSigma = []; 
    sizeSet = [];
    LBnd = zeros(length(sigma),1);
    UBnd = zeros(length(sigma),1);
    MP = QuantMarcenkoPastur(c,(alpha1+1-alpha2)/2);
    MP_low = QuantMarcenkoPastur(c,alpha1);
    MP_high = QuantMarcenkoPastur(c,1-alpha2);

    
    parfor i = 1:length(sigma)
        % compute lower and upper bounds of window for current sigma
        LBnd(i) = sigma(i)*(MP_low);
        UBnd(i) = sigma(i)*(MP_high);


        % extract singular values within window
        validS = singVals(singVals >= LBnd(i) & singVals <= UBnd(i));
        
        S{i} = validS;

        if ~isempty(validS)
            medS(i) = quantile(validS, .5); 
        else 
            medS(i) = NaN;
        end
        
        % calculate values for rho statistics
        Rho(i) = medS(i)/(sigma(i)*(MP)); 
       
    end

    for i = 2:length(sigma)
           if  (Rho(i) < 1 && Rho(i-1) > 1)
                crossSigma = [crossSigma sigma(i)];
                sizeSet = [sizeSet length(S{i})];
            end
    end
  

    % Choose sigma which is the first sigma where rho=1 that has at least omega% elements in S 
    if sum(sizeSet >= length(singVals)*omega) > 0
        crossSigmaGreater = crossSigma(sizeSet >= length(singVals)*omega);
        sigHatEJC = crossSigmaGreater(1); %first element
    else 
        disp(['error largest cardinality is ', num2str(max(sizeSet)), "when it should be", num2str(length(singVals)*omega)]);
        [~, maxIndex] = max(sizeSet);
        sigHatEJC = crossSigma(maxIndex);
    end

    
    % plot rho
    if sve == true
        figure;
        plot(sigma, Rho, 'b-');
        hold on;
        line(xlim, [1 1], 'Color', 'r', 'LineStyle', '--');
       
        xlabel('Candidate Sigma');
        ylabel('Rho');
        title(sprintf('Test %d Rho Plot', number));
        grid on;
        grid minor;
       
        hold off;
        
        plotFileName = fullfile(folderName, 'pathPlots', sprintf('RhoPlot_Test%d.png', number));
        saveas(gcf, plotFileName);
        close(gcf); 

        % Save crossings 
        saveFileName = fullfile(folderName, sprintf('sizeSet%d.mat', number));
        save(saveFileName, 'sizeSet');

        % Save set sizes to the current directory
        saveFileName = fullfile(folderName, sprintf('Crossings_Number%d.mat', number));
        save(saveFileName, 'crossSigma');
      
    end
    
end


function quant = QuantMarcenkoPastur(c,quantile)
    MarPas = @(x) 1 - incMarPas(x, c, 0);
    lobnd = (1 - sqrt(c));
    hibnd = (1 + sqrt(c));
    change = 1;
    while change && (hibnd - lobnd > .00001)
        change = 0;
        x = linspace(lobnd, hibnd, 21);
        for i = 1:length(x)
            y(i) = MarPas(x(i));
        end
        if any(y < quantile)
            lobnd = max(x(y < quantile));
            change = 1;
        end
        if any(y > quantile)
            hibnd = min(x(y > quantile));
            change = 1;
        end
    end
    quant = (hibnd + lobnd) / 2;
end


function I = incMarPas(x0, c, gamma)
    if c > 1
        error('cBeyond');
    end
    topSpec = (1 + sqrt(c));
    botSpec = (1 - sqrt(c));
    MarPas = @(x) IfElse((topSpec.^2 - x.^2) .* (x.^2 - botSpec.^2) > 0, ...
                         sqrt((topSpec.^2 - x.^2) .* (x.^2 - botSpec.^2)) ./ (c .* x) ./ (pi), ...
                         0);
    if gamma ~= 0
       fun = @(x) (x.^gamma .* MarPas(x));
    else
       fun = @(x) MarPas(x);
    end
    I = integral(fun, x0, topSpec);

    function y = IfElse(Q, point, counterPoint)
        y = point;
        if any(~Q)
            if length(counterPoint) == 1
                counterPoint = ones(size(Q)) .* counterPoint;
            end
            y(~Q) = counterPoint(~Q);
        end
    end
end

