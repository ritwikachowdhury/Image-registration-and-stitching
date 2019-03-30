function [H, corrPtIdx] = findHomography(pts1,pts2)
    %   [H corrPtIdx] = findHomography(pts1,pts2)
    %	Find the homography between two planes using a set of corresponding
    %	points. PTS1 = [x1,x2,...;y1,y2,...]. RANSAC method is used.
    %	corrPtIdx is the indices of inliers.

    coef.minPtNum = 4;                  %Minimum number of points required to solve for homography matrix
    coef.iterNum = 30;                  %Maximum number of iterations allowed in the algorithm
    coef.thDist = 4;                    %Threshold value to determine when a data point fits a model
    coef.thInlrRatio = .1;              %Multiplied by total number of points, gives the number of close data points required to assert that a model fits well to data

    [H, corrPtIdx] = ransac1(pts1,pts2,coef,@solveHomo,@calcDist);

end

function d = calcDist(H,pts1,pts2)
    %	Project PTS1 to PTS3 using H, then calcultate the distances between
    %	PTS2 and PTS3

    n = size(pts1,2);
    pts3 = H*[pts1;ones(1,n)];
    pts3 = pts3(1:2,:)./repmat(pts3(3,:),2,1);
    d = sum((pts2-pts3).^2,1);

end