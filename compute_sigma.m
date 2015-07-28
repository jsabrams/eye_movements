%Purpose: compute the standard deviation of distances between a series of
%points and a reference point
%Inputs:    P_prime: an nx2 matrix of (x,y) positions
%           C: a reference (x,y) position (e.g., the centroid of P_prime)
%Output:    the standard deviation of distances between the points and the
%           reference
function sigma = compute_sigma(P_prime, C)
this_dist = compute_dist(P_prime, C);   %Get the distances
sigma = std(this_dist);                 %Compute their standard deviation