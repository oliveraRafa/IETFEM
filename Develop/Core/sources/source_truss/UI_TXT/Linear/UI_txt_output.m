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
% Last update:  Sep-2015  v.2.21
%
% Developed for GNU-Octave 3.6.4
% View license.txt for licensing information (inside tutoriales folder).
%
% =======================================================
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% User Interface Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Archivo en .TXT
fprintf( complete_UI_output , '\nRESULTADOS\n\n');

fprintf( complete_UI_output , 'Desplazamientos de los nodos\n');
fprintf( complete_UI_output , 'u_x	        u_y	        u_z\n');
for i=1:NNod,
  aux = node2dof(i,3);
  fprintf( complete_UI_output , '%8.2e\t%8.2e\t%8.2e\n',Ulineal(aux(1)),Ulineal(aux(2)),Ulineal(aux(3)));
end

fprintf( complete_UI_output , '\nParametros en barras\n');
fprintf( complete_UI_output , 'Deformación           Fuerza             Tension\n');
for i=1:NElem,
	fprintf( complete_UI_output , '%8.2e\t%8.2e\t%8.2e\n',EPS_lineal(i),N_lineal(i),Sigma_lin(i));
end

fclose(complete_UI_output) ;
