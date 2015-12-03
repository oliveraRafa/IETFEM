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
%%%%%%%%%%%%%%%%%%%%%%%%% AXIAL FORCE LINEAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Archivo en .TXT
if Lenguage == 1
	fprintf( axial_txt_lin , '================== Axial Force IETFEM v%s ===========================\n\n\n',version)
	fprintf( axial_txt_lin , 'Inputfile: %s  ... \n\n', input_file )
	fprintf( axial_txt_lin , 'Solve time: %6.3f \n\n',tiempo)
	if SD_LD ~= 1
    fprintf( axial_txt_lin , 'Problem type: %s %sD large deformation and displacement\n\n',KP,Dim)
  else
    fprintf( axial_txt_lin , 'Problem type: %s %sD small deformation and displacement\n\n',KP,Dim)
  end
	fprintf( axial_txt_lin , 'Force magnitude: %s \n\n' , ForceMagnitude)
	fprintf( axial_txt_lin , 'Number of elements: %i \n\n\n', NElem)
	fprintf( axial_txt_lin , 'Axial Force for Linear analyze: \n\n')
elseif Lenguage == 2
	fprintf( axial_txt_lin , '================== Fuerza Axial IETFEM v%s ===========================\n\n\n',version)
	fprintf( axial_txt_lin , 'Archivo de entrada: %s  ... \n\n', input_file )
	fprintf( axial_txt_lin , 'Tiempo en resolver: %6.3f \n\n',tiempo)
	if SD_LD ~= 1
    fprintf( axial_txt_lin , 'Tipo de problema: %s %sD grandes deformaciones y desplazamientos\n\n',KP,Dim)
  else
    fprintf( axial_txt_lin , 'Tipo de problema: %s %sD pequeñas deformaciones y desplazamientos\n\n',KP,Dim)
  end
	fprintf( axial_txt_lin , 'Magnitud de fuerza: %s \n\n' , ForceMagnitude)
	fprintf( axial_txt_lin , 'Número de elementos: %i \n\n\n', NElem)
	fprintf( axial_txt_lin , 'Fuerza Axial con análisis Lineal: \n\n')
end
	
fprintf( axial_txt_lin ,   '---------------------------------%s \n',line2)
if Lenguage == 1
	fprintf( axial_txt_lin , '| Element  |  Axial Force (%s)   | \n',ForceMagnitude)
elseif Lenguage == 2
	fprintf( axial_txt_lin , '| Elemento |  Fuerza Axial (%s)  | \n',ForceMagnitude)
end
fprintf( axial_txt_lin ,   '---------------------------------%s \n',line2)
for i=1:NElem,
	fprintf( axial_txt_lin , '| %8i |     %12.2e   %s| \n',i,N_lineal(i),space2)
end
fprintf( axial_txt_lin ,   '---------------------------------%s \n',line2)

fclose(axial_txt_lin) ;
tiempo_axial_txt_lin = toc ;
tiempo_TXT = tiempo_TXT + tiempo_axial_txt_lin;
