function result = fit_dj_orthosvd(C1, C2, L, nstarts, opts)
%FIT_DJ_ORTHOSVD Orthogonal doubly-joint SVD with additive SS.
%  Written by Patrick Lopatto
%
% Model:
%   C_k ~= A * diag(Gamma(k,:)) * B',  k = 1,2,
%   A' * A = I,  B' * B = I.
%
% The component SS values sum additively:
%   RawSS = sum_l eta_l^2 + ResidSS,
%   eta_l^2 = Gamma(1,l)^2 + Gamma(2,l)^2.

    if nargin < 4 || isempty(nstarts)
        nstarts = 20;
    end
    if nargin < 5
        opts = struct();
    end

    maxiters = local_getopt(opts, 'maxiters', 1000);
    tol      = local_getopt(opts, 'tol', 1e-10);
    seed     = local_getopt(opts, 'seed', 1);
    verbose  = local_getopt(opts, 'verbose', false);

    [rU,rV] = size(C1);
    if any(size(C2) ~= [rU,rV])
        error('C1 and C2 must have the same size.');
    end
    if L > min(rU,rV)
        error(['For the paired orthogonal SVD-like model, ', ...
               'L must be at most min(size(C1)).']);
    end

    bestObj = -Inf;
    bestA = [];
    bestB = [];
    bestHist = [];
    bestStart = 0;

    for s = 1:nstarts
        if s == 1
            % Deterministic marginal-SVD start.
            [A0,B0] = local_deterministic_start(C1, C2, L);
        else
            % Random orthonormal starts.
            rng(seed + s - 2);
            [A0,~] = qr(randn(rU,L), 0);
            [B0,~] = qr(randn(rV,L), 0);
        end

        [A,B,objhist] = local_optimize(C1, C2, A0, B0, ...
                                       maxiters, tol, verbose);
        obj = objhist(end);
        if obj > bestObj
            bestObj = obj;
            bestA = A;
            bestB = B;
            bestHist = objhist;
            bestStart = s;
        end
    end

    A = local_fixsigns(bestA);
    B = local_fixsigns(bestB);
    Gamma = local_gamma(C1, C2, A, B);

    % Sort components by decreasing additive component SS.
    eta2 = sum(Gamma.^2, 1);
    [eta2,idx] = sort(eta2, 'descend');
    A = A(:,idx);
    B = B(:,idx);
    Gamma = Gamma(:,idx);
    eta = sqrt(eta2);

    C1hat = A * diag(Gamma(1,:)) * B';
    C2hat = A * diag(Gamma(2,:)) * B';

    RawSS = norm(C1,'fro')^2 + norm(C2,'fro')^2;
    ComponentSS = eta2;
    ModelSS = sum(ComponentSS);
    ResidSS_direct = norm(C1 - C1hat,'fro')^2 + ...
                     norm(C2 - C2hat,'fro')^2;
    ResidSS_additive = RawSS - ModelSS;

    result.A = A;
    result.B = B;
    result.Gamma = Gamma;
    result.eta = eta;
    result.ComponentSS = ComponentSS;
    result.RawSS = RawSS;
    result.ModelSS = ModelSS;
    result.ResidSS = ResidSS_additive;
    result.ResidSS_direct = ResidSS_direct;
    result.RelErr = sqrt(max(ResidSS_additive,0) / RawSS);
    result.ExplainedFraction = ComponentSS / RawSS;
    result.CumulativeExplainedFraction = cumsum(ComponentSS) / RawSS;
    result.BlockSS = [norm(C1,'fro')^2; norm(C2,'fro')^2];
    result.BlockComponentSS = Gamma.^2;
    result.BlockResidualSS = result.BlockSS - sum(Gamma.^2,2);
    result.C1hat = C1hat;
    result.C2hat = C2hat;
    result.additive_check = RawSS - ModelSS - ResidSS_direct;
    result.best_start = bestStart;
    result.objhist = bestHist;
end

function [A,B,objhist] = local_optimize(C1, C2, A, B, ...
                                        maxiters, tol, verbose)
    obj = local_objective(C1, C2, A, B);
    objhist = obj;

    for iter = 1:maxiters
        Gamma = local_gamma(C1, C2, A, B);

        GA = 2 * (C1 * B * diag(Gamma(1,:)) + ...
                  C2 * B * diag(Gamma(2,:)));
        GB = 2 * (C1' * A * diag(Gamma(1,:)) + ...
                  C2' * A * diag(Gamma(2,:)));

        % Project Euclidean gradients onto the Stiefel tangent spaces.
        RA = GA - A * ((A' * GA + GA' * A) / 2);
        RB = GB - B * ((B' * GB + GB' * B) / 2);
        gradnorm = sqrt(norm(RA,'fro')^2 + norm(RB,'fro')^2);

        if gradnorm < tol * (1 + abs(obj))
            break;
        end

        step = 1;
        improved = false;
        for bt = 1:40
            [Anew,~] = qr(A + step * RA, 0);
            [Bnew,~] = qr(B + step * RB, 0);
            objnew = local_objective(C1, C2, Anew, Bnew);
            if objnew >= obj
                improved = true;
                break;
            end
            step = step / 2;
        end

        if ~improved
            break;
        end

        if verbose
            disp(['iter ' num2str(iter) ', objective = ' num2str(objnew)]);
        end

        if abs(objnew - obj) <= tol * (1 + abs(obj))
            A = Anew;
            B = Bnew;
            obj = objnew;
            objhist(end+1) = obj; %#ok<AGROW>
            break;
        end

        A = Anew;
        B = Bnew;
        obj = objnew;
        objhist(end+1) = obj; %#ok<AGROW>
    end
end

function [A,B] = local_deterministic_start(C1, C2, L)
    SU = C1*C1' + C2*C2';
    SV = C1'*C1 + C2'*C2;
    SU = (SU + SU') / 2;
    SV = (SV + SV') / 2;

    [VU,DU] = eig(SU);
    [~,iu] = sort(diag(DU), 'descend');
    A = VU(:,iu(1:L));

    [VV,DV] = eig(SV);
    [~,iv] = sort(diag(DV), 'descend');
    B = VV(:,iv(1:L));

    A = local_fixsigns(A);
    B = local_fixsigns(B);
end

function Gamma = local_gamma(C1, C2, A, B)
    L = size(A,2);
    Gamma = zeros(2,L);
    for l = 1:L
        Gamma(1,l) = A(:,l)' * C1 * B(:,l);
        Gamma(2,l) = A(:,l)' * C2 * B(:,l);
    end
end

function obj = local_objective(C1, C2, A, B)
    Gamma = local_gamma(C1, C2, A, B);
    obj = sum(Gamma(:).^2);
end

function Q = local_fixsigns(Q)
    for j = 1:size(Q,2)
        [~,idx] = max(abs(Q(:,j)));
        if Q(idx,j) < 0
            Q(:,j) = -Q(:,j);
        end
    end
end

function value = local_getopt(opts, name, default)
    if isfield(opts, name) && ~isempty(opts.(name))
        value = opts.(name);
    else
        value = default;
    end
end
