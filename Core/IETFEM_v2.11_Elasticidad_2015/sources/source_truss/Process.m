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

%%%%%%%%%%%%% PROCESS %%%%%%%%%%%%%%%%%%%%%%%%%

if Lenguage == 1
	fprintf('\nHere IETFEM start to resolve the problem:\n\n')
else
	fprintf('\nAqui IETFEM comienza a resolver el problema:\n\n')
end
Flineal     = Fpuntual + Fb_Dead + Ftemp + Fgamm;

N_lineal    = [];
FINT_lineal = zeros(3*NNod,1);
Kelem       = zeros(6,6*NElem);
Ulineal     = zeros(3*NNod,1);
EPS_lineal  = [];


% ======================================================================================
% ======================================================================================
% ============== Sistema Lineal ===============
% ======================================================================================
% ======================================================================================
tic
if Lenguage == 1
  fprintf(' - Linear solution.\n')
else
  fprintf(' - Realizando solucion lineal.\n')
end

GlobStiffMat = SpriStiffMat ;
%	
% ============ Matriz de rigidez ==============		
%
for ele = 1:NElem
  %
  l   = largos(ele);
  L   = Largos(ele);
  EAL = Youngs(ele)*Areas(ele)/L;
  %
  KL = EAL*(R1+(l/L)^2*R2);
  %
  KG = Rot(:,6*ele-5:6*ele)*KL*transpose(Rot(:,6*ele-5:6*ele));
  %
  Kelem(:,6*ele-5:6*ele) = KG;
  %
  gdle = GDLE(ele,:) ;
  %
  GlobStiffMat(gdle,gdle) =  GlobStiffMat(gdle,gdle) + KG;
  %
end

K = GlobStiffMat(NeumDF,NeumDF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%
Klineal_total    = GlobStiffMat;
Klineal_reducida = K;
%~ if rcond(K) <= 1e-10
	%~ if Lenguage == 1
    %~ fprintf('\n********* ATENTION *********\n\n')
	%~ else
    %~ fprintf('\n********* ATENCION *********\n\n')
    %~ fprintf('IETFEM usara la pseudo inversa dado que rcond = %12e3\n\n',rcond(K));
  %~ end
	%~ K = pinv(K);
	%~ dUlineal         = K^-1* Flineal(NeumDF);
%~ else
	%~ Ksparse          = sparse(Klineal_reducida);
	%~ dUlineal         = Ksparse \ Flineal(NeumDF);
%~ end
if rcond(K)<= 1e-10
	if Lenguage == 1
		fprintf('\n********* ATENTION *********\n\n')
		fprintf('     CONDITION PROBLEM: %12e3\n',cond(K))
		fprintf('     BAD CONDITIONED PROBLEM!!! DO YOU WANT TO CONTINUE?\n')
		BAD_COND=input('     YES / NO:','s');
		if BAD_COND == 'NO'
			cd ..
			fprintf('     IETFEM END!!! CHECK YOUR INPUT!!! PROBABLY BAD DISPLACEMENT CONDITIONS.\n')
			return
		end
	elseif Lenguage == 2
		fprintf('\n********* ATENCION *********\n\n')
		fprintf('     NUMERO DE CONDICION: %12e3\n',cond(K))
		fprintf('     PROBLEMA MAL CONDICIONADO!!! QUIERE CONTINUAR RESOLVIENDO DE TODOS MODOS?\n')
		BAD_COND=input('     SI / NO:','s');
		if BAD_COND == 'NO'
			cd ..
			fprintf('     IETFEM FINALIZO!!! REVISE EL ARCHIVO DE ENTRADA!!! PROBABLEMENTE MAL LAS CONDICIONES EN DESPLAZAMIENTOS.\n')
			return
		end
	end
end

Ksparse          = sparse(Klineal_reducida);
dUlineal         = Ksparse \ Flineal(NeumDF);
Ulineal(NeumDF)  = dUlineal;

%
Mdef_lin              = [];
Deformado_lin         = zeros(3*NNod,1);
Deformado_lin(NeumDF) = dUlineal;
for j = 1:NNod
  %
  aux      = Deformado_lin([3*j-2:3*j])';
  Mdef_lin = [Mdef_lin;aux];
  %
end
NodCoordMatDef_lin = NodCoordMatDef_lin+Mdef_lin;
% ======== Calculo solicitaciones =============
Fint    = zeros(3*NNod,1);
for ele = 1:NElem
  %
  gdle = GDLE(ele,:) ;
  %
  UL = transpose(Rot(:,6*ele-5:6*ele))*Ulineal(gdle);
  %
  Ee  = Youngs(ele);
  Ae  = Areas(ele);
  %
  L   = Largos(ele);
  %
  EPS = (UL(4)-UL(1))/L;
  EPS_lineal = [ EPS_lineal , EPS ];
  %
  directa  = Ee*Ae*EPS;
  N_lineal = [N_lineal, directa];
  Directa  = directa*Rot(:,6*ele-5:6*ele)*[-1 0 0 1 0 0]';
  %
  gdle     = GDLE(ele,:);
  %
  FINT_lineal(gdle) = FINT_lineal(gdle) + Directa;
  %
end

largos_lineal = Largos.*(EPS_lineal+1);

R_lineal = zeros(3*NNod,1);
R_lineal(DiriDF) = FINT_lineal(DiriDF);
for i=1:NNod*3
	if abs(R_lineal(i))<=0.0000001
		R_lineal(i)=0;
	end
end

Sigma_lin = N_lineal./Areas;

R_lineal = R_lineal - FpuntualDiriDF;

lineal_time =toc;
% ======================================================================================
% ======================================================================================
% ======================================================================================
% ======================================================================================




if SD_LD == 1
  if Lenguage == 1
    fprintf(' - After %6.3f seconds, IETFEM complete Process module.\n',lineal_time)
  else
    fprintf(' - Luego de %6.3f segundos, IETFEM competo el modulo "Process".\n',lineal_time)
  end
  process_time = lineal_time;
end






