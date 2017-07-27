function [M] = nonMaxSup(J, theta)
%% separate image J in order for local nMSup
[nr,nc]=size(J);
deltarJ=round(nr/3);
deltacJ=round(nc/3);
partsumJ=zeros(3,3);

%separate into 9 parts 
for i=0:2
    for j=0:2
        partsumJ(i+1,j+1)=sum(sum(J(i*deltarJ+1:i*deltarJ+deltarJ,j*deltacJ+1:j*deltacJ+deltacJ)));
    end
end
%compute the part with most sum of gradient
orderJ=reshape(partsumJ,[1,9]);
orderJ=sort(orderJ,'descend');
sum_topJ=orderJ(1,1);

%% orientation processing
theta(theta<0)=pi+theta(theta<0);
%% pad pixels along boundary 
thetax=ones(nr+2,nc+2);
thetax(2:nr+1,2:nc+1)=theta;
Jp=zeros(nr+2,nc+2);
Jp(2:nr+1,2:nc+1)=J;
%% non-Max-Supression
M=zeros(nr,nc);

%according to the magnitude of part to get threshold 
threshold=sqrt(fix(sum_topJ/6.2e4))*4.85;

%pad pixel in the orientation of gradient for comparison
for i=2:nr+1,
    for j=2:nc+1,
        if (thetax(i,j)>=0 && thetax(i,j)<pi/4)
            pad1=Jp(i,j+1).*tan(thetax(i,j))+Jp(i+1,j+1).*(1-tan(thetax(i,j)));
            pad2=Jp(i,j-1).*tan(thetax(i,j))+Jp(i-1,j-1).*(1-tan(thetax(i,j)));
        end        
        if (thetax(i,j)>=pi/4 && thetax(i,j)<pi/2)            
            pad1=Jp(i+1,j).*tan(pi/2-thetax(i,j))+Jp(i+1,j+1).*(1-tan(pi/2-thetax(i,j)));
            pad2=Jp(i-1,j).*tan(pi/2-thetax(i,j))+Jp(i-1,j-1).*(1-tan(pi/2-thetax(i,j)));
        end        
        if (thetax(i,j)>=pi/2 && thetax(i,j)<3*pi/4)
            pad1=Jp(i+1,j).*tan(thetax(i,j)-pi/2)+Jp(i+1,j-1).*(1-tan(thetax(i,j)-pi/2));
            pad2=Jp(i-1,j).*tan(thetax(i,j)-pi/2)+Jp(i-1,j+1).*(1-tan(thetax(i,j)-pi/2));
        end        
        if (thetax(i,j)>=3*pi/4 && thetax(i,j)<pi)
            pad1=Jp(i,j-1).*tan(pi-thetax(i,j))+Jp(i+1,j-1).*(1-tan(pi-thetax(i,j)));
            pad2=Jp(i,j+1).*tan(pi-thetax(i,j))+Jp(i-1,j+1).*(1-tan(pi-thetax(i,j)));
        end        
        if (Jp(i,j)>=pad1+threshold) || (Jp(i,j)>=pad2+threshold)
                M(i-1,j-1)=1;
        end      
    end
end
M=M.*J;
end



