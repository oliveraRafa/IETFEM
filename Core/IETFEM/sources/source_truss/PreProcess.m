% =====================================================
% =============      IETFEM     =======================
% =====================================================
%
% Instituto de Estructuras y Transporte
% Finite Element Method solver
% Facultad de Ingeniería
% Universidad de la República
% Uruguay
%
% Project Leaders:
%   Pablo Castrillo Green
%   Jorge Martín Perez Zerpa
%
% Colaborators:
%   A. Spalvier
%   ARCHFEM: Mihdi Caballero / Yessica Rodriguez / Francisco Vidovich
%   anybody who would like to contribute...
%
% site:
%   
%
% Last update:  Mar-2015  v.2.11
%
% Developed for GNU-Octave 3.6.4
% View license.txt for licensing information (inside tutoriales folder).
%
% =======================================================
%

%
% ============ PREPROCESS ==========================
%
tic
if Lenguage == 1
	fprintf('\nInternal calculate for some parameters:\n\n')
else
	fprintf('\nCalculo de parametros internos:\n\n')
end
XElemMat = []; YElemMat = []; ZElemMat = [];
Rot    = zeros(6,6*NElem);
Largos = [];
DeltaX = []; DeltaY = []; DeltaZ = [];
GDLE   = [];
if Lenguage == 1
	fprintf(' - Initial parameters.\n')
else
	fprintf(' - Parametros iniciales.\n')
end
%
for ele = 1:NElem
  %
  XElemMat(ele,:) = NodCoordMat( ConectMat (ele,:) , 1 )'  ;
  YElemMat(ele,:) = NodCoordMat( ConectMat (ele,:) , 2 )'  ;
  ZElemMat(ele,:) = NodCoordMat( ConectMat (ele,:) , 3 )'  ;
  %
  x1 = XElemMat(ele,:)(1); y1 = YElemMat(ele,:)(1); z1 = ZElemMat(ele,:)(1);
  x2 = XElemMat(ele,:)(2); y2 = YElemMat(ele,:)(2); z2 = ZElemMat(ele,:)(2);
  %
  dx = x2 - x1; dy = y2 - y1; dz = z2 - z1;
  DeltaX = [DeltaX, abs(dx)]; DeltaY = [DeltaY, abs(dy)]; DeltaZ = [DeltaZ, abs(dz)];
  L = sqrt(dx*dx + dy*dy + dz*dz);
  %
  Largos = [Largos,L];
  %
  XL = dx/L; 
	YL = dy/L;
	ZL = dz/L;
  %	
  if XL==0 && YL==0
    %
		Q = [XL, 1, 0 ,   0, 0, 0;
         YL, 0, 1 ,   0, 0, 0;
         ZL, 0, 0 ,   0, 0, 0;
          0, 0, 0 ,  XL, 1, 0;
          0, 0, 0 ,  YL, 0, 1;
          0, 0, 0 ,  ZL, 0, 0];
    %
	else
    %
		Q = [XL, -YL/sqrt(YL^2+XL^2), -XL*ZL/sqrt(YL^2+XL^2)     ,   0,  0                   , 0                          ;
         YL,  XL/sqrt(YL^2+XL^2), -YL*ZL/sqrt(YL^2+XL^2)     ,   0,  0                   , 0                          ;
         ZL,  0                 , (XL^2+YL^2)/sqrt(YL^2+XL^2),   0,  0                   , 0                          ;
          0,  0                 ,  0                         ,  XL, -YL/sqrt(YL^2+XL^2)  , -XL*ZL/sqrt(YL^2+XL^2)     ;
          0,  0                 ,  0                         ,  YL,  XL/sqrt(YL^2+XL^2)  , -YL*ZL/sqrt(YL^2+XL^2)     ;
          0,  0                 ,  0                         ,  ZL,  0                   , (XL^2+YL^2)/sqrt(YL^2+XL^2)];
    %
	end
	%		
	Rot(:,6*ele-5:6*ele) = Q;
	%
	gdle = [ 3*ConectMat(ele,1)-2:3*ConectMat(ele,1)  3*ConectMat(ele,2)-2:3*ConectMat(ele,2) ] ;
	%
	GDLE   = [GDLE; gdle];
end
%
largos             = Largos;
NodCoordMatDef_fin = NodCoordMat;
NodCoordMatDef_lin = NodCoordMat;
deltaX = DeltaX ; deltaY = DeltaY ; deltaZ = DeltaZ ;
%
% ========== Matrices elementales ============

if Lenguage == 1
	fprintf(' - Elemental matrices.\n')
else
	fprintf(' - Matrices elementales.\n')
end
Kelem = zeros(6,6*NElem);

K1 = zeros(6);
K1(1,1)=1;K1(4,4)=1;K1(1,4)=-1;K1(4,1)=-1;
K2 = zeros(6);K2(2,2)=1;K2(3,3)=1;K2(5,5)=1;K2(6,6)=1;K2(2,5)=-1;K2(5,2)=-1;K2(6,3)=-1;K2(3,6)=-1;

R1     = -1/2*(K1+K2);, R2=1/2*(3*K1+K2);

%
preprocess_time = toc ;

if Lenguage == 1
  fprintf(' - After %6.3f seconds, IETFEM complete PreProcess module.\n',preprocess_time)
else
  fprintf(' - Luego de %6.3f segundos, IETFEM competo el modulo "PreProcess".\n',preprocess_time)
end






