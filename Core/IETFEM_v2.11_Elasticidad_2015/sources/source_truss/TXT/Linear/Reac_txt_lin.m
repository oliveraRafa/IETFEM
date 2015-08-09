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
%%%%%%%%%%%%%%%%%%%%%%%%% Reacciones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
if Lenguage == 1
	fprintf( reac_txt_lin , '================== Linear Support Reactions IETFEM v%s ===========================\n\n\n',version)
	fprintf( reac_txt_lin , 'Inputfile: %s  ... \n\n', input_file )
	fprintf( reac_txt_lin , 'Solve time: %6.3f seconds\n\n',tiempo)
	if SD_LD ~= 1
    fprintf( reac_txt_lin , 'Problem type: %s %sD large deformation and displacement\n\n',KP,Dim)
  else
    fprintf( reac_txt_lin , 'Problem type: %s %sD small deformation and displacement\n\n',KP,Dim)
  end
	fprintf( reac_txt_lin , 'Force magnitude: %s \n\n' , ForceMagnitude)
	fprintf( reac_txt_lin , 'Number of supports: %i \n\n', NNodDiriCond)
elseif Lenguage == 2
	fprintf( reac_txt_lin , '================== Reacciones Lineal IETFEM v%s ===========================\n\n\n',version)
	fprintf( reac_txt_lin , 'Archivo de entrada: %s  ... \n\n', input_file )
	fprintf( reac_txt_lin , 'Tiempo en resolver: %6.3f segundos\n\n',tiempo)
	if SD_LD ~= 1
    fprintf( reac_txt_lin , 'Tipo de problema: %s %sD grandes deformaciones y desplazamientos\n\n',KP,Dim)
  else
    fprintf( reac_txt_lin , 'Tipo de problema: %s %sD pequeñas deformaciones y desplazamientos\n\n',KP,Dim)
  end
	fprintf( reac_txt_lin , 'Magnitud de fuerza: %s \n\n' , ForceMagnitude)
	fprintf( reac_txt_lin , 'Número de apoyos: %i \n\n', NNodDiriCond)
end

if NDFPN == 1
  fprintf( reac_txt_lin , '------------------------%s \n',line2)
  if Lenguage == 1
    fprintf( reac_txt_lin , '  Support reaction (%s) \n',ForceMagnitude)
  elseif Lenguage == 2
    fprintf( reac_txt_lin , ' Reacciones en apoyos (%s) \n',ForceMagnitude)
  end
  fprintf( reac_txt_lin , '------------------------%s \n',line2)
  fprintf( reac_txt_lin , '| %s |       Rx      %s| \n',NN,space2)
  fprintf( reac_txt_lin , '------------------------%s \n',line2)
  for i=1:NNodDiriCond,
    fprintf( reac_txt_lin , '| %4i | %12.2e %s| \n',ReadingDiriCondMat(i,1),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(1)),space2)
  end
  fprintf( reac_txt_lin , '------------------------%s \n\n\n',line2)
elseif NDFPN == 2
  fprintf( reac_txt_lin , '--------------------------------------%s \n',line2)
  if Lenguage == 1
    fprintf( reac_txt_lin , '           Support reaction (%s)         \n',ForceMagnitude)
  elseif Lenguage == 2
    fprintf( reac_txt_lin , '          Reacciones en apoyos (%s)         \n',ForceMagnitude)
  end
  fprintf( reac_txt_lin , '--------------------------------------%s \n',line2)
  fprintf( reac_txt_lin , '| %s |       Rx      |       Ry    %s| \n',NN,space2)
  fprintf( reac_txt_lin , '--------------------------------------%s \n',line2)
  for i=1:NNodDiriCond,
    fprintf( reac_txt_lin , '| %4i | %12.2e | %12.2e %s| \n',ReadingDiriCondMat(i,1),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(1)),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(2)),space2)
  end
  fprintf( reac_txt_lin , '--------------------------------------%s \n\n\n',line2)
elseif NDFPN == 3
  fprintf( reac_txt_lin , '-------------------------------------------------------%s \n',line2)
  if Lenguage == 1
    fprintf( reac_txt_lin , '                   Support reaction (%s)              \n',ForceMagnitude)
  elseif Lenguage == 2
    fprintf( reac_txt_lin , '                 Reacciones en apoyos (%s)              \n',ForceMagnitude)
  end
  fprintf( reac_txt_lin , '-------------------------------------------------------%s \n',line2)
  fprintf( reac_txt_lin , '| %s |       Rx      |       Ry      |       Rz     %s| \n',NN,space2)
  fprintf( reac_txt_lin , '-------------------------------------------------------%s \n',line2)
  for i=1:NNodDiriCond,
    fprintf( reac_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e %s| \n',ReadingDiriCondMat(i,1),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(1)),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(2)),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(3)),space2)
  end
  fprintf( reac_txt_lin , '-------------------------------------------------------%s \n\n\n',line2)
end


if NDFPN == 1
  if NNodRobiCond>0
		fprintf( reac_txt_lin , '-----------------------%s \n',line2)
		if Lenguage == 1
			fprintf( reac_txt_lin , '  Spring reaction (%s) \n',ForceMagnitude)
			fprintf( reac_txt_lin , '-----------------------%s \n',line2)
			fprintf( reac_txt_lin , '| %s |     SR_x     %s| \n',NN,space2)
		elseif Lenguage == 2
			fprintf( reac_txt_lin , ' Reacción resortes (%s) \n',ForceMagnitude)
			fprintf( reac_txt_lin , '-----------------------%s \n',line2)
			fprintf( reac_txt_lin , '| %s |     RR_x     %s| \n',NN,space2)
		end
		fprintf( reac_txt_lin , '-----------------------%s \n',line2)
		for i=1:NNodRobiCond,
				fprintf( reac_txt_lin , '| %4i | %12.2e %s| \n',RobiCondMat(i,1),-Ulineal(node2dof(RobiCondMat(i,1),3)(1))*RobiCondMat(i,2),space2)
		end
		fprintf( reac_txt_lin , '--------------------------------------%s \n\n\n',line2)
	end
elseif NDFPN == 2
  if NNodRobiCond>0
		fprintf( reac_txt_lin , '--------------------------------------%s \n',line2)
		if Lenguage == 1
			fprintf( reac_txt_lin , '           Spring reaction (%s)         \n',ForceMagnitude)
			fprintf( reac_txt_lin , '--------------------------------------%s \n',line2)
			fprintf( reac_txt_lin , '| %s |      SR_x     |     SR_y    %s| \n',NN,space2)
		elseif Lenguage == 2
			fprintf( reac_txt_lin , '         Reacción resortes (%s)         \n',ForceMagnitude)
			fprintf( reac_txt_lin , '--------------------------------------%s \n',line2)
			fprintf( reac_txt_lin , '| %s |      RR_x     |     RR_y    %s| \n',NN,space2)
		end
		fprintf( reac_txt_lin , '--------------------------------------%s \n',line2)
		for i=1:NNodRobiCond,
				fprintf( reac_txt_lin , '| %4i | %12.2e | %12.2e %s| \n',RobiCondMat(i,1),-Ulineal(node2dof(RobiCondMat(i,1),3)(1))*RobiCondMat(i,2),-Ulineal(node2dof(RobiCondMat(i,1),3)(2))*RobiCondMat(i,3),space2)
		end
		fprintf( reac_txt_lin , '--------------------------------------%s \n\n\n',line2)
	end
elseif NDFPN == 3
  if NNodRobiCond>0
		fprintf( reac_txt_lin , '------------------------------------------------------%s \n',line2)
		if Lenguage == 1
			fprintf( reac_txt_lin , '                   Spring reaction (%s)         \n',ForceMagnitude)
			fprintf( reac_txt_lin , '------------------------------------------------------%s \n',line2)
			fprintf( reac_txt_lin , '| %s |      SR_x     |      SR_y     |     SR_z    %s| \n',NN,space2)
		elseif Lenguage == 2
			fprintf( reac_txt_lin , '                  Reacción resortes (%s)         \n',ForceMagnitude)
			fprintf( reac_txt_lin , '------------------------------------------------------%s \n',line2)
			fprintf( reac_txt_lin , '| %s |      RR_x     |      RR_y     |     RR_z    %s| \n',NN,space2)
		end
		fprintf( reac_txt_lin , '------------------------------------------------------%s \n',line2)
		for i=1:NNodRobiCond,
				fprintf( reac_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e%s| \n',RobiCondMat(i,1),-Ulineal(node2dof(RobiCondMat(i,1),3)(1))*RobiCondMat(i,2),-Ulineal(node2dof(RobiCondMat(i,1),3)(2))*RobiCondMat(i,3),-Ulineal(node2dof(RobiCondMat(i,1),3)(3))*RobiCondMat(i,4),space2)
		end
		fprintf( reac_txt_lin , '------------------------------------------------------%s \n\n\n',line2)
	end
end


fclose(reac_txt_lin) ;
tiempo_reac_txt_lin = toc ;
tiempo_TXT = tiempo_TXT + tiempo_reac_txt_lin;
