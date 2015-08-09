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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% LINEAR STRAIN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Archivo en .TXT
if Lenguage == 1
	fprintf( du_txt_lin , '================== Linear Strain IETFEM v%s ===========================\n\n\n',version)
	fprintf( du_txt_lin , 'Inputfile: %s  ... \n\n', input_file )
	fprintf( du_txt_lin , 'Solve time: %6.3f \n\n',tiempo)
	if SD_LD ~= 1
    fprintf( du_txt_lin , 'Problem type: %s %sD large deformation and displacement\n\n',KP,Dim)
  else
    fprintf( du_txt_lin , 'Problem type: %s %sD small deformation and displacement\n\n',KP,Dim)
  end
	fprintf( du_txt_lin , 'Number of elements: %i \n\n\n', NElem)
	fprintf( du_txt_lin , 'Strain for linear analyze: \n\n')
elseif Lenguage == 2
	fprintf( du_txt_lin , '================== Deformación Lineal IETFEM v%s ===========================\n\n\n',version)
	fprintf( du_txt_lin , 'Archivo de entrada: %s  ... \n\n', input_file )
	fprintf( du_txt_lin , 'Tiempo en resolver: %6.3f \n\n',tiempo)
	if SD_LD ~= 1
    fprintf( du_txt_lin , 'Tipo de problema: %s %sD grandes deformaciones y desplazamientos\n\n',KP,Dim)
  else
    fprintf( du_txt_lin , 'Tipo de problema: %s %sD pequeñas deformaciones y desplazamientos\n\n',KP,Dim)
  end
	fprintf( du_txt_lin , 'Número de elementos: %i \n\n\n', NElem)
	fprintf( du_txt_lin , 'Deformación con análisis lineal: \n\n')
end
	
fprintf( du_txt_lin ,   '---------------------------------- \n')
if Lenguage == 1
	fprintf( du_txt_lin , '| Element  |       Strain        | \n')
elseif Lenguage == 2
	fprintf( du_txt_lin , '| Elemento |     Deformación     | \n')
end
fprintf( du_txt_lin ,   '---------------------------------- \n')
for i=1:NElem,
	fprintf( du_txt_lin , '| %8i |    %12.2e     | \n',i,EPS_lineal(i))
end
fprintf( du_txt_lin ,   '---------------------------------- \n')

fclose(du_txt_lin) ;
tiempo_du_txt_lin = toc ;
tiempo_TXT = tiempo_TXT + tiempo_du_txt_lin;









