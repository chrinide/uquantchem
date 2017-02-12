clear;
rho0 = 0.002;

  MESH = [ 200 200 200 ];
LIMITS = [ 7.0 7.0 7.0 ];


[I1,I2,I3,RHO]=textread('CHARGEDENS.dat','%f %f %f %f',MESH(1)*MESH(2)*MESH(3));

for i=1:MESH(1)*MESH(2)*MESH(3)
	DENS(I1(i),I2(i),I3(i)) = RHO(i);
	x(I1(i)) = -LIMITS(1) + 2*LIMITS(1)*(I1(i)-1)/(MESH(1)-1);
	y(I2(i)) = -LIMITS(2) + 2*LIMITS(2)*(I2(i)-1)/(MESH(2)-1);
	z(I3(i)) = -LIMITS(3) + 2*LIMITS(3)*(I3(i)-1)/(MESH(3)-1);
	n1(I1(i)) = I1(i);
	n2(I2(i)) = I2(i);
	n3(I3(i)) = I3(i);
end

for i=1:MESH(1)
	for j=1:MESH(2)
        	fdens(i,j) = DENS(i,j,100);
	end
end

[f,v] = isosurface(n1,n2,n3,DENS,rho0);

p = patch('Faces',f,'Vertices',v)

isonormals(n1,n2,n3,DENS,p);
set(p,'FaceColor','g','EdgeColor','none','NormalMode','auto');
alpha(0.50);
camlight;set(gca,'Xcolor','w');set(gca,'Ycolor','w');set(gca,'Zcolor','w')
lighting gouraud;
set(gca,'Xcolor','w');set(gca,'Ycolor','w');set(gca,'Zcolor','w')

% if you want to plot an view the 2-Dim chargedensity in the z=0 plane
% after you have run the above run these commands:
% surfl(x,y,fdens,'light');
% shading interp;
