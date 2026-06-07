function result = fit_dj_cp(X, L, nstarts)
% Patrick Lopatto's tensor decomposition
%
%  cp_als returns a ktensor, i.e., a CP decomposition stored in 
%        factorized form.
%
%  The optional cp_opt refinement starts from the best ALS solution 
%        and performs all-at-once optimization.
%
bestfit = -Inf;
bestM = [];
bestout = [];

% One deterministic HOSVD-style initialization
%{
[M,~,out] = cp_als(X, L, 'init', 'nvecs', ...
                      'tol', 1e-8, ...
                      'maxiters', 1000, ...
                      'printitn', 0, ...
                      'trace', true);
%}
%  Next version is due to 'nvecs' seeming to create
%  an error for more than 1 dimension
[M,~,out] = cp_als(X, L, ...
                      'tol', 1e-8, ...
                      'maxiters', 1000, ...
                      'printitn', 0, ...
                      'trace', true);
fit = out.fit_trace(end);
if fit > bestfit
  bestfit = fit;
  bestM = M;
  bestout = out;
end

% Random restarts
for s = 2:nstarts
  rng(s);
  [M,~,out] = cp_als(X, L, ...
                        'tol', 1e-8, ...
                        'maxiters', 1000, ...
                        'printitn', 0, ...
                        'trace', true);
  fit = out.fit_trace(end);
  if fit > bestfit
    bestfit = fit;
    bestM = M;
    bestout = out;
  end
end

bestM = arrange(bestM);
bestM = fixsigns(bestM);

% Optional direct-optimization refinement
[Mref,~,info] = cp_opt(X, L, 'init', bestM, 'printitn', 0);
Mref = arrange(Mref);
    %  arrange normalizes the columns and sorts the components by size.
Mref = fixsigns(Mref);
    %  fixsigns makes the sign convention more stable and easier to read.

result.bestfit_cpals = bestfit;
result.model_cpals = bestM;
result.trace_cpals = bestout;
result.model = Mref;
result.info_cpopt = info;


