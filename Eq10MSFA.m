clear;
clc;
close all;
addpath(genpath('./src'));
B = 3; % Multiplexation parameter
NF = 25; % Number of filter and kernel size
N = 256; % Detector size
x = 1:NF;
y = x';
g = ones(NF,1);
q = (1:NF)';
I = kron(g',q);
J = I';
K = floor(NF/2);
distance1 = zeros(NF,NF,NF);
distance2 = zeros(NF,NF,NF);
G = zeros(NF,NF,B);

for a=1:K
    for b=a:K
        for c=1:K
            for k=1:B
                G(:,:,k) = (mod(a*I+b*J+((k-1)*c),NF))+1;
            end
            %[flag] = VerifyRollingShutter(G(:,:,1),NF);
            flag = 1;
            if(flag == 1)
                [d] = Computedistance(G,NF);
                [d1] = Computedistance(G(:,:,1)==1,NF);
                distance1(a,b,c) = d; %sphere diameter
                %distance2(a,b,c) = d1; %pixel distribution
            else
                distance1(a,b,c) = eps; %sphere diameter
                %distance2(a,b,c) = eps; %pixel distribution
            end
        end
    end
end

d2 = distance1;% + 0.5*distance2;
[G,diameter,a1,b1,c1] = bestPattern(NF,B,d2);

[density]= ComputeDensity(diameter(1),NF);
%implay(G./NF)
[C,T] = generateCodedAperture(G,NF,B,N); % C: coded aperture kernel, T: full size coded aperture

implay(C); % C: coded aperture kernel
implay(T); % T: full size coded aperture