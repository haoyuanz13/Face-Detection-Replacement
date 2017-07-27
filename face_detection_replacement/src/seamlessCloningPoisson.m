function resultImg = seamlessCloningPoisson(sourceImg, targetImg, mask, offsetX, offsetY)
%% index pixel
[targetH, targetW, x] = size(targetImg);
indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY);

%% compute coefficient matrix A
coefM = getCoefMatrix(indexes);

%% compute solution vector
% each time one channel(color)
n = size(coefM, 2);
solvec = zeros(n, 3);
for i = 1: 3
    source = sourceImg(:, :, i);
    target = targetImg(:, :, i);
    solvec(:, i) = getSolutionVect(indexes, source, target, offsetX, offsetY);
end

%% reconstruct image 
red = mldivide(coefM, solvec(:, 1));
green = mldivide(coefM, solvec(:, 2));
blue = mldivide(coefM, solvec(:, 3));

resultImg = reconstructImg(indexes, red, green, blue, targetImg);
end