script,
% Systems of differential equations of three-phase symmetrical
% induction motors for flux linkage (PSI). 
% Program function Vpk1 used for sinus voltage
% Parameters taked out of LAPUNOVOY ELEN diplom's work- 24.01.03 year
% Program function Vpk2 used for nonsinus voltage 
% (diplom's work ORLOV MIXAIL)- 3.01.04 year
%========================================================
clear;
%clc,
clf,
global aa1 aa2 aa3 aa4 a4 a5 mc n1,
%=================================
%        INITIAL DATE (BLOK 1)
%=================================
%disp('  << MATERIAL: N=1(Cu); N=2(AL); N=3(Latun) >>');
%n1=input('   Input MATERIAL: N='); 
n1=2; %(ALUMINIUM for diplom ORLOV MIXAIL)
%==============================
P2=3; % Nominal power [kWt]
f1=50;     % Nominal frequency of voltage [Hz]
p=2;       % Number of poles pair; 
nc=1500;  % Synchronous angular frequency of rotor [turn/min]
omegc=2*pi*nc/60;% Sinchronous angular frequency [1/cec] 
snm=0.04; % Nominal slip of rofor;
cosfi=0.85; % Nominal efficiency
Ufn=380;% Nominal  voltage of phase
mf=3;% Number of stator phases;
%============================================
% Parameteres of equivalent circuit phace IM
%============================================
rsa=9.146;%  Resistanse of stator,[Ohm]
if n1==1
rra=4.196;% CU Resistance of rotor,[Ohm]
xrc=8.68;% Dissipated inductive resistance of rotor,[Ohm]
kpd=0.83;
elseif n1==2
rra=8.393; % ALumin  Resistance of rotor,[Ohm]
xrc=8.68; % Dissipated inductive resistance of rotor,[Ohm]
kpd=0.82;
else
rra=4.474;% Latun Resistance of rotor,[Ohm]
xrc=9.007; % Dissipated inductive resistance of rotor,[Ohm]
kpd=0.82;
end
xm=251.52;  % Mutual inductive resistance of stator and rotor,[Ohm]
xsc=11.709; % Dissipated inductive resistance of stator,[Ohm] 
lsa=(xsc+xm)/(2*pi*f1); % Inductance of stator,[Hen] 
lra=(xrc+xm)/(2*pi*f1);% Inductance  of rotor,[Hen]
ma=xm/(2*pi*f1);  % Mutual inductance of stator and rotor,[Hen]
jra=0.008; % Moment of inertia,[KG*M^2)]
%============================
Inom=P2*1e3/(mf*Ufn*kpd*cosfi);% Nominal current of phase, [A]
Mnom=P2*1e3/omegc/(1-snm);% Nominal moment, [N*M];
%============================
% Calculation of bases units (BLOK 2)
%============================
ibs=Inom*sqrt(2);
ubs=Ufn*sqrt(2);
zbs=ubs/ibs;
wbs=2*pi*f1;
lbs=zbs/wbs;
pbs=3/2*ubs*ibs;
tbs=1/wbs;
mbs=p*pbs/wbs;
psibs=ubs*tbs;
jbs=p*mbs/(wbs^2);
%disp([ubs ibs zbs mbs]);
%disp([pbs psibs]);
%disp([tbs jbs]);
%========================================
% Parameters of differensial equations (DE) 
%    in relative units (BLOK 3)
%========================================
rs=rsa/zbs;
m=ma/lbs;
rr=rra/zbs;
ls=lsa/lbs;
lr=lra/lbs;
jr=jra/jbs;
mn=Mnom/mbs;
mc=0.5;% moment of load (o.e)
%=========================================
% Calculation of coefficients DE (BLOK 4)
%=========================================
a1=lr/(ls*lr-m^2);
a2=ls/(ls*lr-m^2);
a3=m/(ls*lr-m^2);
a4=m/(ls*lr-m^2);
a5=1/jr;
aa1=rs*a1;
aa2=rs*a3;
aa3=rr*a3;
aa4=rr*a2;
%disp([aa1 aa2 aa3 aa4 a4 a5]');
%=======================================
%  MAIN PROGRAM OF SOLUTION DE (BLOK 5)
%=======================================
disp('     << Wait... Go callculation... >> ');
t0=0;% Start time 
tfin=60;%100;% (80-150)  tfin=(0.2-0.3)/tbs for IM 10-50[kWT];
y0=[0 0 0 0 0]';% Start data y for time t=0;
tspan = [t0 tfin]; 
%==============================================
%tol=1.e-6;% accuracy of calculation 
%trace=0;
%options = odeset('RelTol',1e-3,'AbsTol',1e-6);
%[t,y] = ODE45('vpk',tspan,y0,options);
%==============================================
%========!!!!!!!!!!!!!!!!!!!!!!!!!=============
[t,y]=ode23('Vpk1',tspan,y0);% The sinusoidal suplied induction motor (IM)
%[t,y]=ode23('Vpk2',tspan,y0);% The restangular-wave inverter fed IM 
n=max(size(t));
me=zeros(n,1);
i1a=zeros(n,1);
i1b=zeros(n,1);
iaa=zeros(n,1);
isum=zeros(n,1);
omeg=zeros(n,1);
%============= BLOK (6)====================
me(:)=a4.*(y(:,2).*y(:,3)-y(:,1).*y(:,4));
i1a(:)=a1.*y(:,1)-a3.*y(:,3);
i1b(:)=a1.*y(:,2)-a3.*y(:,4);
%i2(:,1)=a2.*y(:,3)-a3.*y(:,1);
%i2(:,2)=a2.*y(:,4)-a3.*y(:,2);
iaa(:)=i1a(:).^2+i1b(:).^2;
isum(:)=iaa(:).^0.5;
omeg(:)=y(:,5);
%============================
% INPUT OF GRAFICS (BLOK 6)
%============================
%figure(1);
%hp=plot(t,i1a(:),'k-'); grid,
%set(hp,'LineWidth',1.2);
%ht1=title('Starting current  versus time, (o.e)');
%set(ht1,'FontSize',10,'FontAngl','italic','FontWeigh','bold');
%xlabel('  Time,(o.e.)'),
%hy1=ylabel('Current');
%set(hy1,'FontSize',10,'FontAngle','italic','FontWeight','bold');
%============================================
N0=35;
N2=length(t);
N1=N2-N0;
i1a1=i1a(N1:N2);
DT=t(N2)-t(N1);
X=t(N1:N2);
Y=i1a1.^2;
F=trapz(X,Y); F1=sqrt(F/DT);
Id=num2str(F1);disp([' Ir= ', Id,' [o.e.];']);
%============================
Mx=me(N1:N2);
Mmax=max(Mx(:)); Mmin=min(Mx(:));
mm=num2str(Mmax); mn=num2str(Mmin);
disp([' Mmax= ',mm,'; Mmin=',mn, ' [o.e]']);
%plot(X,Y,'-k',X,i1a1,'-r');grid on
plot(X,Mx,'-k');grid on
%=============================
disp('  <= Callculation is end= >');