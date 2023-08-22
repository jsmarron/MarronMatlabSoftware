function sss2strmlnSM(marrow,vsigg,n,m,strmlntpb,strmlnsf)
% SSS2STRMLNSM, Function for SSS2, this overlays streamlines, on the current image.
%     Intended to be used by SSS2, for plotting gradient information
%   Steve Marron's matlab function
%     Note:  this assumes "matrix style coordinates", where
%                   indices are (i,j), 
%                              i indexes rows (vertical),
%                              j indexes columns (horizontal).
% Inputs:
%        marrow - matrix of arrow information, as from sssgrad.m
%         vsigg - vector of significant gradient information, also from sssgrad.m
%             n - number of rows in image
%             m - number of columns in image
%     strmlntpb - average number of touches per pixel box
%      strmlnsf - step size factor, for multiplying pixel
%                                           width to get step size
% Outputs:
%       Only graphics added to current axes.

%    Copyright (c) J. S. Marron 1999, 2001, 2023


nsigg = size(marrow,1) ;
          %  number of significant pixels 
          %       (i.e. number of rows of marrow)


if nsigg > 0    %  then have some pixels for streamlines

  vindmarrow = (1:nsigg)' ;
          %  vector of indices in marrow

  vtouch = zeros(nsigg,1) ;
          %  vector of times each pixel box has been touched

  msigg = reshape(vsigg,n,m) ;
          %  matrix with ones where have signficant gradient

  mindsigg = reshape(1:(n*m),n,m) ;
          %  matrix where entries are index in vector vsigg



  avgtpb = 0 ;
          %  average number of touches per pixel box
  
  %  Loop through streamlines
  %
  while avgtpb < strmlntpb

    vtouchtsl = zeros(nsigg,1) ;
          %  vector of touches for this streamline
          %  reset this vector, which has:
          %      1 when that pixel has been touched
          %      0 otherwise 
          %  in row of marrow coordinates

    %  Draw a random starting pixel
    %
    mintouch = min(vtouch) ;
         %  minimum number of times any pixel has been touched
    vindmt = vindmarrow(vtouch == mintouch) ;
         %  vector of indices to pixels, where have the minimum
         %  number of touches
    nindmt = length(vindmt) ;
         %  number of pixels with minimal touches

    if nindmt == 1            %  then just use that as starting pixel

      indstart = vindmt ;
          %  index (in marrow of starting pixel)

    else                     %  then choose one at random 

      vsiggtouch = zeros(n*m,1) ;
          %  long vector recording touches
      vtouchflag = (vtouch >= 1) ;
          %  ones where a pixel has been touched (marrow scale)
      indvsiggtouch = marrow(vtouchflag,1) ;
          %  indices in vsigg where has been a pixel touch ;
      vsiggtouch(indvsiggtouch) = ones(length(indvsiggtouch),1) ;
          %  long vector, with 1 where there as been a pixel touch
      mtouch = reshape(vsiggtouch,n,m) ;
          %  matrix with 1 for each pixel that has ben touched
      mtouch = conv2(mtouch,ones(3,3),'same') ;
          %  3x3 moving window sum of touches
      vsiggtouch = reshape(mtouch,n*m,1) ;
          %  3x3 sum of touches, in long vector form
      v3x3touch = vsiggtouch(marrow(:,1)) ;
          %  3x3 sum of touches, just for significant pixels
      v3x3touch = v3x3touch(vindmt) ;
          %  3x3 sum of touches, just for significant pixels,
          %      that have had the minimal number of touches

      vpwts = 100.^(-v3x3touch) ;
          %  probability weights, inversely proportional to number
          %  of touches in 3x3 window
      vpwts = vpwts / sum(vpwts) ;
          %  vector or probability weights

      vpbdry = cumsum(vpwts) ;
          %  vector (nindmt x 1) of right boundaries of intervals in [0,1]
          %  whose length is the desired probability

      vflag = (rand(1,1) < vpbdry) ;
          %  vector of 0's, until interval is to right of random point

      [~,randi] = max(vflag) ;
          %  randi is the location of the first 1, i.e. first interval
          %  with random point below boundary


      indstart = vindmt(randi) ;
          %  randomly chosen element of vindmt
          %  index (in marrow of starting pixel)

    end


    vtouchtsl(indstart) = 1 ; 
          %  record touch at starting pixel


    %  Draw a random starting point in pixel box
    %
    vstart = marrow(indstart,[2,3]) ;
          %  pixel center coordinates
    vstart = vstart + (rand(1,2) - .5) ;
          %  add a Uniform(-.5,.5) r.v.



    %  Construct rest of streamline in first direction
    %
    contflag = 1 ;
    curindmarrow = indstart ;
    curloc = vstart ;
    vstepraw = marrow(indstart,[4,5]) ;
    mloc = curloc ;
    while contflag == 1

      lastloc = curloc ;
      lastvstepraw = vstepraw ;
      lastind = curindmarrow ;
          %  last index (marrow coordinates)
      lastind = marrow(lastind) ;
          %  last index (vsigg coordinates)
      [i, j] = find(mindsigg == lastind) ;
          %  last index (matrix coordinates)
      lastind = [i, j] ;


      vstepraw = marrow(curindmarrow,[4,5]) ;
          %  gradient components (recall x-coordinate was first)
      vstep = strmlnsf * vstepraw ;
          %  adjust according to tuning parameter


      curloc = curloc + vstep ;
          %  current location of end of streamline

 
      curindmatrix = round(curloc) ;
          %  index of current location of end of streamline 
          %             (in matrix coordinates)


      if (1 <= curindmatrix(1) && curindmatrix(1) <= n)  && ...
                        (1 <= curindmatrix(2) && curindmatrix(2) <= m)
                                 %  then have landed inside image,
                                 %          so check for sig

        curindmarrow = mindsigg(curindmatrix(1),curindmatrix(2)) ;
            %  index of current location of end of streamline 
            %             (in vsigg coordinates)
        curindmarrow = find(marrow(:,1) == curindmarrow) ;
            %  index of current location of end of streamline 
            %             (in marrow coordinates)




        if vstepraw * lastvstepraw' >= 0
                                 %  then cos of angle between step vectors
                                 %       (note these are row vectors)
                                 %  is >= 0 (i.e. are going in same direction)

          contflag = msigg(curindmatrix(1),curindmatrix(2)) ;
              %  continue if this pixel is significant
  
        else      %  the angle is too sharp, so quit

          contflag = -1 ;
              %  quite, and also don't go to edge of pixel box

        end


      else       %  then have landed outside image, so quit

        contflag = 0 ;

      end


      if contflag == 0     %  Then will stop now, 
                           %  and should go to end of the streamline


        if abs(vstep(1)) < eps    %  then step is only in y direction

          w = (.5 - abs(lastloc(2) - lastind(2))) ./ abs(vstep(2)) ;
              %  weight factor to reduce this jump to hit boundary
              %  of this pixel

        elseif abs(vstep(2)) < eps    %  then step is only in x direction

          w = (.5 - abs(lastloc(1) - lastind(1))) ./ abs(vstep(1)) ;
              %  weight factor to reduce this jump to hit boundary
              %  of this pixel

        else   %  then step has two nonzero components

          w = ([.5,.5] - abs(lastloc - lastind)) ./ abs(vstep) ;
              %  vector of 2 candidates for weight for truncated step
              %  to reduce this jump to hit boundary of this pixel

          w = min(w) ;
              %  minimum stays within pixel in BOTH directions

        end


        curloc = lastloc + w * vstep ;    
          %  scale back the current step, to stay in current pixel


      else    %  then are continuing, so step was good

        vtouchtsl(curindmarrow) = 1 ;
          %  record touch at latest pixel

      end


      if contflag >= 0     %  then want to add this line segment

        mloc = [mloc; curloc] ;
          %  put new location on the bottom

      else     %  then have already stepped past an maximum,
               %  so delete last step, too


        mloc = mloc(1:(size(mloc,1)-1),:) ;


      end


    end          





    %  Construct rest of streamline in opposite direction
    %
    contflag = 1 ;
    curindmarrow = indstart ;
    curloc = vstart ;
    vstepraw = -marrow(indstart,[4,5]) ;
    while contflag == 1

      lastloc = curloc ;
      lastvstepraw = vstepraw ;
      lastind = curindmarrow ;
          %  last index (marrow coordinates)
      lastind = marrow(lastind) ;
          %  last index (vsigg coordinates)
      [i, j] = find(mindsigg == lastind) ;
          %  last index (matrix coordinates)
      lastind = [i, j] ;


      vstepraw = -marrow(curindmarrow,[4,5]) ;
          %  gradient components (recall x-coordinate was first)
          %  this time always step in negative gradient direction
      vstep = strmlnsf * vstepraw ;
          %  adjust according to tuning parameter


      curloc = curloc + vstep ;
          %  current location of end of streamline

 
      curindmatrix = round(curloc) ;
          %  index of current location of end of streamline 
          %             (in matrix coordinates)


      if (1 <= curindmatrix(1) && curindmatrix(1) <= n)  && ...
                        (1 <= curindmatrix(2) && curindmatrix(2) <= m)
                                 %  then have landed inside image,
                                 %          so check for sig

        curindmarrow = mindsigg(curindmatrix(1),curindmatrix(2)) ;
          %  index of current location of end of streamline 
          %             (in vsigg coordinates)
        curindmarrow = find(marrow(:,1) == curindmarrow) ;
          %  index of current location of end of streamline 
          %             (in marrow coordinates)


        if vstepraw * lastvstepraw' >= 0
                                 %  then cos of angle between step vectors
                                 %       (note these are row vectors)
                                 %  is >= 0 (i.e. are going in same direction)

          contflag = msigg(curindmatrix(1),curindmatrix(2)) ;
              %  continue if this pixel is significant
  
        else      %  the angle is too sharp, so quit

          contflag = -1 ;
              %  quite, and also don't go to edge of pixel box


        end
  
      else       %  then have landed outside image, so quit

        contflag = 0 ;

      end


      if contflag == 0     %  Then will stop now, 
                           %  get end of the streamline


        if abs(vstep(1)) < eps    %  then step is only in x direction

          w = (.5 - abs(lastloc(2) - lastind(2))) ./ abs(vstep(2)) ;
              %  weight factor to reduce this jump to hit boundary
              %  of this pixel

        elseif abs(vstep(2)) < eps    %  then step is only in x direction

          w = (.5 - abs(lastloc(1) - lastind(1))) ./ abs(vstep(1)) ;
              %  weight factor to reduce this jump to hit boundary
              %  of this pixel

        else   %  then step has two nonzero components

          w = ([.5,.5] - abs(lastloc - lastind)) ./ abs(vstep) ;
              %  vector of 2 candidates for weight for truncated step
              %  to reduce this jump to hit boundary of this pixel

          w = min(w) ;
              %  minimum stays within pixel in BOTH directions

        end


        curloc = lastloc + w * vstep ;    
          %  scale back the current step, to stay in current pixel

      else    %  then are continuing, so step was good

        vtouchtsl(curindmarrow) = 1 ;
          %  record touch at latest pixel

      end


      if contflag >= 0     %  then want to add this line segment

        mloc = [curloc; mloc] ;
          %  put new location on the top

      else     %  then have already stepped past a minimum,
                 %  so delete last step, too

        mloc = mloc(2:size(mloc,1),:) ;

      end


    end       



    hold on ;
      plot(mloc(:,2),mloc(:,1),'g-') ;
                        %    Note:  reverse i and j, since "plot"
                        %           works in Cartesian coordinates
    hold off ;



    vtouch = vtouch + vtouchtsl ;

    avgtpb = mean(vtouch) ;



  end




end 
