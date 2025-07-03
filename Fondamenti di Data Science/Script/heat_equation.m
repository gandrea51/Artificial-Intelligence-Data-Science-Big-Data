% explicit scheme 
clc
close all
clear all
lg = 10. ; % length of the semi-space 
dx = 0.05 ;  % mesh step
nx = lg/dx ; % half number of points 
cfl = 0.1 ;  % CFL condition for stability
dt = dx*dx*cfl; % time step
Tfinal=0.5; % final time
nt=floor(Tfinal/dt); % number of time iteration

%//
%// initialization
%//

x=zeros(1,2*nx+1);  % mesh
u0=zeros(1,2*nx+1) ; % initial data
for i=1:2*nx+1
  x(i) = (i-nx-1)*dx  ;
  u0(i) = max(0.,1.-x(i)^2) ;
end
u=u0 ; % solution over time
up=u0 ; % right shifted vector
um=u0 ; % left shifted vector 
uexact=u0 ;

plot(x,u0,'linewidth',2)
title('initial data') 

%pause() ;
%////////////////////////////////////////////////////////////////
%// explicit scheme: cfl=0.4
%////////////////////////////////////////////////////////////////
%//
for n=1:nt
    %//
    up = shift(1,u) ;
    um = shift(-1,u) ;
        
    u=u + dt/(dx*dx)*(up+um-2*u) ;
    
    if rem(n,5) == 0
        clf()
        %    hold on
        plot(x,u,x,u0,'linewidth',2)
        %plot(x,u,'linewidth',2)
        title('explicit scheme, cfl=0.4');
        pause(0.01);
    end
end

% comparing the exact with the computed solution
        uexact = zeros(1,2*nx+1) ; % 1/sqrt(4pit)int u_0(y)e(-(x-y)^2/4t)dy
        for i=1:2*nx+1
            for j=1:2*nx+1
                 uexact(i) = uexact(i) + u0(j)*dx*exp(-((i-j)*dx)^2/(4*nt*dt));
            end
            uexact(i) = uexact(i)/sqrt(4*pi*nt*dt) ;
        end
%        figure
        plot(x,u,x,uexact,x,u0,'linewidth',2)
        legend('computed','exact','initial')
        title('Explicit scheme, cfl=0.4, 500 time steps');
pause()
%////////////////////////////////////////////////////////////////
%// unstable centred scheme
%////////////////////////////////////////////////////////////////
cfl = 0.1 ;
dt = dx*dx*cfl ;
u = u0 ; 
u1= u0 ; 
u2 = u0 ;
nt=25 ;
up = shift(1,u0) ;
um = shift(-1,u0) ;
u1 = u0 + dt/(dx*dx)*(up+um-2*u0) ;

for n=2:nt
    up = shift(1,u1) ;
    um = shift(-1,u1) ;

    u = u2 + 2*dt/(dx*dx)*(up+um-2*u1) ;
    u2 = u1 ;
    u1 = u ;

    if rem(n,1) == 0
          clf()
            plot(x,u,x,u0,'linewidth',2)                
            title('central scheme, cfl=0.1');
            pause(0.1);
    end

end

% comparing the exact with the computed solution
uexact = zeros(1,2*nx+1) ;
for i=1:2*nx+1
    for j=1:2*nx+1
          uexact(i) = uexact(i) + u0(j)*dx*exp(-((i-j)*dx)^2/(4*nt*dt));
    end
    uexact(i) = uexact(i)/sqrt(4*pi*nt*dt) ;
end
%       clf()
%       figure
plot(x,u,x,uexact,x,u0,'linewidth',2)
legend('computed','exact','initial')
title('Central scheme, cfl=0.1, 25 time steps');
pause() ;

%////////////////////////////////////////////////////////////////
%//  implicit scheme: cfl=2.
%////////////////////////////////////////////////////////////////
cfl = 2. ;
dt = dx*dx*cfl ;
u = u0 ;
nt=200 ;
mat=zeros(2*nx+1,2*nx+1) ;

for i=2:2*nx
  mat(i,i) = 1. + 2*dt/(dx*dx) ;
  mat(i,i+1) =  -dt/(dx*dx) ;
  mat(i,i-1) = -dt/(dx*dx) ;
end
mat(1,1) = 1. + 2*dt/(dx*dx) ;
mat(1,2) =  -dt/(dx*dx) ;
mat(2*nx+1,2*nx) = -dt/(dx*dx);
mat(2*nx+1,2*nx+1) = 1. + 2*dt/(dx*dx) ;

%//
for n=1:nt
%//
u =(mat^-1*u')'; 

if rem(n,5) == 0
        clf()
        plot(x,u,x,u0,'linewidth',2)                
        title('implicit scheme, cfl=2');
        pause(0.1);
end
%//
end

% comparing the exact with the computed solution
        uexact = zeros(1,2*nx+1) ;
        for i=1:2*nx+1
            for j=1:2*nx+1
                 uexact(i) = uexact(i) + u0(j)*dx*exp(-((i-j)*dx)^2/(4*nt*dt));
            end
            uexact(i) = uexact(i)/sqrt(4*pi*nt*dt) ;
        end
              clf()
        plot(x,u,x,uexact,x,u0,'linewidth',2)
        legend('computed','exact','initial')
        title('Implicit scheme, cfl=2, 200 time steps');
        pause(0.1);