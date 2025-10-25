function T = dctmtx(N)  % DCT coefficient matrix
[cc,rr] = meshgrid(0:N-1);

T = sqrt(2 / N) * cos(pi * (2*cc + 1) .* rr / (2 * N));
T(1,:) = T(1,:) / sqrt(2);
end

function C = dct2(A) % 2D DCT
T = dctmtx(size(A,1));
C = T * A * T';
end

function A = dfti2(C) % 2D Inverse DCT
T = dctmtx(size(C,1));
A = T' * C * T;
end


function quality = getQualityMatrix(quality) % Quality matrixfor given quality
Q50 = [16 11 10 16 24 40 51 61;
   12 12 14 19 26 58 60 55;
   14 13 16 24 40 57 69 56;
   14 17 22 29 51 87 80 62;
   18 22 37 56 68 109 103 77;
   24 35 55 64 81 104 113 92;
   49 64 78 87 103 121 120 101;
   72 92 95 98 112 100 103 99];


      if quality < 50
     S = 50 / quality;
      else
     S = (100 - quality) / 50;
      end

      quality = round(Q50 * S);
      quality(quality < 1) = 1;
end

function CI = compress(I, quality) % Compress image

blockSize = 8;
[rows, cols] = size(I);
CI = zeros(size(I));

for r = 1:blockSize:rows
   for c = 1:blockSize:cols
   block = I(r:min(r+blockSize-1, rows), c:min(c+blockSize-1, cols)) - 128;
   DCT = dct2(block); % Apply DCT for each block
   qualityMatrix = getQualityMatrix(quality);
   DCT = round(DCT ./ qualityMatrix);
   
   CI(r:min(r+blockSize-1, rows), c:min(c+blockSize-1, cols)) = DCT;
   end
end

end

function I = decompress(CI, quality) % Decompress image

blockSize = 8;
[rows, cols] = size(CI);
I = zeros(size(CI));
for r = 1:blockSize:rows
   for c = 1:blockSize:cols
   block = CI(r:min(r+blockSize-1, rows), c:min(c+blockSize-1, cols));
   qualityMatrix = getQualityMatrix(quality);
   DCT = block .* qualityMatrix;
   IDCT = dfti2(DCT) + 128; % Apply Inverse DCT for each block

   I(r:min(r+blockSize-1, rows), c:min(c+blockSize-1, cols)) = IDCT;
   end
end

end


imageFiles = {'Monarch.mat', 'cameraman.mat', 'Parrots.mat'};
numImages = length(imageFiles);
images = cell(1, numImages);
for j = 1:numImages
   data = load(imageFiles{j});
   fieldName = fieldnames(data);
   images{j} = data.(fieldName{1});
end

forestImage = imread('forest.jpeg');
forestImage = im2gray(forestImage);
imageFiles{end+1} = 'forest.mat';

images{end+1} = forestImage;
numImages = numImages + 1; 

qualities = [90, 80 , 70, 60, 50, 40, 30, 20, 10, 5, 1];
numQualities = length(qualities);

numCols = 1 + numQualities;

figure('Name', 'Image Compression Results', 'NumberTitle', 'off');

for j = 1:numImages
   Image = images{j};
   
   I = double(Image);
   
   subplotIndex = (j - 1) * numCols + 1;
   subplot(numImages, numCols, subplotIndex);
   imshow(I, [0 255]);
   
   if j == 1
      title('Original');
   end
   
   ylabel(strrep(imageFiles{j}, '.mat', ''));
   
   K = nnz(I);
   xlabelStr = sprintf('PSNR: Inf dB\nNon-zeros: %d', K);
   xlabel(xlabelStr);
   
   for i = 1:numQualities
      quality = qualities(i);
      
      CI = compress(I, quality);
      Irec = decompress(CI, quality);
      
      mse = mean((I(:) - Irec(:)).^2);
      PSNRdB = 10 * log10(255^2 / mse);
      
      K = nnz(CI);
      
      subplotIndex = (j - 1) * numCols + (i + 1);
      subplot(numImages, numCols, subplotIndex);
      imshow(Irec, [0 255]);
      
      if j == 1
         titleStr = sprintf('Quality: %d', quality);
         title(titleStr);
      end
      
      xlabelStr = sprintf('PSNR: %.2f dB\nNon-zeros: %d', PSNRdB, K);
      xlabel(xlabelStr);

      % Save the results and output images
      baseFileName = lower(strrep(imageFiles{j}, '.mat', ''));
      
      if ~exist('output', 'dir')
         mkdir('output');
      end
      
      if i == 1
          originalFileName = sprintf('output/%s_original.png', baseFileName);
          imwrite(uint8(I), originalFileName);
      end

      fileName = sprintf('output/%s_q%d.png', baseFileName, quality);
      imwrite(uint8(Irec), fileName);

      resultsFileName = 'output/results.txt';
      if j == 1 && i == 1
          fileID = fopen(resultsFileName, 'w');
          fprintf(fileID, 'Image,Quality,PSNR_dB,NonZeros\n');
      else
          fileID = fopen(resultsFileName, 'a');
      end
      
      fprintf(fileID, '%s,%d,%.2f,%d\n', baseFileName, quality, PSNRdB, K);
      fclose(fileID);
   end
end
