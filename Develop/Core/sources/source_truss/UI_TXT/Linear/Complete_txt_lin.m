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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% TXT general lineal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ================== READING TABLES ======================================
%  
% Archivo en .TXT
NN = 'Nodo';
fprintf( complete_txt_lin , '================== Iniciando IETFEM_UI v%s ===========================\n\n\n',version)
fprintf( complete_txt_lin , '================== Solucion de elasticidad lineal ===========================\n\n\n',version)
fprintf( complete_txt_lin , 'Archivo de entrada: %s  ... \n\n', input_file )
%
% ================== Reading input file tables ===========================
%
fprintf( complete_txt_lin , 'Tiempo en resolver: %6.3f segundos\n\n', tiempo )
%
if SD_LD ~= 1
  fprintf( complete_txt_lin , 'Tipo de problema: Reticulados 3D grandes deformaciones y desplazamientos\n\n')
else
  fprintf( complete_txt_lin , 'Tipo de problema: Reticulados 3D pequeñas deformaciones y desplazamientos\n\n')
end
fprintf( complete_txt_lin , 'Magnitud de fuerza: %s \n\n' , ForceMagnitude)
fprintf( complete_txt_lin , 'Magnitud de longitud: %s \n\n',LengthMagnitude)
fprintf( complete_txt_lin , 'Número de grados de liertad por nodo: %i \n\n', NDFPN)
fprintf( complete_txt_lin , 'Número de nodos por elemento: %i \n\n', NNodPE)
fprintf( complete_txt_lin , 'Número de materiales: %i \n\n', NMats )
fprintf( complete_txt_lin , 'Número de secciones: %i \n\n', NSecs )
fprintf( complete_txt_lin , 'Número de nodos: %i \n\n', NNod)
fprintf( complete_txt_lin , 'Número de elementos: %i \n\n', NElem)


if NDFPN == 1
	fprintf( complete_txt_lin ,   '------------------------%s \n',line1)
  fprintf( complete_txt_lin , 'Coordenadas de los nodos (%s)  \n',LengthMagnitude)
	fprintf( complete_txt_lin , '------------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |         X     %s|\n',NN,space1)
	fprintf( complete_txt_lin , '------------------------%s \n',line1)
	for i=1:NNod,
		fprintf( complete_txt_lin , '| %4i |  %12.2e  %s|\n',i,NodCoordMat(i,1),space1)
	end
	fprintf( complete_txt_lin , '------------------------%s \n\n\n',line1)
elseif NDFPN == 2
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
  fprintf( complete_txt_lin , '       Coordenadas de los nodos (%s)         \n',LengthMagnitude)
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |        X       |        Y     %s|\n',NN,space1)
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
	for i=1:NNod,
		fprintf( complete_txt_lin , '| %4i |  %12.2e  | %12.2e %s|\n',i,NodCoordMat(i,1),NodCoordMat(i,2),space1)
	end
	fprintf( complete_txt_lin , '----------------------------------------%s \n\n\n',line1)
elseif NDFPN == 3
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
  fprintf( complete_txt_lin , '               Coordenadas de los nodos (%s)                 \n',LengthMagnitude)
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |        X      |        Y      |        Z      %s|\n',NN,space1)
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
	for i=1:NNod,
		fprintf( complete_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e  %s|\n',i,NodCoordMat(i,1),NodCoordMat(i,2),NodCoordMat(i,3),space1)
	end
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n\n\n',line1)
end

fprintf( complete_txt_lin , 'Inicial: Nodo inicial - Final: Nodo final.  \n\n')
fprintf( complete_txt_lin ,   '-------------------------------------------- \n')
fprintf( complete_txt_lin , '      Conectividad de los elementos         \n')
fprintf( complete_txt_lin , '-------------------------------------------- \n')
fprintf( complete_txt_lin , '| Elem |     Inicial     |      Final      |\n')
fprintf( complete_txt_lin , '-------------------------------------------- \n')
for i=1:NElem,
  fprintf( complete_txt_lin , '| %4i |  %12.2e   |  %12.2e   |\n',i,ConectMat(i,1),ConectMat(i,2))
end
fprintf( complete_txt_lin , '-------------------------------------------- \n\n\n')

fprintf( complete_txt_lin , '--------------------------------------------------------------------------------------------------------%s%s%s%s%s \n',line1,line1,line3,line3,line3)
fprintf( complete_txt_lin , '                              Propiedades de los elementos  \n')
fprintf( complete_txt_lin , '--------------------------------------------------------------------------------------------------------%s%s%s%s%s \n',line1,line1,line3,line3,line3)
fprintf( complete_txt_lin , '| Elemento |   Area (%s^2) |       L   (%s)  |   Youngs (%s/%s^2) |   alpha (1/°C) |   T (°C) | PP  (%s/%s^3) | \n',LengthMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude)
fprintf( complete_txt_lin , '--------------------------------------------------------------------------------------------------------%s%s%s%s%s \n',line1,line1,line3,line3,line3)
for i=1:NElem,
  fprintf( complete_txt_lin , '| %8i | %12.2e %s| %12.2e   %s|   %12.2e   %s|   %12.2e |  %6.2f  | %12.2e%s|\n',i,Areas(i),space1,Largos(i),space1,Youngs(i),space3,Alphas (i),Temp(i),Gammas (i),space3)
end
fprintf( complete_txt_lin , '--------------------------------------------------------------------------------------------------------%s%s%s%s%s \n\n\n',line1,line1,line3,line3,line3)




if NDFPN == 1
  if NNodNeumCond~=0
    fprintf( complete_txt_lin , '----------------------------%s \n',line2)
    fprintf( complete_txt_lin , '  Fuerzas externas puntuales      \n')
    fprintf( complete_txt_lin , '----------------------------%s \n',line2)
    fprintf( complete_txt_lin , '|   %s   |     F_x (%s)   |\n',NN,ForceMagnitude)
    fprintf( complete_txt_lin , '----------------------------%s \n',line2)
    for i=1:NNodNeumCond,
      fprintf( complete_txt_lin , '| %8i | %12.2e  %s|\n',NeumCondMat(i,1),NeumCondMat(i,2),space2)
    end
    fprintf( complete_txt_lin , '----------------------------%s \n\n\n',line2)
  end
  %
  if NEleVolCondDead~=0
    fprintf( complete_txt_lin , '-------------------------%s \n',line3)
    fprintf( complete_txt_lin , ' Fuerzas de volumen externas     \n')
    fprintf( complete_txt_lin , '-------------------------%s \n',line3)
    fprintf( complete_txt_lin , '| Elem |      b_x (%s/%s)    |\n',ForceMagnitude,LengthMagnitude)
    fprintf( complete_txt_lin , '-------------------------%s \n',line3)
    for i=1:NEleVolCondDead,
      fprintf( complete_txt_lin , '| %4i | %12.2e  %s|\n',auxVolCondMatDead(i,1),auxVolCondMatDead(i,2),space3)
    end
    fprintf( complete_txt_lin , '-------------------------%s \n\n\n',line3)
  end
  %
	if NNodRobiCond~=0
    fprintf( complete_txt_lin , '---------------------------%s%s \n',line2,line1)
    fprintf( complete_txt_lin , '          Resortes        \n')
    fprintf( complete_txt_lin , '---------------------------%s%s \n\n',line2,line1) 
		fprintf( complete_txt_lin , '|   %s   |    kx (%s/%s)   |\n',NN,ForceMagnitude,LengthMagnitude)
		fprintf( complete_txt_lin , '---------------------------%s%s \n',line2,line1)
		for i=1:NNodRobiCond,
			fprintf( complete_txt_lin , '| %8i | %12.2e  %s%s|\n',RobiCondMat(i,1),RobiCondMat(i,3),space2,space1)
		end
		fprintf( complete_txt_lin , '---------------------------%s%s \n\n\n',line2,line1) 
	end
elseif NDFPN == 2
  fprintf( complete_txt_lin , '--------------------------------------------%s%s \n',line2,line2)
  fprintf( complete_txt_lin , '        Fuerzas externas puntuales        \n')
  fprintf( complete_txt_lin , '--------------------------------------------%s%s \n',line2,line2)
	fprintf( complete_txt_lin , '|   %s   |     F_x (%s)   |     F_y (%s)   |\n',NN,ForceMagnitude,ForceMagnitude)
	fprintf( complete_txt_lin , '--------------------------------------------%s%s \n',line2,line2)
	for i=1:NNodNeumCond,
		fprintf( complete_txt_lin , '| %8i | %12.2e  %s| %12.2e  %s|\n',NeumCondMat(i,1),NeumCondMat(i,2),space2,NeumCondMat(i,3),space2)
	end
	fprintf( complete_txt_lin , '--------------------------------------------%s%s \n\n\n',line2,line2) 
  %
	if NEleVolCondDead~=0
    fprintf( complete_txt_lin , '-----------------------------------------%s%s \n',line3,line3)
    fprintf( complete_txt_lin , '         Fuerzas de volumen externas            \n')
    fprintf( complete_txt_lin , '-----------------------------------------%s%s \n',line3,line3)
		fprintf( complete_txt_lin , '| Elem |    kx (%s/%s)   |    ky (%s/%s)   |\n',ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude)
		fprintf( complete_txt_lin , '-----------------------------------------%s%s \n',line3,line3)
		for i=1:NEleVolCondDead,
			fprintf( complete_txt_lin , '| %4i | %12.2e  %s| %12.2e  %s|\n',auxVolCondMatDead(i,1),auxVolCondMatDead(i,2),space3,auxVolCondMatDead(i,3),space3)
		end
		fprintf( complete_txt_lin , '-----------------------------------------%s%s \n\n\n',line2,line1,line2,line1) 
	end
	%
	if NNodRobiCond~=0
    fprintf( complete_txt_lin , '---------------------------------------------%s%s%s%s \n',line2,line1,line2,line1)
    fprintf( complete_txt_lin , '                    Resortes                 \n')
    fprintf( complete_txt_lin , '---------------------------------------------%s%s%s%s \n',line2,line1,line2,line1)
		fprintf( complete_txt_lin , '|   %s   |    kx (%s/%s)   |    ky (%s/%s)   |\n',NN,ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude)
		fprintf( complete_txt_lin , '---------------------------------------------%s%s%s%s \n',line2,line1,line2,line1)
		for i=1:NNodRobiCond,
			fprintf( complete_txt_lin , '| %8i | %12.2e  %s%s| %12.2e  %s%s|\n',RobiCondMat(i,1),RobiCondMat(i,2),space2,space1,RobiCondMat(i,3),space2,space1)
		end
		fprintf( complete_txt_lin , '---------------------------------------------%s%s%s%s \n\n\n',line2,line1,line2,line1) 
	end
elseif NDFPN == 3
  fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s \n',line2,line2,line2) 
  fprintf( complete_txt_lin , '                 Fuerzas externas puntuales                 \n')
  fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s \n',line2,line2,line2) 
	fprintf( complete_txt_lin , '|   %s   |     F_x (%s)   |     F_y (%s)   |     F_z (%s)   |\n',NN,ForceMagnitude,ForceMagnitude,ForceMagnitude)
	fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s \n',line2,line2,line2)
	for i=1:NNodNeumCond,
		fprintf( complete_txt_lin , '| %8i | %12.2e  %s| %12.2e  %s| %12.2e  %s|\n',NeumCondMat(i,1),NeumCondMat(i,2),space2,NeumCondMat(i,3),space2,NeumCondMat(i,4),space2)
	end
	fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s \n\n\n',line2,line2,line2) 
	%
  if NEleVolCondDead~=0
    fprintf( complete_txt_lin , '--------------------------------------------------------%s%s%s%s%s%s \n',line2,line1,line2,line1,line2,line1) 
    fprintf( complete_txt_lin , '              Fuerzas de volumen externas                   \n')
    fprintf( complete_txt_lin , '--------------------------------------------------------%s%s%s%s%s%s \n',line2,line1,line2,line1,line2,line1) 
    fprintf( complete_txt_lin , '| Elem |   b_x (%s/%s)   |   b_x (%s/%s)   |   b_z (%s/%s)   |\n',ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude)
    fprintf( complete_txt_lin , '--------------------------------------------------------%s%s%s%s%s%s \n',line2,line1,line2,line1,line2,line1)
    for i=1:NEleVolCondDead,
      fprintf( complete_txt_lin , '| %4i | %12.2e  %s%s| %12.2e  %s%s| %12.2e  %s%s|\n',auxVolCondMatDead(i,1),auxVolCondMatDead(i,2),space2,space1,auxVolCondMatDead(i,3),space2,space1,auxVolCondMatDead(i,4),space2,space1)
    end
    fprintf( complete_txt_lin , '--------------------------------------------------------%s%s%s%s%s%s \n\n\n',line2,line1,line2,line1,line2,line1) 
	end
  %
	if NNodRobiCond~=0
    fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s%s%s%s \n',line2,line1,line2,line1,line2,line1) 
    fprintf( complete_txt_lin , '                         Resortes                          \n')
    fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s%s%s%s \n',line2,line1,line2,line1,line2,line1) 
    fprintf( complete_txt_lin , '|   %s   |    kx (%s/%s)   |    ky (%s/%s)   |    kz (%s/%s)   |\n',NN,ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude)
    fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s%s%s%s \n',line2,line1,line2,line1,line2,line1)
    for i=1:NNodRobiCond,
      fprintf( complete_txt_lin , '| %8i | %12.2e  %s%s| %12.2e  %s%s| %12.2e  %s%s|\n',RobiCondMat(i,1),RobiCondMat(i,2),space2,space1,RobiCondMat(i,3),space2,space1,RobiCondMat(i,4),space2,space1)
    end
    fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s%s%s%s \n\n\n',line2,line1,line2,line1,line2,line1) 
	end
end



if size(Klineal_total,1) <= 100
	% ================== GLOBAL STIFFNESS MATRIX =============================
  fprintf( complete_txt_lin , '\n\n Matriz de Rigidez Global (%s/%s) \n',ForceMagnitude,LengthMagnitude)
	for j=1:NDFPN*NNod
		if j<NDFPN*NNod
			fprintf( complete_txt_lin , '-------------')
		else
			fprintf( complete_txt_lin , '-------------\n')
		end
	end

	KK = Klineal_total;
	if NDFPN == 2
		aa = [3:3:3*NNod];
		KK(:,aa) = [];
		KK(aa,:) = [];
	end
	if NDFPN == 1
		aa = [3:3:3*NNod];
		bb = [2:3:3*NNod];
		KK(:,[aa,bb]) = [];
		KK([aa,bb],:) = [];
	end

	for i=1:NDFPN*NNod
		for j=1:NDFPN*NNod
			if j<NDFPN*NNod
				fprintf( complete_txt_lin , '%12.2e ', KK(i,j))
			else
				fprintf( complete_txt_lin , '%12.2e \n', KK(i,j))
			end
		end
	end

	for j=1:NDFPN*NNod
		if j<NDFPN*NNod
			fprintf( complete_txt_lin , '-------------')
		else
			fprintf( complete_txt_lin , '-------------\n\n\n')
		end
	end
else
  fprintf( complete_txt_lin , '\n\n La Matriz de Rigidez Global no se muestra porque es mayor que 100x100 \n\n\n')
end


if size(Klineal_reducida,1) <= 100
  fprintf( complete_txt_lin , '\n\n Matriz Reducida (%s/%s)\n',ForceMagnitude,LengthMagnitude)

	for j=1:length(NeumDF)
		if j<length(NeumDF)
			fprintf( complete_txt_lin , '-------------')
		else
			fprintf( complete_txt_lin , '-------------\n')
		end
	end

	for i=1:length(NeumDF)
		for j=1:length(NeumDF)
			if j<length(NeumDF)
				fprintf( complete_txt_lin , '%12.2e ', Klineal_reducida(i,j))
			else
				fprintf( complete_txt_lin , '%12.2e \n', Klineal_reducida(i,j))
			end
		end
	end

	for j=1:length(NeumDF)
		if j<length(NeumDF)
			fprintf( complete_txt_lin , '-------------')
		else
			fprintf( complete_txt_lin , '-------------\n\n\n')
		end
	end
else
  fprintf( complete_txt_lin , '\n\n La Matriz de Rigidez Reducida no se muestra porque es mayor que 100x100 \n\n\n')
end

fprintf( complete_txt_lin , '-----------------------%s \n',line1)
fprintf( complete_txt_lin , '   Largo final (%s)  \n',LengthMagnitude)
fprintf( complete_txt_lin , '-----------------------%s \n',line1)
fprintf( complete_txt_lin , '| Elem |        l     %s|\n',space1)
fprintf( complete_txt_lin , '-----------------------%s \n',line1)
for i=1:NElem,
  fprintf( complete_txt_lin , '| %4i | %12.2e %s|\n',i,largos_lineal(i),space1)
end
fprintf( complete_txt_lin , '-----------------------%s \n\n\n',line1)


if NDFPN == 1
  fprintf( complete_txt_lin , '------------------------%s \n',line2)
  fprintf( complete_txt_lin , ' Reacciones en apoyos (%s) \n',ForceMagnitude)
  fprintf( complete_txt_lin , '------------------------%s \n',line2)
  fprintf( complete_txt_lin , '| %s |       Rx      %s| \n',NN,space2)
  fprintf( complete_txt_lin , '------------------------%s \n',line2)
  for i=1:NNodDiriCond,
	aux = node2dof(ReadingDiriCondMat(i,1),3);
    fprintf( complete_txt_lin , '| %4i | %12.2e %s| \n',ReadingDiriCondMat(i,1),R_lineal(aux(1)),space2)
  end
  fprintf( complete_txt_lin , '------------------------%s \n\n\n',line2)
elseif NDFPN == 2
  fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
  fprintf( complete_txt_lin , '          Reacciones en apoyos (%s)         \n',ForceMagnitude)
  fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
  fprintf( complete_txt_lin , '| %s |       Rx      |       Ry    %s| \n',NN,space2)
  fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
  for i=1:NNodDiriCond,
	aux = node2dof(ReadingDiriCondMat(i,1),3);
    fprintf( complete_txt_lin , '| %4i | %12.2e | %12.2e %s| \n',ReadingDiriCondMat(i,1),R_lineal(aux(1)),R_lineal(aux(2)),space2)
  end
  fprintf( complete_txt_lin , '--------------------------------------%s \n\n\n',line2)
elseif NDFPN == 3
  fprintf( complete_txt_lin , '-------------------------------------------------------%s \n',line2)
  fprintf( complete_txt_lin , '                 Reacciones en apoyos (%s)              \n',ForceMagnitude)
  fprintf( complete_txt_lin , '-------------------------------------------------------%s \n',line2)
  fprintf( complete_txt_lin , '| %s |       Rx      |       Ry      |       Rz     %s| \n',NN,space2)
  fprintf( complete_txt_lin , '-------------------------------------------------------%s \n',line2)
  for i=1:NNodDiriCond,
	aux = node2dof(ReadingDiriCondMat(i,1),3);
    fprintf( complete_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e %s| \n',ReadingDiriCondMat(i,1),R_lineal(aux(1)),R_lineal(aux(2)),R_lineal(aux(3)),space2)
  end
  fprintf( complete_txt_lin , '-------------------------------------------------------%s \n\n\n',line2)
end


if NDFPN == 1
  if NNodRobiCond>0
	fprintf( complete_txt_lin , '-----------------------%s \n',line2)
    fprintf( complete_txt_lin , ' Reacción resortes (%s) \n',ForceMagnitude)
    fprintf( complete_txt_lin , '-----------------------%s \n',line2)
    fprintf( complete_txt_lin , '| %s |     RR_x     %s| \n',NN,space2)
	fprintf( complete_txt_lin , '-----------------------%s \n',line2)
	for i=1:NNodRobiCond,
		aux = node2dof(RobiCondMat(i,1),3);
		fprintf( complete_txt_lin , '| %4i | %12.2e %s| \n',RobiCondMat(i,1),-Ulineal(aux(1))*RobiCondMat(i,2),space2)
	end
	fprintf( complete_txt_lin , '--------------------------------------%s \n\n\n',line2)
	end
elseif NDFPN == 2
  if NNodRobiCond>0
	fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
    fprintf( complete_txt_lin , '         Reacción resortes (%s)         \n',ForceMagnitude)
    fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
    fprintf( complete_txt_lin , '| %s |      RR_x     |     RR_y    %s| \n',NN,space2)
	fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
	for i=1:NNodRobiCond,
		aux = node2dof(RobiCondMat(i,1),3);
		fprintf( complete_txt_lin , '| %4i | %12.2e | %12.2e %s| \n',RobiCondMat(i,1),-Ulineal(aux(1))*RobiCondMat(i,2),-Ulineal(aux(2))*RobiCondMat(i,3),space2)
	end
	fprintf( complete_txt_lin , '--------------------------------------%s \n\n\n',line2)
	end
elseif NDFPN == 3
  if NNodRobiCond>0
		fprintf( complete_txt_lin , '------------------------------------------------------%s \n',line2)
    fprintf( complete_txt_lin , '                  Reacción resortes (%s)         \n',ForceMagnitude)
    fprintf( complete_txt_lin , '------------------------------------------------------%s \n',line2)
    fprintf( complete_txt_lin , '| %s |      RR_x     |      RR_y     |     RR_z    %s| \n',NN,space2)
	fprintf( complete_txt_lin , '------------------------------------------------------%s \n',line2)
	for i=1:NNodRobiCond,
		aux = node2dof(RobiCondMat(i,1),3);
		fprintf( complete_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e%s| \n',RobiCondMat(i,1),-Ulineal(aux(1))*RobiCondMat(i,2),-Ulineal(aux(2))*RobiCondMat(i,3),-Ulineal(aux(3))*RobiCondMat(i,4),space2)
	end
	fprintf( complete_txt_lin , '------------------------------------------------------%s \n\n\n',line2)
	end
end


if NDFPN == 1
	fprintf( complete_txt_lin , '----------------------%s \n',line1)
  fprintf( complete_txt_lin , 'Desplazamientos (%s)  \n',LengthMagnitude)
	fprintf( complete_txt_lin , '----------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |       u_x   %s|\n',NN,space1)
	fprintf( complete_txt_lin , '----------------------%s \n',line1)
	for i=1:NNod,
		aux = node2dof(i,3);
		fprintf( complete_txt_lin , '| %4i | %12.2e %s|\n',i,Ulineal(aux(1)),space1)
	end
	fprintf( complete_txt_lin , '----------------------%s \n\n\n',line1)
elseif NDFPN == 2
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
  fprintf( complete_txt_lin , '           Desplazamientos (%s)         \n',LengthMagnitude)
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |       u_x      |        u_y   %s|\n',NN,space1)
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
	for i=1:NNod,
		aux = node2dof(i,3);
		fprintf( complete_txt_lin , '| %4i |  %12.2e  | %12.2e %s|\n',i,Ulineal(aux(1)),Ulineal(aux(2)),space1)
	end
	fprintf( complete_txt_lin , '----------------------------------------%s \n\n\n',line1)
elseif NDFPN == 3
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
  fprintf( complete_txt_lin , '                   Desplazamientos (%s)                 \n',LengthMagnitude)
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |       u_x     |       u_y     |       u_z     %s|\n',NN,space1)
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
	for i=1:NNod,
		aux = node2dof(i,3);
		fprintf( complete_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e  %s|\n',i,Ulineal(aux(1)),Ulineal(aux(2)),Ulineal(aux(3)),space1)
	end
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n\n\n',line1)
end


fprintf( complete_txt_lin ,   '---------------------------------%s \n',line2)
fprintf( complete_txt_lin , '| Elemento |  Fuerza Axial (%s)  | \n',ForceMagnitude)
fprintf( complete_txt_lin ,   '---------------------------------%s \n',line2)
for i=1:NElem,
	fprintf( complete_txt_lin , '| %8i |     %12.2e   %s| \n',i,N_lineal(i),space2)
end
fprintf( complete_txt_lin ,   '---------------------------------%s \n\n\n',line2)



fprintf( complete_txt_lin , 'Sigma_lin = N_lin/A  \n\n')


fprintf( complete_txt_lin , '------------------------%s \n',line3)
fprintf( complete_txt_lin , ' Tensiones (%s/%s^2)              \n',ForceMagnitude,LengthMagnitude)
fprintf( complete_txt_lin , '------------------------%s \n',line3)
fprintf( complete_txt_lin , '| Elem |    Sigma_lin  %s| \n',space3)
fprintf( complete_txt_lin , '------------------------%s \n',line3)
for i=1:NElem,
	fprintf( complete_txt_lin , '| %4i | %12.2e  %s|\n',i,Sigma_lin(i),space3)
end
fprintf( complete_txt_lin , '------------------------%s \n\n\n',line3)




fprintf( complete_txt_lin ,   '---------------------------------- \n')
fprintf( complete_txt_lin , '| Elemento |     Deformación     | \n')
fprintf( complete_txt_lin ,   '---------------------------------- \n')
for i=1:NElem,
	fprintf( complete_txt_lin , '| %8i |    %12.2e     | \n',i,EPS_lineal(i))
end
fprintf( complete_txt_lin ,   '---------------------------------- \n')


fclose(complete_txt_lin) ;


