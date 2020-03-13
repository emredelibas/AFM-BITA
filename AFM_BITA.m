clear all;
labels=createImg();%Creates images from FASTA files in same folder
PNGFiles = dir('*.png'); 
numfiles = length(PNGFiles);
figure;
for i=1:numfiles
    RGB=imread(PNGFiles(i).name);
    fname=PNGFiles(i).name;
    GrayImage = rgb2gray(RGB);
    [pix_Counts, GrayLvls] = imhist(GrayImage);
    subplot(5,5,i);imhist(GrayImage);title(labels(i));%change grid rows and columns as your seq number
    pix_Counts=transpose(pix_Counts);
    GrayLvls=transpose(GrayLvls);
    NM = sum(pix_Counts); % number of pixels

    %%%%%%%%%%%%% Histogram Features %%%%%%%%%%%%
    pI = pix_Counts / NM;
    mean = sum(GrayLvls .* pI);%Mean
    L=length(pix_Counts);
    ii=0:L-1;
    x=(ii-mean).^2.*pI;
    vr=sum(x);%Variance
    y=(ii-mean).^3.*pI;
    sk=sum(y);
    z=(ii-mean).^4.*pI;
    ku=sum(z);
    sk = sk / sqrt(vr)^3; % skewness
    ku = (ku / sqrt(vr)^4)-3; % kurtosis
    energy = sum(pI .^ 2);%energy
    entropy = -sum(pI(pI~=0) .* log2(pI(pI~=0)));%entropy 

    result(i,:) = [sk, ku, energy, entropy];

dist=pdist(result);
sqfrm=squareform(dist);
tree = seqlinkage(dist,'average',labels);