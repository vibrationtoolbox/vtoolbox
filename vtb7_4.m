function [z,nf,u]=vtb7_4(f,TF,Fmin,Fmax)
%[z,nf,u]=vtb7_4(f,FRF,Fmin,Fmax) Curve fit to MDOF FRF.
% f is the frequency vector in Hz. 
%
% FRF are columns comprised of the FRFs presuming single input, multiple output
% z and nf are the damping ratio and natural frequency (Hz)
% u is the mode shape.
% Only one peak may exist in the segment of the FRF passed to 
% vtb7_4. No zeros may exist withing this segment. If so, 
% curve fitting becomes unreliable. 
%
% If called without outputs, i.e.
% vtb7_4(f,FRF,Fmin,Fmax)
% The FRFs and the fit to them will be plotted instead of output being
% returned. 
%
% If Fmin and Fmax are not entered, the min and max values in
% f are used.
%
% If the first column of TF is a collocated (input and output location are
% the same), then the mode shape returned is the mass normalized mode shape
%
% This can then be used to generate an identified mass, damping, and
% stiffness matrix as shown in the following example.
%
% EXAMPLE:
%   M=eye(2)*2;
%   K=[2 -1;-1 2];
%   C=.01*K;
%   [Freq,Recep1,Mobil1,Inert1]=vtb7_5(M,C,K,1,1,linspace(0,.5,1024)); %Frequency response function between node 1 and itself
%   [Freq,Recep2,Mobil2,Inert2]=vtb7_5(M,C,K,1,2,linspace(0,.5,1024)); %Frequency response function between node 1 and node 2
%   figure(1)
%   plot(Freq,20*log10(abs(Recep1)))
%   Recep=[Recep1 Recep2];
%   Recep=Recep+.1*randn(size(Recep))+i*.1*randn(size(Recep));
%   % Curve fit first peaks
%   vtb7_4(Freq,Recep,.1,.12); % Plot fits. 
%   [z1,nf1,u1]=vtb7_4(Freq,Recep,.1,.12);
%   z(1,1)=z1;
%   lambda(1,1)=(nf1*2*pi)^2;
%   
%   S(:,1)=real(u1);%/abs(sqrt(u1(1)));
%   % Curve fit second peaks
%   vtb7_4(Freq,Recep,.16,.25); % Plot fits
%   [z2,nf2,u2]=vtb7_4(Freq,Recep,.16,.25);
%   z(2,2)=z2;
%   lambda(2,2)=(nf2*2*pi)^2;
%   S(:,2)=real(u2);%/abs(sqrt(u2(1)));
%   dampingratios=diag(z)
%   naturalfrequencies=sqrt(diag(lambda))/2/pi
%   M=M
%   Midentified=S'\eye(2)/S%Make Mass matrix
%   K=K
%   Kidentified=S'\lambda/S%Make Stiffness Matrix
%   C=C
%   Cidentified=S'\(2*z*sqrt(lambda))/S%Make damping matrix

%
% Note that by changing the parts of Freq and Recep used
% We can curve fit to other modes.

% Copyright Joseph C. Slater, 10/8/99
% Updated 11/8/99 to improve robustness
% Updated 1/1/00 to improve robustness
% Updated 4/1/01 from vtb7_4 to linear curve fitting.
% Updated 5/1/01 to start adding MDOF.
% Updated 5/15/01 to include frequency range for curve fitting
% Updated 11/13/07 to mass normalize mode shapes
% Updated 11/13/07 example to demonstrate ID of system matrices

%disp('This is beta software written 07-May-2001')
%disp('This code may not be used by anyone not authorized by J. Slater')
%disp('This code will expire 15-Jun-2001')

%if datenum('10-Jun-2001')<datenum(date)
%	warndlg('contact joseph.slater@wright.edu for an update.','mdofcf.p will expire 15-Jun-2003')	
%end


% if datenum('15-Jun-2004')<datenum(date)
% 	delete mdofcd.p
% 	warndlg('contact joseph.slater@wright.edu for an update.','mdofcf.p has expired')	
% end

inlow=1;
inhigh=length(f);

if nargin==4
inlow=floor(length(f)*(Fmin-min(f))/(max(f)-min(f)))+1;

inhigh=ceil(length(f)*(Fmax-min(f))/(max(f)-min(f)))+1;
end

if f(inlow)==0
 inlow=2;
end
f=f(inlow:inhigh,:);
TF=TF(inlow:inhigh,:);

% Reduce to single FRF for finding poles:
[y,in]=max(abs(TF));
in=in(1);
R=(TF');
[U,S,V]=svd(R);
T=U(:,1);
Hp=(T')*R;
R=(Hp');

% End reduction (whole thing is still stored in TF)

ll=length(f);
w=f*2*pi*sqrt(-1);
w2=w*0;
R3=R*0;
for i=1:ll
	R3(i)=conj(R(ll+1-i));
	w2(i)=conj(w(ll+1-i));
	TF2(i,:)=conj(TF(ll+1-i,:));
end
w=[w2;w];
R=[R3;R];

n=1;
N=2*n;
N=2;
[x,y]=meshgrid(0:N,R);
[x,w2d]=meshgrid(0:N,w);
c=-w.^(N).*R;

aa=[w2d(:,1:N).^x(:,1:N).*y(:,1:N) -w2d(:,1:(N+1)).^x(:,1:(N+1))];

b=aa\c;

rs=roots([1 b((N:-1:1))']);
%stuff=[1 b((N-1:-1:0)+1)']
%stuff=stuff(length(stuff):-1:1)
%[xx,ee]=polyeig(stuff)

[srs,irs]=sort(abs(imag(rs)));

rs=rs(irs);

omega=abs(rs(2));
z=-real(rs(2))/abs(rs(2));
nf=omega/2/pi;

% This section now gets repeated for each FRF. Still needs to be done for MDOF, to make a matrix a.
%rs
%rs
%XoF=[1./(w-rs(1)) 1./(w-rs(2)) 1./(w.^0) 1./w.^2];%;1./w2d(:,[1 3])];
%XoF1=[1./(w-rs(1)) 1./(w-rs(2))];
%Nov 07 Fix to get residue matrix (see text)
XoF1=[1./((rs(1)-w).*(rs(2)-w))];
XoF2=1./(w.^0);
XoF3=1./w.^2;
XoF=[XoF1 XoF2 XoF3];

%for i=1:
TF3=[TF2;TF];

%plot(unwrap(angle(TF3)))
a=XoF\TF3;
%size(XoF1)

%tfplot(imag(w/2/pi),XoF1)

%size(w)
%plot(abs(w)),pause
%tfplot(f,TF)
%tfplot(f,[a*Rest,R])
%size(XoF)
u=a(1,:)';
u=u/sqrt(abs(a(1,1)));
%u=u/u(1);
%u=u/norm(u);
R=XoF;
if nargout<3
for mm=1:size(a,2)

	if mm>1

		pause
	end
clf
	figure(gcf)
	XoF=R((ll+1:2*ll),:)*a(:,mm);
	%plot([abs(XoF) abs(TF)])
	%2*ll
	%plot(abs(w(ll:2*ll)))
	%pause
	%break

	Fmin=min(f);
	Fmax=max(f);
	phase=unwrap(angle(TF(:,mm)))*180/pi;
	phase2=unwrap(angle(XoF))*180/pi;size(phase);
	%size(XoF)
	subplot(2,1,1)
	plot(f,20*log10(abs(XoF)),f,20*log10(abs(TF(:,mm))))

	as=axis;
	legend('Identified FRF','Experimental FRF')
	min(f);
	axis([Fmin Fmax as(3) as(4)])
	title(['Frequency Response Function ' num2str(mm) ' Fit'])
	xlabel('Frequency (Hz)')
	ylabel('Mag (dB)')

	grid on
	zoom on

	drawnow

	%  Fmin,Fmax,min(mag),max(mag)
	%  axis([Fmin Fmax minmag maxmag])
	%pause
	
	while phase2(in)>50
	phase2=phase2-360;
	end
	phased=phase2(in)-phase(in);
	phase=phase+round(phased/360)*360;
	phmin_max=[floor(min(min([phase;phase2]))/45)*45 ceil(max(max([phase;phase2]))/45)*45];
	subplot(2,1,2)
	plot(f,phase2,f,phase)
	xlabel('Frequency (Hz)')
	ylabel('Phase (deg)')
	legend('Identified FRF','Experimental FRF')
	
	axis([Fmin Fmax  phmin_max(1) phmin_max(2)])
	gridmin_max=round(phmin_max/90)*90;
	set(gca,'YTick',gridmin_max(1):22.5:gridmin_max(2))
	grid on
	zoom on
	drawnow
	figure(gcf)
	disp(['DOF ' num2str(mm) ' of ' num2str(size(a,2)) '. Press return to plot next curve-fit FRF or end.'])
end
end
