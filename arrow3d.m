function varargout=arrow3d(start,stop,ang,ltype,p,n)
if nargin<3 ang=30; end
if nargin<4 ltype='cylinder'; end
if nargin<5 p=[0.25,0.1]; end
if nargin<6 n=[20,10]; end
if size(start,1)<1 | size(stop,1)<1
    error([upper(mfilename) ': start point data or stop piont data must be a m*3 matrix']);
end
if size(start,2)~=3 | size(stop,2)~=3
    error([upper(mfilename) ': start point data or stop piont data must be a m*3 matrix']);
end
%p(1) is the ratio of arrow head height to the distance between start and end points
%p(2) is the ratio of cylinder radial to arrow head height
%Check if p is between 0 and 1
if ~all(p<=1 & p>0)
    error([upper(mfilename) ': p must between 0 and 1']);
end
%n(1) is the patch number of arrow head
%n(2) is the patch number of cylinder
%Check if n a positive integer, and n must greater than 2
n=ceil(n);
if ~all(n>2)
    error([mfilename ': patch number of arrow head and cylinder must greater than 3']);
end
%Calculate the direction vectors between start and end points
dvec=stop-start;
%Calculate the distances between start and end points
dis=sqrt(sum(dvec.^2,2));
%The height of arrow head
hv=min(dis)*p(1);
%Generate the initial line data of 3d arrows
init_start=zeros(size(start));
init_stop=[zeros(size(dis)) zeros(size(dis)) (dis-hv).*ones(size(dis))];
%Calculate Rotate angles of the lines
cosrang=acos(dvec(:,3)./dis)*180/pi;
%Calculate normal vector between arrow line and Z-axis
nvec=[-dvec(:,2) dvec(:,1) zeros(size(dis))];
%draw lines of arrows
if ~ishold
    hold on;
    view(3);
    SET_HOLD_OFF=true;
else
    SET_HOLD_OFF=false;
end
hlines=[];
if strcmp(ltype,'line')
    for i=1:length(dis)
        %Rotate end point
        [rx,ry,rz]=rotatedata(init_stop(i,1),init_stop(i,2),init_stop(i,3),nvec(i,:),cosrang(i),[0,0,0]);
        hlines(i)=line([start(i,1);start(i,1)+rx],[start(i,2);start(i,2)+ry],[start(i,3);start(i,3)+rz]);
    end
    hlgrd=[];
else
    for i=1:length(dis)
        r=hv*tan(ang./180.*pi).*p(2);
        [xi,yi,zi] = cylinder(r.*[1,1],n(2));
        zi=zi.*(dis(i)-hv);
        %escape the error if the arrow is in z-direction
        %if the arrow is in z-direction then the nvector result zeros to
        %make a error!
        %Fix this bug! 2006/07/24
        %Thanks to Pavel Grinfeld(pg@math.drexel.edu)
        if all(nvec(i,:)==0)
            nvec(i,:)=[0,1,0];
        end
        [rx,ry,rz] = rotatedata(xi,yi,zi,nvec(i,:),cosrang(i),[0,0,0]);
        cx=start(i,1)+rx;cy=start(i,2)+ry;cz=start(i,3)+rz;
        hlines(i)=surf(cx,cy,cz,'edgecolor','none','facecolor',[145,90,7]/255);
        hlgrd(i)=patch(cx(1,:),cy(1,:),cz(1,:),[145,90,7]/255);
    end
end
%Generate the initial arrow head data of 3d arrwos
hheads=[];
hgrd=[];
pv=dis-hv;
%draw heads of arrows
for i=1:length(dis)
    %Generate initial taper data
    [xi,yi,zi] = cylinder([tan(ang/180*pi),0],n(1));
    xi=xi*hv;yi=yi*hv;zi=zi*hv+pv(i);
    %Rotate the taper
    [rx,ry,rz] = rotatedata(xi,yi,zi,nvec(i,:),cosrang(i),[0,0,0]);
    cx=start(i,1)+rx;cy=start(i,2)+ry;cz=start(i,3)+rz;
    hheads(i)=surf(cx,cy,cz,'edgecolor','none','facecolor',[11 131 222]/255);
    %Draw the underside of taper
    hhgrd(i)=patch(cx(1,:),cy(1,:),cz(1,:),[7 86 145]/255);
end
if SET_HOLD_OFF
    hold off;
end
if nargout>1 varargout{2}=[hheads;hhgrd]; end
if nargout>0 varargout{1}=[hlines;hlgrd]; end

return;
function [newx,newy,newz]=rotatedata(xdata,ydata,zdata,azel,alpha,origin)
if nargin<6
    error('Not enough input arguments! Type ''help rotatedata'' to get some help!')
end

if prod(size(azel)) == 2 % theta, phi
    theta = pi*azel(1)/180;
    phi = pi*azel(2)/180;
    u = [cos(phi)*cos(theta); cos(phi)*sin(theta); sin(phi)];
elseif prod(size(azel)) == 3 % direction vector
    u = azel(:)/norm(azel);
end

alph = alpha*pi/180;
cosa = cos(alph);
sina = sin(alph);
vera = 1 - cosa;
x = u(1);
y = u(2);
z = u(3);

rot = [cosa+x^2*vera x*y*vera-z*sina x*z*vera+y*sina; ...
        x*y*vera+z*sina cosa+y^2*vera y*z*vera-x*sina; ...
        x*z*vera-y*sina y*z*vera+x*sina cosa+z^2*vera]';
[m,n] = size(xdata);
if isempty(z)
    z=zeros(size(x));
end
newxyz = [xdata(:)-origin(1), ydata(:)-origin(2), zdata(:)-origin(3)];
newxyz = newxyz*rot;
newx = origin(1) + reshape(newxyz(:,1),m,n);
newy = origin(2) + reshape(newxyz(:,2),m,n);
newz = origin(3) + reshape(newxyz(:,3),m,n);
