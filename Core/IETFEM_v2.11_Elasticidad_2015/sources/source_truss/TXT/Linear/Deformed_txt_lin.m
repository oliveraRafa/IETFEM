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
%%%%%%%%%%%%%%%%%%%%%%%%% Desplazamientos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
if Lenguage == 1
	NN="Node";
	fprintf( deformed_txt_lin , '================== Linear Displacement IETFEM v%s ===========================\n\n\n',version)
	fprintf( deformed_txt_lin , 'Inputfile: %s  ... \n\n', input_file )
	fprintf( deformed_txt_lin , 'Solve time: %6.3f seconds\n\n',tiempo)
	if SD_LD ~= 1
    fprintf( deformed_txt_lin , 'Problem type: %s %sD large deformation and displacement\n\n',KP,Dim)
  else
    fprintf( deformed_txt_lin , 'Problem type: %s %sD small deformation and displacement\n\n',KP,Dim)
  end
	fprintf( deformed_txt_lin , 'Length magnitude: %s \n\n' , LengthMagnitude)
	fprintf( deformed_txt_lin , 'Number of nodes: %i \n\n', NNod)
elseif Lenguage == 2
	NN="Nodo";
	fprintf( deformed_txt_lin , '================== Desplazamiento Lineal IETFEM v%s ===========================\n\n\n',version)
	fprintf( deformed_txt_lin , 'Archivo de entrada: %s  ... \n\n', input_file )
	fprintf( deformed_txt_lin , 'Tiempo en resolver: %6.3f segundos\n\n',tiempo)
	if SD_LD ~= 1
    fprintf( deformed_txt_lin , 'Tipo de problema: %s %sD grandes deformaciones y desplazamientos\n\n',KP,Dim)
  else
    fprintf( deformed_txt_lin , 'Tipo de problema: %s %sD pequeñas deformaciones y desplazamientos\n\n',KP,Dim)
  end
	fprintf( deformed_txt_lin , 'Magnitud de longitud: %s \n\n' , LengthMagnitude)
	fprintf( deformed_txt_lin , 'Número de nodos: %i \n\n', NNod)
end
if NDFPN == 1
	fprintf( deformed_txt_lin , '----------------------%s \n',line1)
	if Lenguage == 1
		fprintf( deformed_txt_lin , '  Displacements (%s)  \n',LengthMagnitude)
	elseif Lenguage == 2
		fprintf( deformed_txt_lin , 'Desplazamientos (%s)  \n',LengthMagnitude)
	end
	fprintf( deformed_txt_lin , '----------------------%s \n',line1)
	fprintf( deformed_txt_lin , '| %s |       u_x   %s|\n',NN,space1)
	fprintf( deformed_txt_lin , '----------------------%s \n',line1)
	for i=1:NNod,
		fprintf( deformed_txt_lin , '| %4i | %12.2e %s|\n',i,Ulineal(node2dof(i,3)(1)),space1)
	end
	fprintf( deformed_txt_lin , '----------------------%s \n\n\n',line1)
elseif NDFPN == 2
	fprintf( deformed_txt_lin , '----------------------------------------%s \n',line1)
	if Lenguage == 1
		fprintf( deformed_txt_lin , '           Displacements (%s)         \n',LengthMagnitude)
	elseif Lenguage == 2
		fprintf( deformed_txt_lin , '           Desplazamientos (%s)         \n',LengthMagnitude)
	end
	fprintf( deformed_txt_lin , '----------------------------------------%s \n',line1)
	fprintf( deformed_txt_lin , '| %s |       u_x      |        u_y   %s|\n',NN,space1)
	fprintf( deformed_txt_lin , '----------------------------------------%s \n',line1)
	for i=1:NNod,
		fprintf( deformed_txt_lin , '| %4i |  %12.2e  | %12.2e %s|\n',i,Ulineal(node2dof(i,3)(1)),Ulineal(node2dof(i,3)(2)),space1)
	end
	fprintf( deformed_txt_lin , '----------------------------------------%s \n\n\n',line1)
elseif NDFPN == 3
	fprintf( deformed_txt_lin , '--------------------------------------------------------%s \n',line1)
	if Lenguage == 1
		fprintf( deformed_txt_lin , '                   Displacements (%s)                 \n',LengthMagnitude)
	elseif Lenguage == 2
		fprintf( deformed_txt_lin , '                   Desplazamientos (%s)                 \n',LengthMagnitude)
	end
	fprintf( deformed_txt_lin , '--------------------------------------------------------%s \n',line1)
	fprintf( deformed_txt_lin , '| %s |       u_x     |       u_y     |       u_z     %s|\n',NN,space1)
	fprintf( deformed_txt_lin , '--------------------------------------------------------%s \n',line1)
	for i=1:NNod,
		fprintf( deformed_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e  %s|\n',i,Ulineal(node2dof(i,3)(1)),Ulineal(node2dof(i,3)(2)),Ulineal(node2dof(i,3)(3)),space1)
	end
	fprintf( deformed_txt_lin , '--------------------------------------------------------%s \n\n',line1)
end

fclose(deformed_txt_lin) ;
tiempo_deformed_txt_lin = toc ;
tiempo_TXT = tiempo_TXT + tiempo_deformed_txt_lin;

