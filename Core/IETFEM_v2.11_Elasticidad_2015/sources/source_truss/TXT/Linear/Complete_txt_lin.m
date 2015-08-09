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
%%%%%%%%%%%%%%%%%%%%%%%%% TXT general lineal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% ================== READING TABLES ======================================
%  
% Archivo en .TXT
if Lenguage == 1
	NN = "Node";
	fprintf( complete_txt_lin , '================== General Output IETFEM v%s ===========================\n\n\n',version)
  fprintf( complete_txt_lin , '================== Linear elasticity solution ===========================\n\n\n',version)
	fprintf( complete_txt_lin , 'Inputfile: %s  ... \n\n', input_file )
	%
	% ================== Reading input file tables ===========================
	%
	fprintf( complete_txt_lin , 'Solve time: %6.3f seconds\n\n', tiempo )
	%
  if SD_LD ~= 1
    fprintf( complete_txt_lin , 'Problem type: %s %sD large deformation and displacement\n\n',KP,Dim)
  else
    fprintf( complete_txt_lin , 'Problem type: %s %sD small deformation and displacement\n\n',KP,Dim)
  end	 
	fprintf( complete_txt_lin , 'Force magnitude: %s \n\n' , ForceMagnitude)
	fprintf( complete_txt_lin , 'Length magnitude: %s \n\n',LengthMagnitude)
	fprintf( complete_txt_lin , 'Number of degrees of freedom per node: %i \n\n', NDFPN)
	fprintf( complete_txt_lin , 'Number of nodes per element: %i \n\n', NNodPE)
	fprintf( complete_txt_lin , 'Number of materials: %i \n\n', NMats )
	fprintf( complete_txt_lin , 'Number of sections: %i \n\n', NSecs )
	fprintf( complete_txt_lin , 'Number of nodes: %i \n\n', NNod)
	fprintf( complete_txt_lin , 'Number of elements: %i \n\n', NElem)
	fprintf( complete_txt_lin , 'Scale Factors\n')
	fprintf( complete_txt_lin , 'SD_Deformed: %6.2f \n', ScaleFactor(1))
	fprintf( complete_txt_lin , '   Supports: %6.2f \n', ScaleFactor(2))
	fprintf( complete_txt_lin , '      Areas: %6.2f \n', ScaleFactor(3))
	fprintf( complete_txt_lin , '     Forces: %6.2f \n', ScaleFactor(4))
	fprintf( complete_txt_lin , '      Frame: %6.2f \n', ScaleFactor(5))
	fprintf( complete_txt_lin , '    Numbers: %6.2f \n\n', ScaleFactor(6))
elseif Lenguage == 2
	NN = "Nodo";
	fprintf( complete_txt_lin , '================== Iniciando IETFEM v%s ===========================\n\n\n',version)
  fprintf( complete_txt_lin , '================== Solucion de elasticidad lineal ===========================\n\n\n',version)
	fprintf( complete_txt_lin , 'Archivo de entrada: %s  ... \n\n', input_file )
	%
	% ================== Reading input file tables ===========================
	%
	fprintf( complete_txt_lin , 'Tiempo en resolver: %6.3f segundos\n\n', tiempo )
	%
	if SD_LD ~= 1
    fprintf( complete_txt_lin , 'Tipo de problema: %s %sD grandes deformaciones y desplazamientos\n\n',KP,Dim)
  else
    fprintf( complete_txt_lin , 'Tipo de problema: %s %sD pequeñas deformaciones y desplazamientos\n\n',KP,Dim)
  end
	fprintf( complete_txt_lin , 'Magnitud de fuerza: %s \n\n' , ForceMagnitude)
	fprintf( complete_txt_lin , 'Magnitud de longitud: %s \n\n',LengthMagnitude)
	fprintf( complete_txt_lin , 'Número de grados de liertad por nodo: %i \n\n', NDFPN)
	fprintf( complete_txt_lin , 'Número de nodos por elemento: %i \n\n', NNodPE)
	fprintf( complete_txt_lin , 'Número de materiales: %i \n\n', NMats )
	fprintf( complete_txt_lin , 'Número de secciones: %i \n\n', NSecs )
	fprintf( complete_txt_lin , 'Número de nodos: %i \n\n', NNod)
	fprintf( complete_txt_lin , 'Número de elementos: %i \n\n', NElem)
	fprintf( complete_txt_lin , 'Factores de escala\n')
	fprintf( complete_txt_lin , 'PD_Deformada: %6.2f \n', ScaleFactor(1))
	fprintf( complete_txt_lin , '      Apoyos: %6.2f \n', ScaleFactor(2))
	fprintf( complete_txt_lin , '       Áreas: %6.2f \n', ScaleFactor(3))
	fprintf( complete_txt_lin , '     Fuerzas: %6.2f \n', ScaleFactor(4))
	fprintf( complete_txt_lin , '      Cuadro: %6.2f \n', ScaleFactor(5))
	fprintf( complete_txt_lin , '     Numeros: %6.2f \n\n', ScaleFactor(6))
end


if NDFPN == 1
	fprintf( complete_txt_lin ,   '------------------------%s \n',line1)
	if Lenguage == 1
		fprintf( complete_txt_lin , '  Nodes Cordinates (%s)  \n',LengthMagnitude)
	elseif Lenguage == 2
		fprintf( complete_txt_lin , 'Coordenadas de los nodos (%s)  \n',LengthMagnitude)
	end
	fprintf( complete_txt_lin , '------------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |         X     %s|\n',NN,space1)
	fprintf( complete_txt_lin , '------------------------%s \n',line1)
	for i=1:NNod,
		fprintf( complete_txt_lin , '| %4i |  %12.2e  %s|\n',i,NodCoordMat(i,1),space1)
	end
	fprintf( complete_txt_lin , '------------------------%s \n\n\n',line1)
elseif NDFPN == 2
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
	if Lenguage == 1
		fprintf( complete_txt_lin , '           Nodes Cordinates (%s)         \n',LengthMagnitude)
	elseif Lenguage == 2
		fprintf( complete_txt_lin , '       Coordenadas de los nodos (%s)         \n',LengthMagnitude)
	end
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |        X       |        Y     %s|\n',NN,space1)
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
	for i=1:NNod,
		fprintf( complete_txt_lin , '| %4i |  %12.2e  | %12.2e %s|\n',i,NodCoordMat(i,1),NodCoordMat(i,2),space1)
	end
	fprintf( complete_txt_lin , '----------------------------------------%s \n\n\n',line1)
elseif NDFPN == 3
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
	if Lenguage == 1
		fprintf( complete_txt_lin , '                   Nodes Cordinates (%s)                 \n',LengthMagnitude)
	elseif Lenguage == 2
		fprintf( complete_txt_lin , '               Coordenadas de los nodos (%s)                 \n',LengthMagnitude)
	end
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |        X      |        Y      |        Z      %s|\n',NN,space1)
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
	for i=1:NNod,
		fprintf( complete_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e  %s|\n',i,NodCoordMat(i,1),NodCoordMat(i,2),NodCoordMat(i,3),space1)
	end
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n\n\n',line1)
end

if Lenguage == 1
  fprintf( complete_txt_lin , 'Start: Start Node - End: End Node.  \n\n')
elseif Lenguage == 2
  fprintf( complete_txt_lin , 'Inicial: Nodo inicial - Final: Nodo final.  \n\n')
end
fprintf( complete_txt_lin ,   '-------------------------------------------- \n')
if Lenguage == 1
  fprintf( complete_txt_lin , '           Element conectivity         \n')
  fprintf( complete_txt_lin , '-------------------------------------------- \n')
  fprintf( complete_txt_lin , '| Elem |      Start      |       End       |\n')
elseif Lenguage == 2 
  fprintf( complete_txt_lin , '      Conectividad de los elementos         \n')
  fprintf( complete_txt_lin , '-------------------------------------------- \n')
  fprintf( complete_txt_lin , '| Elem |     Inicial     |      Final      |\n')
end
fprintf( complete_txt_lin , '-------------------------------------------- \n')
for i=1:NElem,
  fprintf( complete_txt_lin , '| %4i |  %12.2e   |  %12.2e   |\n',i,ConectMat(i,1),ConectMat(i,2))
end
fprintf( complete_txt_lin , '-------------------------------------------- \n\n\n')

fprintf( complete_txt_lin , 
'--------------------------------------------------------------------------------------------------------%s%s%s%s%s \n',line1,line1,line3,line3,line3)
if Lenguage == 1
	fprintf( complete_txt_lin , "                                  Element's properties  \n")
elseif Lenguage == 2
	fprintf( complete_txt_lin , "                              Propiedades de los elementos  \n")
end
fprintf( complete_txt_lin , 
'--------------------------------------------------------------------------------------------------------%s%s%s%s%s \n',line1,line1,line3,line3,line3)
if Lenguage == 1
  fprintf( complete_txt_lin , '|  Element |   Area (%s^2) |       L   (%s)  |   Youngs (%s/%s^2) |   alpha (1/°C) |   T (°C) | GL  (%s/%s^3) | \n',LengthMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude)
elseif Lenguage == 2
  fprintf( complete_txt_lin , '| Elemento |   Area (%s^2) |       L   (%s)  |   Youngs (%s/%s^2) |   alpha (1/°C) |   T (°C) | PP  (%s/%s^3) | \n',LengthMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude)
end
fprintf( complete_txt_lin , 
'--------------------------------------------------------------------------------------------------------%s%s%s%s%s \n',line1,line1,line3,line3,line3)
for i=1:NElem,
  fprintf( complete_txt_lin , '| %8i | %12.2e %s| %12.2e   %s|   %12.2e   %s|   %12.2e |  %6.2f  | %12.2e%s|\n',i,Areas(i),space1,Largos(i),space1,Youngs(i),space3,Alphas (i),Temp(i),Gammas (i),space3)
end
fprintf( complete_txt_lin , 
'--------------------------------------------------------------------------------------------------------%s%s%s%s%s \n\n\n',line1,line1,line3,line3,line3)




if NDFPN == 1
  if NNodNeumCond~=0
    fprintf( complete_txt_lin , '----------------------------%s \n',line2)
    if Lenguage == 1
      fprintf( complete_txt_lin , '  Puntual external  forces      \n')
    elseif Lenguage == 2
      fprintf( complete_txt_lin , '  Fuerzas externas puntuales      \n')
    end
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
    if Lenguage == 1
      fprintf( complete_txt_lin , ' Volume external forces      \n')
    elseif Lenguage == 2
      fprintf( complete_txt_lin , ' Fuerzas de volumen externas     \n')
    end
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
		if Lenguage == 1
			fprintf( complete_txt_lin , '          Springs        \n')
		elseif Lenguage == 2
			fprintf( complete_txt_lin , '          Resortes        \n')
		end
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
	if Lenguage == 1
		fprintf( complete_txt_lin , '         Puntual external  forces          \n')
	elseif Lenguage == 2
		fprintf( complete_txt_lin , '        Fuerzas externas puntuales        \n')
	end
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
		if Lenguage == 1
			fprintf( complete_txt_lin , '          Volume external forces            \n')
		elseif Lenguage == 2
			fprintf( complete_txt_lin , '         Fuerzas de volumen externas            \n')
		end
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
		if Lenguage == 1
			fprintf( complete_txt_lin , '                    Springs                  \n')
		elseif Lenguage == 2
			fprintf( complete_txt_lin , '                    Resortes                 \n')
		end
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
	if Lenguage == 1
		fprintf( complete_txt_lin , '                 Puntual external  forces                    \n')
	elseif Lenguage == 2
		fprintf( complete_txt_lin , '                 Fuerzas externas puntuales                 \n')
	end
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
		if Lenguage == 1
			fprintf( complete_txt_lin , '                Volume external forces                     \n')
		elseif Lenguage == 2
			fprintf( complete_txt_lin , '              Fuerzas de volumen externas                   \n')
		end
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
		if Lenguage == 1
			fprintf( complete_txt_lin , '                         Springs                            \n')
		elseif Lenguage == 2
			fprintf( complete_txt_lin , '                         Resortes                          \n')
		end
    fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s%s%s%s \n',line2,line1,line2,line1,line2,line1) 
    fprintf( complete_txt_lin , '|   %s   |    kx (%s/%s)   |    ky (%s/%s)   |    kz (%s/%s)   |\n',NN,ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude,ForceMagnitude,LengthMagnitude)
    fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s%s%s%s \n',line2,line1,line2,line1,line2,line1)
    for i=1:NNodRobiCond,
      fprintf( complete_txt_lin , '| %8i | %12.2e  %s%s| %12.2e  %s%s| %12.2e  %s%s|\n',RobiCondMat(i,1),RobiCondMat(i,2),space2,space1,RobiCondMat(i,3),space2,space1,RobiCondMat(i,4),space2,space1)
    end
    fprintf( complete_txt_lin , '------------------------------------------------------------%s%s%s%s%s%s \n\n\n',line2,line1,line2,line1,line2,line1) 
	end
end



if size(Klineal_total)(1) <= 100
	% ================== GLOBAL STIFFNESS MATRIX =============================
	if Lenguage == 1
		fprintf( complete_txt_lin , '\n\n Global Siffness Matrix (%s/%s) \n',ForceMagnitude,LengthMagnitude)
	elseif Lenguage == 2
		fprintf( complete_txt_lin , '\n\n Matriz de Rigidez Global (%s/%s) \n',ForceMagnitude,LengthMagnitude)
	end
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
	if Lenguage == 1
		fprintf( complete_txt_lin , '\n\n The Global Siffness Matrix is not show because its bigger than 100x100 \n\n\n')
	elseif Lenguage == 2
		fprintf( complete_txt_lin , '\n\n La Matriz de Rigidez Global no se muestra porque es mayor que 100x100 \n\n\n')
	end
end


if size(Klineal_reducida)(1) <= 100
	if Lenguage == 1
		fprintf( complete_txt_lin , '\n\n Reduced Matrix (%s/%s)\n',ForceMagnitude,LengthMagnitude)
	elseif Lenguage == 2
		fprintf( complete_txt_lin , '\n\n Matriz Reducida (%s/%s)\n',ForceMagnitude,LengthMagnitude)
	end

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
	if Lenguage == 1
		fprintf( complete_txt_lin , '\n\n The Reduce Siffness Matrix is not show because its bigger than 100x100 \n\n\n')
	elseif Lenguage == 2
		fprintf( complete_txt_lin , '\n\n La Matriz de Rigidez Reducida no se muestra porque es mayor que 100x100 \n\n\n')
	end
end

fprintf( complete_txt_lin , '-----------------------%s \n',line1)
if Lenguage == 1
  fprintf( complete_txt_lin , '   Final length (%s)  \n',LengthMagnitude)
elseif Lenguage == 2
  fprintf( complete_txt_lin , '   Largo final (%s)  \n',LengthMagnitude)
end
fprintf( complete_txt_lin , '-----------------------%s \n',line1)
fprintf( complete_txt_lin , '| Elem |        l     %s|\n',space1)
fprintf( complete_txt_lin , '-----------------------%s \n',line1)
for i=1:NElem,
  fprintf( complete_txt_lin , '| %4i | %12.2e %s|\n',i,largos_lineal(i),space1)
end
fprintf( complete_txt_lin , '-----------------------%s \n\n\n',line1)


if NDFPN == 1
  fprintf( complete_txt_lin , '------------------------%s \n',line2)
  if Lenguage == 1
    fprintf( complete_txt_lin , '  Support reaction (%s) \n',ForceMagnitude)
  elseif Lenguage == 2
    fprintf( complete_txt_lin , ' Reacciones en apoyos (%s) \n',ForceMagnitude)
  end
  fprintf( complete_txt_lin , '------------------------%s \n',line2)
  fprintf( complete_txt_lin , '| %s |       Rx      %s| \n',NN,space2)
  fprintf( complete_txt_lin , '------------------------%s \n',line2)
  for i=1:NNodDiriCond,
    fprintf( complete_txt_lin , '| %4i | %12.2e %s| \n',ReadingDiriCondMat(i,1),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(1)),space2)
  end
  fprintf( complete_txt_lin , '------------------------%s \n\n\n',line2)
elseif NDFPN == 2
  fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
  if Lenguage == 1
    fprintf( complete_txt_lin , '           Support reaction (%s)         \n',ForceMagnitude)
  elseif Lenguage == 2
    fprintf( complete_txt_lin , '          Reacciones en apoyos (%s)         \n',ForceMagnitude)
  end
  fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
  fprintf( complete_txt_lin , '| %s |       Rx      |       Ry    %s| \n',NN,space2)
  fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
  for i=1:NNodDiriCond,
    fprintf( complete_txt_lin , '| %4i | %12.2e | %12.2e %s| \n',ReadingDiriCondMat(i,1),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(1)),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(2)),space2)
  end
  fprintf( complete_txt_lin , '--------------------------------------%s \n\n\n',line2)
elseif NDFPN == 3
  fprintf( complete_txt_lin , '-------------------------------------------------------%s \n',line2)
  if Lenguage == 1
    fprintf( complete_txt_lin , '                   Support reaction (%s)              \n',ForceMagnitude)
  elseif Lenguage == 2
    fprintf( complete_txt_lin , '                 Reacciones en apoyos (%s)              \n',ForceMagnitude)
  end
  fprintf( complete_txt_lin , '-------------------------------------------------------%s \n',line2)
  fprintf( complete_txt_lin , '| %s |       Rx      |       Ry      |       Rz     %s| \n',NN,space2)
  fprintf( complete_txt_lin , '-------------------------------------------------------%s \n',line2)
  for i=1:NNodDiriCond,
    fprintf( complete_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e %s| \n',ReadingDiriCondMat(i,1),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(1)),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(2)),R_lineal(node2dof(ReadingDiriCondMat(i,1),3)(3)),space2)
  end
  fprintf( complete_txt_lin , '-------------------------------------------------------%s \n\n\n',line2)
end


if NDFPN == 1
  if NNodRobiCond>0
		fprintf( complete_txt_lin , '-----------------------%s \n',line2)
		if Lenguage == 1
			fprintf( complete_txt_lin , '  Spring reaction (%s) \n',ForceMagnitude)
			fprintf( complete_txt_lin , '-----------------------%s \n',line2)
			fprintf( complete_txt_lin , '| %s |     SR_x     %s| \n',NN,space2)
		elseif Lenguage == 2
			fprintf( complete_txt_lin , ' Reacción resortes (%s) \n',ForceMagnitude)
			fprintf( complete_txt_lin , '-----------------------%s \n',line2)
			fprintf( complete_txt_lin , '| %s |     RR_x     %s| \n',NN,space2)
		end
		fprintf( complete_txt_lin , '-----------------------%s \n',line2)
		for i=1:NNodRobiCond,
				fprintf( complete_txt_lin , '| %4i | %12.2e %s| \n',RobiCondMat(i,1),-Ulineal(node2dof(RobiCondMat(i,1),3)(1))*RobiCondMat(i,2),space2)
		end
		fprintf( complete_txt_lin , '--------------------------------------%s \n\n\n',line2)
	end
elseif NDFPN == 2
  if NNodRobiCond>0
		fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
		if Lenguage == 1
			fprintf( complete_txt_lin , '           Spring reaction (%s)         \n',ForceMagnitude)
			fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
			fprintf( complete_txt_lin , '| %s |      SR_x     |     SR_y    %s| \n',NN,space2)
		elseif Lenguage == 2
			fprintf( complete_txt_lin , '         Reacción resortes (%s)         \n',ForceMagnitude)
			fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
			fprintf( complete_txt_lin , '| %s |      RR_x     |     RR_y    %s| \n',NN,space2)
		end
		fprintf( complete_txt_lin , '--------------------------------------%s \n',line2)
		for i=1:NNodRobiCond,
				fprintf( complete_txt_lin , '| %4i | %12.2e | %12.2e %s| \n',RobiCondMat(i,1),-Ulineal(node2dof(RobiCondMat(i,1),3)(1))*RobiCondMat(i,2),-Ulineal(node2dof(RobiCondMat(i,1),3)(2))*RobiCondMat(i,3),space2)
		end
		fprintf( complete_txt_lin , '--------------------------------------%s \n\n\n',line2)
	end
elseif NDFPN == 3
  if NNodRobiCond>0
		fprintf( complete_txt_lin , '------------------------------------------------------%s \n',line2)
		if Lenguage == 1
			fprintf( complete_txt_lin , '                   Spring reaction (%s)         \n',ForceMagnitude)
			fprintf( complete_txt_lin , '------------------------------------------------------%s \n',line2)
			fprintf( complete_txt_lin , '| %s |      SR_x     |      SR_y     |     SR_z    %s| \n',NN,space2)
		elseif Lenguage == 2
			fprintf( complete_txt_lin , '                  Reacción resortes (%s)         \n',ForceMagnitude)
			fprintf( complete_txt_lin , '------------------------------------------------------%s \n',line2)
			fprintf( complete_txt_lin , '| %s |      RR_x     |      RR_y     |     RR_z    %s| \n',NN,space2)
		end
		fprintf( complete_txt_lin , '------------------------------------------------------%s \n',line2)
		for i=1:NNodRobiCond,
				fprintf( complete_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e%s| \n',RobiCondMat(i,1),-Ulineal(node2dof(RobiCondMat(i,1),3)(1))*RobiCondMat(i,2),-Ulineal(node2dof(RobiCondMat(i,1),3)(2))*RobiCondMat(i,3),-Ulineal(node2dof(RobiCondMat(i,1),3)(3))*RobiCondMat(i,4),space2)
		end
		fprintf( complete_txt_lin , '------------------------------------------------------%s \n\n\n',line2)
	end
end


if NDFPN == 1
	fprintf( complete_txt_lin , '----------------------%s \n',line1)
	if Lenguage == 1
		fprintf( complete_txt_lin , '  Displacements (%s)  \n',LengthMagnitude)
	elseif Lenguage == 2
		fprintf( complete_txt_lin , 'Desplazamientos (%s)  \n',LengthMagnitude)
	end
	fprintf( complete_txt_lin , '----------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |       u_x   %s|\n',NN,space1)
	fprintf( complete_txt_lin , '----------------------%s \n',line1)
	for i=1:NNod,
		fprintf( complete_txt_lin , '| %4i | %12.2e %s|\n',i,Ulineal(node2dof(i,3)(1)),space1)
	end
	fprintf( complete_txt_lin , '----------------------%s \n\n\n',line1)
elseif NDFPN == 2
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
	if Lenguage == 1
		fprintf( complete_txt_lin , '           Displacements (%s)         \n',LengthMagnitude)
	elseif Lenguage == 2
		fprintf( complete_txt_lin , '           Desplazamientos (%s)         \n',LengthMagnitude)
	end
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |       u_x      |        u_y   %s|\n',NN,space1)
	fprintf( complete_txt_lin , '----------------------------------------%s \n',line1)
	for i=1:NNod,
		fprintf( complete_txt_lin , '| %4i |  %12.2e  | %12.2e %s|\n',i,Ulineal(node2dof(i,3)(1)),Ulineal(node2dof(i,3)(2)),space1)
	end
	fprintf( complete_txt_lin , '----------------------------------------%s \n\n\n',line1)
elseif NDFPN == 3
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
	if Lenguage == 1
		fprintf( complete_txt_lin , '                   Displacements (%s)                 \n',LengthMagnitude)
	elseif Lenguage == 2
		fprintf( complete_txt_lin , '                   Desplazamientos (%s)                 \n',LengthMagnitude)
	end
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
	fprintf( complete_txt_lin , '| %s |       u_x     |       u_y     |       u_z     %s|\n',NN,space1)
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n',line1)
	for i=1:NNod,
		fprintf( complete_txt_lin , '| %4i | %12.2e  | %12.2e  | %12.2e  %s|\n',i,Ulineal(node2dof(i,3)(1)),Ulineal(node2dof(i,3)(2)),Ulineal(node2dof(i,3)(3)),space1)
	end
	fprintf( complete_txt_lin , '--------------------------------------------------------%s \n\n\n',line1)
end


fprintf( complete_txt_lin ,   '---------------------------------%s \n',line2)
if Lenguage == 1
	fprintf( complete_txt_lin , '| Element  |  Axial Force (%s)   | \n',ForceMagnitude)
elseif Lenguage == 2
	fprintf( complete_txt_lin , '| Elemento |  Fuerza Axial (%s)  | \n',ForceMagnitude)
end
fprintf( complete_txt_lin ,   '---------------------------------%s \n',line2)
for i=1:NElem,
	fprintf( complete_txt_lin , '| %8i |     %12.2e   %s| \n',i,N_lineal(i),space2)
end
fprintf( complete_txt_lin ,   '---------------------------------%s \n\n\n',line2)



fprintf( complete_txt_lin , 'Sigma_lin = N_lin/A  \n\n')


fprintf( complete_txt_lin , '------------------------%s \n',line3)
if Lenguage == 1
	fprintf( complete_txt_lin , '  Stresses (%s/%s^2)              \n',ForceMagnitude,LengthMagnitude)
elseif Lenguage == 2
	fprintf( complete_txt_lin , ' Tensiones (%s/%s^2)              \n',ForceMagnitude,LengthMagnitude)
end
fprintf( complete_txt_lin , '------------------------%s \n',line3)
fprintf( complete_txt_lin , '| Elem |    Sigma_lin  %s| \n',space3)
fprintf( complete_txt_lin , '------------------------%s \n',line3)
for i=1:NElem,
	fprintf( complete_txt_lin , '| %4i | %12.2e  %s|\n',i,Sigma_lin(i),space3)
end
fprintf( complete_txt_lin , '------------------------%s \n\n\n',line3)




fprintf( complete_txt_lin ,   '---------------------------------- \n')
if Lenguage == 1
	fprintf( complete_txt_lin , '| Element  |       Strain        | \n')
elseif Lenguage == 2
	fprintf( complete_txt_lin , '| Elemento |     Deformación     | \n')
end
fprintf( complete_txt_lin ,   '---------------------------------- \n')
for i=1:NElem,
	fprintf( complete_txt_lin , '| %8i |    %12.2e     | \n',i,EPS_lineal(i))
end
fprintf( complete_txt_lin ,   '---------------------------------- \n')


fclose(complete_txt_lin) ;
tiempo_complete_txt_lin = toc ;
tiempo_TXT = tiempo_TXT + tiempo_complete_txt_lin;


