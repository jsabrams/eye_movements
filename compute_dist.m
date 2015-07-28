%Purpose: compute the distance between points (can be one to one, one to
%many, many to one)
%Inputs:    p: an nx2 matrix of (x,y) positions where n is the number of
%           positions
%           C: an nx2 matrix of (x,y) positons where n is the number of
%           positions
%Output:    dist: the distance between the points in p and the points in C
function dist = compute_dist(p, C)
%Calculate the Eculidian distance
dist = sqrt(((p(:,1) - C(:,1)) .^ 2) +  ((p(:,2) - C(:,2)) .^ 2)); 