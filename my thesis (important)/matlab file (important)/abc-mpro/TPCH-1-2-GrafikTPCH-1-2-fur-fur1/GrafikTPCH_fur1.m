load DanTPCH;% Dannie out file TPCH1.m [Model==AD+TPCH],
% a takze iz file TPCH1a.m and TPCH2.m [Model==Ua=sin(w*t),Ub=cos(w*t)]
% Postroenie spektra of  FURIE
clc;
t=ans(1,:);
Psa=ans(2,:);
Pra=ans(3,:);
Psb=ans(4,:);
Prb=ans(5,:);
Ua=ans(6,:);
Ub=ans(7,:);
%==================
a7=25.11; a8=22.81;
Isa=Psa.*a7-Pra.*a8;
%Pow=1.5.*(Ua.*Isa+Ub.*Isb);
%========================
N=length(t);% dlina vektora t
tk=t(N)-t(200);
t1=t(200:end);
t2=t(200:end)-t(200);
N1=length(t1);% dlina vektora t1
N2=length(t2);
Isa1=Isa(200:end);%% dlina vektora Isa1
Isa2=Isa(200:end)-Isa(200);
NI1=length(Isa1);
NI2=length(Isa2);
disp('   N      N1    N2    NI1   NI2')
disp([N,N1,N2,NI1,NI2]);
dt=zeros(1,542);
%=======================
for i=1:541;
    k=i+1;
dt(i)=t(k)-t(i);
end;
ddt=dt.*1e5;
figure(1);
%plot(ddt(1:542));grid
stem(ddt(1:542)); grid
%=====================
Y=fft(Isa2,512);
Af=Y.*conj(Y)./512;
f=1e4/5*(0:255)/512;% 1e4/35
%======================
X=fftshift(Y);
Af1=X.*conj(X)./512;
Nf=length(f);
NAf=length(Af);
NAf1=length(Af1);
disp('    Nf,  NAf,  NAf1')
disp([Nf,NAf,NAf1]);
%=====================
figure(2),
hp4=plot(Af,'k'); grid ;
set(hp4,'LineWidth',2);
hx4=Xlabel(' frequensy, [Hz] ');
set(hx4,'FontSize',10,'FontWeight','bold');
hy4=Ylabel(' Amplituda ');
set(hy4,'FontSize',10,'FontWeight','bold');
ht4=Title('Spektr Furie ');
set(ht4,'FontSize',12,'FontName','Arial','FontWeight','bold');
%=======================
disp('The end');