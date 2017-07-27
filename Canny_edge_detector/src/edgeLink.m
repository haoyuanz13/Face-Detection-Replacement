function [E] = edgeLink(M, J, theta)
%% separate matrix M in order for local edgelink 
[nr,nc]=size(J);
sumM=sum(sum(M));
threshold_high=zeros(3,3);
threshold_low=zeros(3,3);

deltar=round(nr/3);
deltac=round(nc/3);
partsum=zeros(3,3);

for i=0:2
    for j=0:2
        partsum(i+1,j+1)=sum(sum(M(i*deltar+1:i*deltar+deltar,j*deltac+1:j*deltac+deltac)));
    end
end

order=reshape(partsum,[1,9]);
order=sort(order,'descend');
sum_top=order(1,1);
%% according to the local max to set threshold
base_high=sum_top/(1.78e6);
base_low=sum_top/(5e6);
for i=1:3
    for j=1:3
        threshold_high(i,j)=(0.62+partsum(i,j)/sumM)*base_high;
        threshold_low(i,j)=(1+partsum(i,j)/sumM)*base_low;
    end
end     
%% use high and low threshold to get start edge and link edge
M_high=zeros(nr,nc);
M_low=zeros(nr,nc);
threshold_high=threshold_high.*max(M(:));
threshold_low=threshold_low.*max(M(:));

for i=1:nr-1,
    for j=1:nc-1,
        if M(i,j)>=threshold_high(ceil(i/deltar),ceil(j/deltac))
            M_high(i,j)=1;
        else if M(i,j)<threshold_high(ceil(i/deltar),ceil(j/deltac)) && M(i,j)>=threshold_low(ceil(i/deltar),ceil(j/deltac))
            M_low(i,j)=1;
            end
        end
    end
end
Mx=zeros(2+nr,2+nc);
Mx(2:1+nr,2:1+nc)=M_high;
%% link edge
%test the neighbor pixels' value and orientation
%if neighbor is a start edge with similar orientation, then link it
thetax=10.*ones(2+nr,2+nc);
thetax(2:nr+1,2:nc+1)=theta;
for i=2:nr+1,
    for j=2:nc+1,
        if M_low(i-1,j-1)==1       
            
            if thetax(i,j)>=0 && thetax(i,j)<pi/8
                if Mx(i-1,j)==1 || Mx(i+1,j)==1   %test its neighbors are start edges or not
                    if (thetax(i-1,j)>=0 && thetax(i-1,j)<pi/8)&&(thetax(i+1,j)>=0 && thetax(i+1,j)<pi/8) %test whether their orientation is similar as link edge pixel
                        Mx(i,j)=1;
                    end
                end
            end            
            if thetax(i,j)>=7*pi/8 && thetax(i,j)<pi
                if Mx(i-1,j)==1 || Mx(i+1,j)==1
                    if (thetax(i-1,j)>=7*pi/8 && thetax(i-1,j)<pi)&&(thetax(i+1,j)>=7*pi/8 && thetax(i+1,j)<pi)
                        Mx(i,j)=1;
                    end
                end
            end            
            if thetax(i,j)>=pi/8 && thetax(i,j)<3*pi/8
                if Mx(i-1,j+1)==1 || Mx(i+1,j-1)==1
                    if (thetax(i-1,j+1)>=pi/8 && thetax(i-1,j+1)<3*pi/8)&&(thetax(i+1,j-1)>=pi/8 && thetax(i+1,j-1)<3*pi/8)
                        Mx(i,j)=1;
                    end
                end
            end            
            if thetax(i,j)>=3*pi/8 && thetax(i,j)<5*pi/8
                if Mx(i-1,j)==1 || Mx(i+1,j)==1
                    if (thetax(i-1,j)>=3*pi/8 && thetax(i-1,j)<5*pi/8)&&(thetax(i+1,j)>=3*pi/8 && thetax(i+1,j)<5*pi/8)
                        Mx(i,j)=1;
                    end
                end
            end             
            if thetax(i,j)>=5*pi/8 && thetax(i,j)<7*pi/8
                if Mx(i-1,j-1)==1 || Mx(i+1,j+1)==1
                    if (thetax(i-1,j-1)>=5*pi/8 && thetax(i+1,j+1)<7*pi/8)&&(thetax(i+1,j+1)>=5*pi/8 && thetax(i+1,j+1)<7*pi/8)
                        Mx(i,j)=1;
                    end
                end
            end                      
        end
    end
end
E=zeros(nr,nc);
E=Mx(2:nr+1,2:nc+1);          
end
