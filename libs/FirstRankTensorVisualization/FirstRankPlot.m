%First Rank Tensor 3D Representation
for i = 1:3
  k = Pyro_matr(i,1);
  myque = sprintf('What is the value of the P%d for this material?',i);
    if k == 0
    else somevalue = str2double(inputdlg(myque)); %need to find a way to insert P1, P2, etc.
        Pyro_matr(i,1) = somevalue;
    end
end
j =1;
for l = 1:2
%j =1;
for theta = 0:0.01*pi:pi;
i = 1;
for phi = 0:0.02*pi:2*pi
a(1,1)= cos(phi)*sin(theta);
a(1,2)= sin(phi)*sin(theta);
a(1,3)= cos(theta);
fn = Pyro_matr(1,1)*a(1,1) + Pyro_matr(2,1) * a(1,2) + Pyro_matr(3,1)*a(1,3);
if l ==2
  fn=fn;
end
%fn = abs(fn);
ph(i,j) = phi;
rh(i,j) = fn;
th(i,j) = theta;
i = 1 + i;
end
%for i = 1:40
%x(i,1) = rh(i,j)*cos(th(i,j));
%y(i,1) = rh(i,j)*sin(th(i,j));
%end
%for i = 41:80
%x(i,1) = -rh(i-40,j)*cos(th(i-40,j));
%y(i,1) = -rh(i-40,j)*sin(th(i-40,j));
%end
j = j + 1;
end
end
[x,y,z]=sph2cart(ph,th,rh);
figure(2)
surf(x,y,z)
shading interp
set(gca,'Visible','off')
title(sprintf(['The First Rank Tensor Representation of the \n Point Group ',Crystal,' Crystal Structure']),'FontSize',14)
axis square
%set(gca,'Visible','off')

  