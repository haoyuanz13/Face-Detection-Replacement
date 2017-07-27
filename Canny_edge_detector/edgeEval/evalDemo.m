%% Evaluation demo

I = imread('../train_images_P1/101085.jpg');
I_bi = rgb2gray(I);
E = edge(I_bi, 'canny');
load('../ground_truth_P1/101085.mat');

[f precision recall] = edgeEval(E, groundTruth)

