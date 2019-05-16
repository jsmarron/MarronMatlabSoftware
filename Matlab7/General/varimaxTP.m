function [rotm,opt_amat] = varimaxTP(amat,target_basis)
% [ROTM,OPT_AMAT] = VARIMAXTP(AMAT,TARGET_BASIS)
%
%     Gives a (unnormalized) VARIMAX-optimal rotation of matrix AMAT:
%     The matrix  AMAT*ROTM  is optimal according to the VARIMAX
%     criterion, among all matricies of the form  AMAT*R  for  
%     R  an orthogonal matrix.  
%     Also (optionally) returns the rotated AMAT matrix
%     OPT_AMAT = AMAT*ROTM.
%
%     Uses the standard algorithm of Kaiser(1958), Psychometrika.
%
%  Arguments:
%  AMAT          ...  N by K matrix of "component loadings"
%  TARGET_BASIS  ...  (optional) an N by N matrix whose columns represent a 
%                     basis toward which the rotation will be oriented; the
%                     default is the identity matrix (the natural coordinate
%                     system); this basis need not be orthonormal, 
%                     but if it isn't, it should be
%                     used with great care!
%  Returns:
%  ROTM      ...  Optimizing rotation matrix
%  OPT_AMAT  ...  Optimally rotated matrix  (AMAT*ROTM)

%  Modified by Trevor Park in April 2002 from an original file by J.O. Ramsay

  MAX_ITER = 50;  % Maximum number of complete passes through column pairs
  EPSILON = 1e-7; % Stopping tolerance based on relative reduction in varimax

  amatd = size(amat);

  if length(amatd) ~= 2
    error('AMAT must be two-dimensional')
  end

  n = amatd(1);
  k = amatd(2);
  rotm = eye(k);

  if k == 1
    return
  end

  if nargin > 1
    if length(size(target_basis)) ~= 2
      error('TARGET_BASIS must be two-dimensional')
    end
    if all(size(target_basis) == [n,n])
      amat = target_basis\amat;
    else
      error('TARGET_BASIS must be a basis for the column space');
    end
  else
    target_basis = eye(n);
  end
  
  varnow = sum(var(amat.^2));
  not_converged = 1;
  iter = 0;
  while  not_converged  &  iter < MAX_ITER

    for j = 1:(k-1)
      for l = (j+1):k
        
        % Calculate optimal 2-D planar rotation angle for columns j,l
        phi_max = angle(n*sum(complex(amat(:,j),amat(:,l)).^4) - ...
                        sum(complex(amat(:,j),amat(:,l)).^2)^2) / 4;
        
        sub_rot = [ cos(phi_max) -sin(phi_max); sin(phi_max) cos(phi_max) ];
        
        amat(:,[j l]) = amat(:,[j l])*sub_rot;
        rotm(:,[j l]) = rotm(:,[j l])*sub_rot;

      end
    end

    varold = varnow;
    varnow = sum(var(amat.^2));
    
    if varnow == 0
      return
    end
    
    not_converged = ( (varnow - varold)/varnow > EPSILON );
    
    iter = iter + 1;
    
  end
  
  if iter >= MAX_ITER
    warning(['Maximum number of iterations reached in function ',mfilename]);
  end
  
  if nargout > 1
    opt_amat = target_basis*amat;
  end
