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
%%%%%%%%%%%%%%%%%%%%%%%%% STRESSES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
if Lenguage == 1
	fprintf( sigma_txt_lin , '================== STRESSES IETFEM v%s ===========================\n\n\n',version)
	fprintf( sigma_txt_lin , 'Inputfile: %s  ... \n\n', input_file )
	fprintf( sigma_txt_lin , 'Solve time: %6.3f seconds\n\n',tiempo)
	if SD_LD ~= 1
    fprintf( sigma_txt_lin , 'Problem type: %s %sD large deformation and displacement\n\n',KP,Dim)
  else
    fprintf( sigma_txt_lin , 'Problem type: %s %sD small deformation and displacement\n\n',KP,Dim)
  end
	fprintf( sigma_txt_lin , 'Force magnitude: %s \n\n' , ForceMagnitude)
	fprintf( sigma_txt_lin , 'Length magnitude: %s \n\n' , LengthMagnitude)
	fprintf( sigma_txt_lin , 'Number of elements: %i \n\n', NElem)
elseif Lenguage == 2
	fprintf( sigma_txt_lin , '================== Tensiones IETFEM v%s ===========================\n\n\n',version)
	fprintf( sigma_txt_lin , 'Archivo de entrada: %s  ... \n\n', input_file )
	fprintf( sigma_txt_lin , 'Tiempo en resolver: %6.3f segundos\n\n',tiempo)
	if SD_LD ~= 1
    fprintf( sigma_txt_lin , 'Tipo de problema: %s %sD grandes deformaciones y desplazamientos\n\n',KP,Dim)
  else
    fprintf( sigma_txt_lin , 'Tipo de problema: %s %sD pequeñas deformaciones y desplazamientos\n\n',KP,Dim)
  end
	fprintf( sigma_txt_lin , 'Magnitud de fuerza: %s \n\n' , ForceMagnitude)
	fprintf( sigma_txt_lin , 'Magnitud de longitud: %s \n\n' , LengthMagnitude)
	fprintf( sigma_txt_lin , 'Número de elementos: %i \n\n', NElem)
end


fprintf( sigma_txt_lin , 'Sigma_lin = N_lin/A  \n\n')


fprintf( sigma_txt_lin , '------------------------%s \n',line3)
if Lenguage == 1
	fprintf( sigma_txt_lin , '  Stresses (%s/%s^2)              \n',ForceMagnitude,LengthMagnitude)
elseif Lenguage == 2
	fprintf( sigma_txt_lin , ' Tensiones (%s/%s^2)              \n',ForceMagnitude,LengthMagnitude)
end
fprintf( sigma_txt_lin , '------------------------%s \n',line3)
fprintf( sigma_txt_lin , '| Elem |    Sigma_lin  %s| \n',space3)
fprintf( sigma_txt_lin , '------------------------%s \n',line3)
for i=1:NElem,
	fprintf( sigma_txt_lin , '| %4i | %12.2e  %s|\n',i,Sigma_lin(i),space3)
end
fprintf( sigma_txt_lin , '------------------------%s \n\n',line3)
	
fclose(sigma_txt_lin) ;
tiempo_sigma_txt_lin = toc ;
tiempo_TXT = tiempo_TXT + tiempo_sigma_txt_lin;
