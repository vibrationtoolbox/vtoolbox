function [z,nf,a]=sdofcf(f,TF,Fmin,Fmax)
%[z,nf,a]=sdof(f,TF,Fmin,Fmax) Curve fit to SDOF FRF.
% f is the frequency vector in Hz. It does not have to 
%    start at 0 Hz.
% TF is the complex transfer function.
% z and nf are the damping ratio and natural frequency (Hz)
% a is the numerator of the identified transfer function.
%                  a
%        T=------------------
%           1-r^2+2 zeta r j
% Only one peak may exist in the segment of the FRF passed to 
% sdofcf. No zeros may exist withing this segment. If so, 
% curve fitting becomes unreliable. 
% Fmin is the minimum frequency to be used for curve fitting in the
% FRF
% Fmax is the maximum frequency to be used for curve fitting in the
% FRF
%
%
% EXAMPLE:
% M=eye(2);
% K=[2 -1;-1 2];
% C=.0001*K;
% [Freq,Recep,Mobil,Inert]=vtb7_5(M,C,K,1,2,linspace(0,.5,1024));
% figure(1)
% n=length(Freq);
% f2=Freq;
% R2=Recep;
% R2=R2+1*randn(n,1)+1*randn(n,1)*i;% Poorly Simulated Noise
% [z,nf,a]=sdofcf(f2,R2,.14,.17),pause
% [z,nf,a]=sdofcf(f2,R2,.27,.28)
%
%
% Note that by changing the parts of Freq and Recep used
% We can curve fit to other modes.

% Copyright Joseph C. Slater, 10/8/99
% Updated 11/8/99 to improve robustness
% Updated 1/1/00 to improve robustness
% Updated 4/1/01 from vtb7_4 to linear curve fitting.
% 5/1/01 included residuals properly (Undocumented).
% 4/15/03 added limits for frequency of FRF curve fit.

%tfplot(f,TF)
%pause


% Select frequency range to curve fit
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
R=TF;

%-------------------------------------------


%
ll=length(f);
w=f*2*pi*sqrt(-1);
w2=w*0;
R3=R*0;
for i=1:ll
	R3(i)=conj(R(ll+1-i));
	w2(i)=conj(w(ll+1-i));
end
w=[w2;w];
R=[R3;R];
%plot((w/sqrt(-1)),20*log10(abs(R)))

n=1;
N=2*n;
N=2;
[x,y]=meshgrid(0:N,R);

[x,w2d]=meshgrid(0:N,w);
c=-w.^(N).*R;






aa=[w2d(:,1+(0:N-1)).^x(:,1+(0:N-1)).*y(:,1+(0:N-1)) -w2d(:,1+(0:N)).^x(:,1+(0:N))];



b=aa\c
%real([1 b((N-1:-1:0)+1)'])
[1 b((N-1:-1:0)+1)']
rs=roots([1 b((N-1:-1:0)+1)'])

[srs,irs]=sort(abs(imag(rs)));

rs=rs(irs);
rs;
omega=abs(rs(2));
z=-real(rs(2))/abs(rs(2));
nf=omega/2/pi;

%XoF1=1./(w.^2+2*z*w*omega+omega^2);
XoF1=[1./(w-rs(1)) 1./(w-rs(2))];
%XoF2=1./(w+rs(1));
XoF2=1./(w.^0);
XoF3=1./w.^2;
XoF=[XoF1 XoF2 XoF3];
size(XoF)
a=1;
size(XoF);
size(R);
a=XoF\R;
%size(w)
%plot(abs(w)),pause
%tfplot(f,TF)
%tfplot(f,[a*Rest,R])
%size(XoF)
XoF=XoF((ll+1:2*ll)-2*0,:)*a;

a=sqrt(-2*imag(a(1))*imag(rs(1))-2*real(a(1))*real(rs(1)));

%plot(abs(w(ll:2*ll)))
%pause
%break







%Plotting
Fmin=min(f);
Fmax=max(f);
phase=unwrap(angle(TF))*180/pi;
phase2=unwrap(angle(XoF))*180/pi;size(phase);

subplot(2,1,1)
plot(f,20*log10(abs(XoF)),f,20*log10(abs(TF)))
as=axis;
zoom on
legend('Identified FRF','Experimental FRF',0)
min(f);

axis([Fmin Fmax as(3) as(4)])
xlabel('Frequency (Hz)')
ylabel('Mag (dB)')
grid on
%  Fmin,Fmax,min(mag),max(mag)
%  axis([Fmin Fmax minmag maxmag])
[TFmax,in]=max(abs(TF));
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
legend('Identified FRF','Experimental FRF',0)

grid on
axis([Fmin Fmax  phmin_max(1) phmin_max(2)])
gridmin_max=round(phmin_max/90)*90;
set(gca,'YTick',gridmin_max(1):22.5:gridmin_max(2))
zoom on
a=a(1)^2/(2*pi*nf)^2;
	
if nargout==0
	disp('')
	disp(['zeta = ' num2str(z)])
	disp(['f = ' num2str(nf) ' Hz.'])
	disp(['amplitude = ' num2str(2*imag(a(1))^2) '.'])
	disp('')
	clear z a nf
end
%disp('error still needing correction to use 7.38')
%figure,tfplot(f,(a^2)./((nf*2*pi)^2-(2*pi*f).^2+z*2*nf*2*pi*2*pi*f*sqrt(-1)))
