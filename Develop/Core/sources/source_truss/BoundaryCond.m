% =====================================================
% =============      IETFEM     =======================
% ============= User Interface  =======================
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
%
% site:
%   
%
% Last update:  Sep-2015  v.0.01
%
% Developed for GNU-Octave 3.6.4
% View license.txt for licensing information (inside tutoriales folder).
%
% =======================================================
%
%%%%%%%%%%%%% PROCESS %%%%%%%%%%%%%%%%%%%%%%%%%

% ====================================================
% ================ Boundary conditions ===============
% ====================================================

% --------- DIRICHLET -----------

DiriDF = [] ;
UDiri  = [] ;
%
for i = 1 : size(DiriCondMat,1)
  %
  for j = 1 : 3
    %
    aux = DiriCondMat(i,j+1) ;
    %
    if aux<inf
      DiriDF = [ DiriDF , 3 * (DiriCondMat(i,1)-1)+j ];
      UDiri  = [ UDiri ; aux ];
    end
    %
  end %for NDFPN
  %
end % for NNodDiriCond

DiriDFZero = []; % Los Dirichlet que valen 0, fijos/apoyos.

for i = 1 : length(DiriDF)
  if max(abs(UDiri)) == 0
    DiriDFZero = DiriDF ;
  else
    if UDiri(i) == 0
      DiriDFZero = [DiriDFZero DiriDF(i)];
    end
  end
end

% ---------- NEUMAN ------------

NeumDF          = 1:(NNod*3)  ;
NeumDF (DiriDF) = []              ;

% ---------- FORCES ------------

Fpuntual = zeros( 3 * NNod , 1 ) ;

% Puntual forces
PlotFpuntual = [];
for i = 1 : NNodNeumCond
  %
  auxNeum1 = node2dof(NeumCondMat( i , 1 ),3);
  %
  Fpuntual(auxNeum1) = NeumCondMat(i,[2:4]) ;
  %
  PlotFpuntual  = [PlotFpuntual, auxNeum1];
  %
end % for NNodDiriCond
%
% Temperature and volume forces
%
Ftemp  = zeros( 3*NNod, 1 ) ;
Fgamm  = zeros( 3*NNod, 1 ) ; %Peso propio
%
Fbx_Dead = zeros( 3*NNod, 1 ) ;
Fby_Dead = zeros( 3*NNod, 1 ) ;
Fbz_Dead = zeros( 3*NNod, 1 ) ;
%
for ele = 1:NElem
  %
  Q = Rot(:,6*ele-5:6*ele) ;
  %
  gdle = GDLE(ele,:) ;
  %
  Ftemp (gdle) = Ftemp (gdle) + transpose(Q)*[-1 0 0 1 0 0]'*Areas(ele)*Youngs(ele)*Alphas (ele)*Temp(ele);
  %
  if Dimensions == 3
    Fgamm (gdle) = Fgamm (gdle) - [0 0 1 0 0 1]'*Areas(ele)*Largos(ele)*(Gammas(ele)/2);
  else
    Fgamm (gdle) = Fgamm (gdle) - [0 1 0 0 1 0]'*Areas(ele)*Largos(ele)*(Gammas(ele)/2);
  end
  %
  Fbx_Dead(gdle) = Fbx_Dead(gdle) + [1 0 0 1 0 0]'*DeltaX(ele)*(VolCondMatDead(ele,2)/2);
  Fby_Dead(gdle) = Fby_Dead(gdle) + [0 1 0 0 1 0]'*DeltaY(ele)*(VolCondMatDead(ele,3)/2);
  Fbz_Dead(gdle) = Fbz_Dead(gdle) + [0 0 1 0 0 1]'*DeltaZ(ele)*(VolCondMatDead(ele,4)/2);
  %
end
%
Fb_Dead = Fbx_Dead + Fby_Dead + Fbz_Dead;
% ------------ ROBIN ------------

SpriStiffMat = zeros( 3*NNod , 3*NNod ) ;

if NNodRobiCond > 0
  %
  for i = 1 : NNodRobiCond
		%
		RobiDF = node2dof ( RobiCondMat (i,1) , 3 ) ;
		SpriStiffMat( RobiDF , RobiDF ) = diag ( RobiCondMat ( i , 2 : ( 3 + 1 )))  ;
		%
  end
  %
end

FpuntualDiriDF = zeros( 3 * NNod , 1 ) ; % Fuerzas en apoyos/fijos

if length(DiriDFZero)>0 
  FpuntualDiriDF(DiriDFZero) = Fpuntual(DiriDFZero) + Fb_Dead(DiriDFZero) + Ftemp(DiriDFZero) + Fgamm(DiriDFZero);
end


