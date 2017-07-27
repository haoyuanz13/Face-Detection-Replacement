%%CIS 581 Project 1 Test Script - Fall 2013
% This script passes input similar to what will be tested to the functions
% and tests that the output is in the correct format.
% This is not a test of correctness of the operations themselves

clear;
close all;
pass = true;
%% Canny Edge Test
I = imread('101085.jpg');

E = cannyEdge(I);

if ndims(E) ~= 2,
    fprintf('incorrect edge map size\n');
    pass = false;
end

szI = size(I);
szE = size(E);
if(szI(1) ~= szE(1) || szI(2) ~= szE(2))
    fprintf('Edge map not the same size as the input image\n');
    pass = false;
end

if ~isa(E,'logical')
    fprintf('Edge map is not logical\n');
    pass = false;
end

figure, subplot(1,2,1), imshow(I); subplot(1,2,2), imshow(E);

if pass
    fprintf('Tests Passed\n');
end



