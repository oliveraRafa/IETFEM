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

if Lenguage == 1
	fprintf('\n********* IETFEM START *********\n\n',name)
	fprintf('Reading data from input file: %s\n\n',name)
else
	fprintf('\n********* IETFEM COMENZO A EJECUTARSE *********\n\n',name)
	fprintf('Leyendo datos ingresados por el usuario en el archivo: %s\n\n',name)
end
	%
tic 

%
% =======================================================
%
% ============== LECTURA DE DATOS =======================
%
fidparam  = fopen( input_file , 'r' ) ;
%
if Lenguage == 1
	fprintf(' - Force Magnitude, Length Magnitude and others parameters.\n')
else
	fprintf(' - Magnitud de Fuerza, Magnitud de Longitud y otros parametros.\n')
end
fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
ForceMagnitude = fscanf( fidparam , '%s' , [1] ) ;
%  
%Warning!
if length(ForceMagnitude)>=3
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    warning('The length of Force Magnitude is biger than 2!\n\n');
  else
    fprintf('\n********* ATENCION *********\n\n')
    warning('El largo de la magnitud de fuerza es mayor que 2! Pueden aparecer errores en la salida de texto.\n\n');
  end
end
%
fgets(fidparam);
fgets(fidparam);
fgets(fidparam);
%
LengthMagnitude = fscanf( fidparam , '%s' , [1] ) ;
%
%Warning!
if length(LengthMagnitude)>=3
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    warning('The length of Length Magnitude is biger than 2!\n\n');
  else
    fprintf('\n********* ATENCION *********\n\n')
    warning('El largo de la magnitud de longitud es mayor que 2! Pueden aparecer errores en la salida de texto.\n\n');
  end
end
%
a1 = size( LengthMagnitude ,2)-1;
if a1==0
  space1='';
  line1='';
elseif a1==1
  space1=' ';
  line1='-';
end
%
a2 = size(ForceMagnitude,2)-1;
if a2==0
  space2='';
  line2='';
elseif a2==1
  space2=' ';
  line2='-';
end
%
a3 = size( LengthMagnitude,2)-1 + size(ForceMagnitude,2)-1;
if a3==0
  space3='';
  line3='';
elseif a3==1
  space3=' ';
  line3='-';
elseif a3==2
  space3='  ';
  line3='--';
end
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
NDFPN = fscanf( fidparam , '%g' , [1] ) ;
if KindProb == 1
  if NDFPN ~= Dimensions
    cd ..
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('For Truss Problem "Dimensions" must be equal to "Number of Degrees of Freedom Per Node"!!!\n\n');
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Para problemas de barras la "Dimension" del problema debe ser igual al "Numero de grados de libertad por nodo"!!!\n\n');
    end
    return
  end
end
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
NNodPE = fscanf( fidparam , '%g' , [1] ) ;
%
fgets(fidparam);fgets(fidparam);fgets(fidparam) ;
%
if Lenguage == 1
	fprintf(' - Materials.\n')
else
	fprintf(' - Materiales.\n')
end
NMats = fscanf( fidparam , '%g' , [1] ) ;
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
cantidad_parametros_material=4; % en grandes deformaciones se necesita el nu
if SD_LD == 1
  cantidad_parametros_material=3; % en pequeñas deformaciones no se necesita el nu
end 
%
Matsmat = zeros(NMats,cantidad_parametros_material) ;
for i=1:NMats,
	%
	for j=1:cantidad_parametros_material,
		%
		aux = fscanf( fidparam , '%s' , [1] ) ;
    if size(str2num(aux))(1) == 0
      cd ..
      if Lenguage == 1
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('Length of "Number of materials" is higher than row in "Materials"! MUST BE THE SAME!!!\n\n');
      else
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('El "numero de materiales" es mayor que la cantidad de filas que tiene la matriz "Materiales"! DEBEN SER IGUALES!!!\n\n');
      end
      return
    end
		%
		Matsmat(i,j) = str2num(aux) ; 
		%
	end
	fgets(fidparam);
	%
end
%
warning1=fgets(fidparam);fgets(fidparam);
%Warning!
if size(strtrim(warning1))(2)>0
	cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Length of row in "Materials" is higher than "Number of materials"! MUST BE THE SAME!!!\n\n');
	else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La cantidad de filas que tiene la matriz "Materiales" es mayor que el "numero de materiales"! DEBEN SER IGUALES!!!\n\n');
  end
  return
end
%
NTemp = fscanf( fidparam , '%g' , [1] ) ;
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
Tempmat = zeros(NTemp,1) ;
%
if NTemp == 0
	Tempmat = [] ;
else
  if Lenguage == 1
    fprintf(' - Temperature.\n')
  else
    fprintf(' - Temperatura.\n')
  end
	for i=1:NTemp,
	%
		for j=1:1,
		%
		aux = fscanf( fidparam , '%s' , [1] ) ;
    if size(str2num(aux))(1) == 0
      cd ..
      if Lenguage == 1
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('Length of "Number of temperature cases" is higher than row in "Temperature cases"! MUST BE THE SAME!!!\n\n');
      else
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('El numero de "casos de temperatura" es mayor que la cantidad de filas que tiene la matriz "Temperatura"! DEBEN SER IGUALES!!!\n\n');
      end
      return
    end
		%
		Tempmat(i,j) = str2num(aux) ; 
		%
		end
	%
	fgets(fidparam);
	%
	end
end
%
warning1=fgets(fidparam);fgets(fidparam) ;
%Warning!
if size(strtrim(warning1))(2)>0
	cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Length of row in "Temperature cases" is higher than "Number of temperature cases"! MUST BE THE SAME!!!\n\n');
  else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La cantidad de filas de la matriz de casos de temperatura es mayor que la cantidad de casos de temperatura! DEBEN SER IGUALES!!!\n\n'); 
	end
  return
end
%
if Lenguage == 1
  fprintf(' - Sections.\n')
else
  fprintf(' - Secciones.\n')
end
NSecs = fscanf( fidparam , '%g' , [1] ) ;
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
Secsmat = zeros(NSecs,1) ;
for i=1:NSecs,
	%
	for j=1:1,
		%
		aux = fscanf( fidparam , '%s' , [1] ) ;
    if size(str2num(aux))(1) == 0
      cd ..
      if Lenguage == 1
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('Length of "Number of sections" is higher than row in "Sections"! MUST BE THE SAME!!!\n\n');
      else 
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('El numero de "secciones" es mayor que la cantidad de filas que tiene la matriz de secciones! DEBEN SER IGUALES!!!\n\n');
      end
      return
    end
		%
		Secsmat(i,j) = str2num(aux) ; 
		%
	end
	fgets(fidparam);
	%
end
%
warning1=fgets(fidparam);fgets(fidparam);
%Warning!
if size(strtrim(warning1))(2)>0
	cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Length of row in "Sections" is higher than "Number of sections"! MUST BE THE SAME!!!\n\n');
	else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La cantidad de filas de la matriz de secciones es mayor que la cantidad de secciones! DEBEN SER IGUALES!!!\n\n');
  end
  return
end
%  
if Lenguage == 1
  fprintf(' - Node cordinates.\n')
else
  fprintf(' - Coordenadas de nodos.\n')
end
NNod = fscanf( fidparam , '%g' , [1] ) ;
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
%  
NodCoordMat = [] ;
%
for i = 1 : NNod,
	%
	for j=1:NDFPN,
		%
		aux = fscanf( fidparam , '%s' , [1] ) ;
    if size(str2num(aux))(1) == 0
      cd ..
      if Lenguage == 1
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('Length of "Number of nodes" is higher than row in "Node matrix"! MUST BE THE SAME!!!\n\n');
      else
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('El numero de nodos es mayor que la cantidad de filas que tiene la matriz de nodos! DEBEN SER IGUALES!!!\n\n');
      end
      return
    end
		%
		NodCoordMat(i,j) = str2num(aux) ; 
		%
	end
	fgets(fidparam);
end
%
if Dimensions < 3
  NodCoordMat(:,[Dimensions+1:3]) = zeros(NNod,3-Dimensions);
end
%
warning1=fgets(fidparam);fgets(fidparam);
%Warning!
if size(strtrim(warning1))(2)>0
	cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Length of row in "Node matrix" is higher than "Number of nodes"! MUST BE THE SAME!!!\n\n');
  else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La cantidad de filas de la matriz de nodos es mayor que la cantidad de nodos! DEBEN SER IGUALES!!!\n\n');
  end
	return
end
%
if Lenguage == 1
  fprintf(' - Conectivity matrix.\n')
else
  fprintf(' - Matriz de conectividad.\n')
end
NElem = fscanf( fidparam , '%g' , [1] ) ;
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
auxmat = zeros(NElem,5) ;
%
for i =1 : NElem,
	%
	for j=1:5,
		%
		aux = fscanf( fidparam , '%s' , [1] ) ;
    if size(str2num(aux))(1) == 0
      cd ..
      if Lenguage == 1
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('Length of "Number of elements" is higher than row in "Conectivity matrix"! MUST BE THE SAME!!!\n\n');
      else
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('El numero de elementos es mayor que la cantidad de filas que tiene la matriz conectividad! DEBEN SER IGUALES!!!\n\n');
      end
      return
    end
		%
		auxmat(i,j) = str2num(aux) ; 
		%
	end
	fgets(fidparam);
end
%Warning!
if min(auxmat(:,1))<=0 || max(auxmat(:,1))>size(Matsmat)(1),
  cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('First column of "Conectivity matrix" is wrong! 0<value<=%i !!!\n\n',size(Matsmat)(1));
  else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La primer columna de la matriz de conectividad es incorrect! 0<valor<=%i !!!\n\n',size(Matsmat)(1));
  end
  return
end
%Warning!
if min(auxmat(:,2))<=0 || max(auxmat(:,2))>size(Secsmat)(1),
  cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Second column of "Conectivity matrix" is wrong! 0<value<=%i !!!\n\n',size(Secsmat)(1));
  else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La segunda columna de la matriz de conectividad es incorrect! 0<valor<=%i !!!\n\n',size(Secsmat)(1));
  end
  return
end
%Warning!
if min(auxmat(:,3))<0 || max(auxmat(:,3))>size(Tempmat)(1),
  cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Third column of "Conectivity matrix" is wrong! 0<=value<=%i !!!\n\n',size(Tempmat)(1));
  else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La tercer columna de la matriz de conectividad es incorrect! 0<valor<=%i !!!\n\n',size(Tempmat)(1));
  end
  return
end
%
warning1=fgets(fidparam); fgets(fidparam); 
%Warning!
if size(strtrim(warning1))(2)>0
	cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Length of row in "Conectivity matrix" is higher than "Number of elements"! MUST BE THE SAME!!!\n\n');
  else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La cantidad de filas de la matriz de conectividad es mayor que la cantidad de elementos! DEBEN SER IGUALES!!!\n\n');
  end
	return
end
%
ConectMat = auxmat( :, [ 4:5 ] ) ;
%  
for i=1:NElem,
  %
  Youngs (i) = Matsmat ( auxmat(i,1) , 1 ) ; 
  Gammas (i) = Matsmat ( auxmat(i,1) , 2 ) ; 
  Alphas (i) = Matsmat ( auxmat(i,1) , 3 ) ; 
  if SD_LD ~= 1
    Nus (i) = Matsmat ( auxmat(i,1) , 4 ) ; 
  end
  %
  Areas  (i) = Secsmat ( auxmat(i,2) , 1 ) ; 
  %
  if auxmat(i,3)==0
    Temp   (i) = 0 ;
  else
    Temp   (i) = Tempmat ( auxmat(i,3) ) ; 
  end
end
%
if Lenguage == 1
  fprintf(' - Displacement conditions.\n')
else
  fprintf(' - Condiciones en desplazamientos.\n')
end
NNodDiriCond = fscanf( fidparam , '%g' , [1] ) ;
%
%Warning!
if NNodDiriCond==0
  cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('You must put some displacement condition!!!!\n\n');
  else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Se deben poner condiciones de desplazamientos!!!!\n\n');
  end
	return
end
%
fgets(fidparam); fgets(fidparam); fgets(fidparam); fgets(fidparam); 
%
DiriCondMat = zeros(NNodDiriCond,4);
for i =1 : NNodDiriCond,
  aux = fscanf( fidparam , '%s' , [1] ) ;
    %
    if size(str2num(aux))(1) == 0
      cd ..
      if Lenguage == 1
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('Length of "Number of displacement conditions nodes" is higher than row in "Displacement conditions nodes matrix"! MUST BE THE SAME!!!\n\n');
      else
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('El numero de nodos en condiciones con desplazamientos es mayor que la cantidad de filas que tiene la matriz de nodos con condiciones en desplazamientos! DEBEN SER IGUALES!!!\n\n');
      end
      return
    end
    %
  DiriCondMat(i,1) = str2num(aux) ;
  %
  for j=1:NDFPN,
    %
    aux = fscanf( fidparam , '%s' , [1] ) ;
    %
    if isempty(str2num(aux)),
      DiriCondMat(i,j+1) = inf ;
    else
      DiriCondMat(i,j+1) = str2num(aux) ;
    end
    %
  end
  fgets(fidparam);
end
%
ReadingDiriCondMat = DiriCondMat;
if Dimensions < 3
  auxiliar([1:NNod],1)                  = [1:NNod]';
  auxiliar([1:NNod],[2:Dimensions+1])   = inf(NNod,Dimensions);
  auxiliar([1:NNod],[Dimensions+2:4])   = zeros(NNod,3-Dimensions);
  auxiliar(DiriCondMat(:,1),:) = DiriCondMat;
  DiriCondMat = auxiliar;
end
%
warning1=fgets(fidparam); fgets(fidparam); 
%Warning!
if size(strtrim(warning1))(2)>0
	cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Length of row in "Displacement conditions nodes matrix" is higher than "Number of displacement conditions nodes"! MUST BE THE SAME!!!\n\n');
	else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La cantidad de filas de la matriz de condiciones de desplazamientos es mayor que la cantidad del numero de condiciones en desplazamientos! DEBEN SER IGUALES!!!\n\n');
  end
  return
end
NNodNeumCond = fscanf( fidparam , '%g' , [1] );
%
fgets(fidparam); fgets(fidparam); fgets(fidparam); fgets(fidparam);
%
if NNodNeumCond==0
   NeumCondMat=[];
else
  NeumCondMat = zeros(NNodNeumCond,4);
  %
  if Lenguage == 1
    fprintf(' - External puntual forces.\n')
  else
    fprintf(' - Fuerzas puntuales externas.\n')
  end
  for i =1 : NNodNeumCond,
    aux = fscanf( fidparam , '%s' , [1] ) ;
    %
    if size(str2num(aux))(1) == 0
      cd ..
      if Lenguage == 1
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('Length of "Number of puntual load conditions nodes" is higher than row in "Puntual loads conditions nodes matrix"! MUST BE THE SAME!!!\n\n');
      else
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('El numero de cargas puntuales es mayor que la cantidad de filas que tiene la matriz de cargas puntuales! DEBEN SER IGUALES!!!\n\n');
      end
      return
    end
    %
    NeumCondMat(i,1) = str2num(aux) ;
    %
    for j=1:NDFPN,
    
      aux = fscanf( fidparam , '%s' , [1] ) ;
    
      if isempty(str2num(aux)),
        NeumCondMat(i,j+1) = 0 ;
      else
        NeumCondMat(i,j+1) = str2num(aux) ;
      end
      %
    end
    fgets(fidparam);
  end
  if Dimensions < 3
    NeumCondMat(:,[Dimensions+2:4]) = zeros(NNodNeumCond,3-Dimensions);
  end
end
%
warning1=fgets(fidparam); fgets(fidparam);
%Warning!
if size(strtrim(warning1))(2)>0
	cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Length of row in "Puntual loads conditions nodes matrix" is higher than "Number of puntual load conditions nodes"! MUST BE THE SAME!!!\n\n');
	else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La cantidad de filas de la matriz de cargas puntuales es mayor que la cantidad de nodos con cargas puntuales! DEBEN SER IGUALES!!!\n\n');
  end
  return
end
%

VolCondMatDead   = zeros(NElem,4);
NEleVolCondDead  = fscanf( fidparam , '%g' , [1] )  ;
%
fgets(fidparam); fgets(fidparam); fgets(fidparam); fgets(fidparam);
%
if NEleVolCondDead~=0
  if Lenguage == 1
    fprintf(' - Dead Volume forces.\n')
  else
    fprintf(' - Fuerzas de volumen muertas.\n')
  end
  for i =1 : NEleVolCondDead,
    aux = fscanf( fidparam , '%s' , [1] ) ;
    %
    if size(str2num(aux))(1) == 0
      cd ..
      if Lenguage == 1
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('Length of "Number of dead volume load conditions" is higher than row in "Dead volume loads conditions matrix"! MUST BE THE SAME!!!\n\n');
      else
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('El numero de cargas muertas de volumen es mayor que la cantidad de filas que tiene la matriz de cargas muertas de volumen! DEBEN SER IGUALES!!!\n\n');
      end
      return
    end
    %
    auxVolCondMatDead(i,1) = str2num(aux) ;
    %
    for j=1:NDFPN,
    
      aux = fscanf( fidparam , '%s' , [1] ) ;
    
      auxVolCondMatDead(i,j+1) = str2num(aux) ;
      
      %
    end
    fgets(fidparam);
  end
  VolCondMatDead(auxVolCondMatDead(:,1),[1:NDFPN+1]) = auxVolCondMatDead;  
  %
end
%
warning1=fgets(fidparam); fgets(fidparam);
%Warning!
if size(strtrim(warning1))(2)>0
	cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Length of row in "Dead volume loads conditions matrix" is higher than "Number of dead volume load conditions"! MUST BE THE SAME!!!\n\n');
	else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La cantidad de filas de la matriz de cargas muertas de volumen es mayor que la cantidad de cargas muertas de volumen! DEBEN SER IGUALES!!!\n\n');
  end
  return
end
%

NNodRobiCond = fscanf( fidparam , '%g' , [1] )  ;
%

fgets(fidparam); fgets(fidparam); fgets(fidparam); fgets(fidparam);
%
if NNodRobiCond == 0,
  RobiCondMat = [] ;
  %
else
  RobiCondMat = zeros(NNodRobiCond,4);
  %
  if Lenguage == 1
    fprintf(' - Springs conditions.\n')
  else
    fprintf(' - Resortes.\n')
  end
  for i =1 : NNodRobiCond,
    %
    aux = fscanf( fidparam , '%s' , [1] ) ;
    %
    if size(str2num(aux))(1) == 0
      cd ..
      if Lenguage == 1
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('Length of "Number of springs conditions nodes" is higher than row in "Springs conditions nodes matrix"! MUST BE THE SAME!!!\n\n');
      else
        fprintf('\n********* ATENCION *********\n\n')
        fprintf('El numero de nodos con resortes es mayor que la cantidad de filas que tiene la matriz de nodos con resortes! DEBEN SER IGUALES!!!\n\n');
      end
      return
    end
    %
    RobiCondMat(i,1) = str2num(aux) ;
    %
    for j=1:NDFPN,
      %
      aux = fscanf( fidparam , '%s' , [1] ) ;
      %
      if isempty(str2num(aux)),
        RobiCondMat(i,j+1) = 0 ;
      else
        RobiCondMat(i,j+1) = str2num(aux) ;
      end
      %
    end
    fgets(fidparam);
  end 
  %
  if Dimensions < 3
    RobiCondMat(:,[Dimensions+2:4]) = zeros(NNodRobiCond,3-Dimensions);
  end
  %
end
%
warning1=fgets(fidparam) ;fgets(fidparam) ; fgets(fidparam);
%Warning!
if size(strtrim(warning1))(2)>0
	cd ..
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Length of row in "Springs conditions nodes matrix" is higher than "Number of springs conditions nodes"! MUST BE THE SAME!!!\n\n');
	else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('La cantidad de filas de la matriz de nodos con resortes es mayor que la cantidad de nodos con resortes! DEBEN SER IGUALES!!!\n\n');
  end
  return
end
%
if Lenguage == 1
  fprintf(' - Plot and print parameters.\n')
else
  fprintf(' - Parametros de grafico e imagen.\n')
end
if SD_LD == 1 % Factores de escala
  ScaleFactor = fscanf( fidparam , '%g' , [6] )' ;
  ScaleFactor(7) = 0;
else
  ScaleFactor = fscanf( fidparam , '%g' , [7] )' ;
end
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
if SD_LD == 1 % Graficos a realizar
  Plots = fscanf( fidparam , '%g' , [3] )' ;
  Plots(4) = 0; Plots(5) = 0; Plots(6) = 0;
else
  Plots = fscanf( fidparam , '%g' , [6] )' ;
end
for i =1:length(Plots)
  if Plots(i) ~= 0 && Plots(i) ~= 1
    cd ..
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('Se debe ingresar 1 o 0 para los graficos que se deseen ver!!!\n\n');
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Se debe ingresar 1 o 0 para los graficos que se deseen ver!!!\n\n');
    end
    return
  end
end
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
if SD_LD == 1 % Graficos a realizar imagenes
  Print = fscanf( fidparam , '%g' , [3] )' ;
  Print(4) = 0; Print(5) = 0; Print(6) = 0;
else
  Print = fscanf( fidparam , '%g' , [6] )' ;
end
for i =1:length(Print)
  if Print(i) ~= 0 && Print(i) ~= 1
    cd ..
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('Se debe ingresar 1 o 0 para las imagenes que se deseen realizar!!!\n\n');
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Se debe ingresar 1 o 0 para las imagenes que se deseen realizar!!!\n\n');
    end
    return
  end
end
for i =1:length(Plots)
  if Plots(i) == 0
    Print(i) = 0;
  end
end
%
if sum(Plots)==0
  if Lenguage == 1
    fprintf(' - As your wish, IETFEM will not made plots or images.\n')
  else
    fprintf(' - Como lo deseo, IETFEM no realizara graficos ni imagenes.\n')
  end
elseif sum(Plots)>0 && sum(Print)==0
  if Lenguage == 1
    fprintf(' - As your wish, IETFEM will not made images.\n')
  else
    fprintf(' - Como lo deseo, IETFEM no realizara imagenes.\n')
  end
end
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
HowManySD = fscanf( fidparam , '%g' , [2] )' ; % cuantas imagenes de pequeñas deformaciones hacer
%
if HowManySD(1)==0
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf(' - Se debe ingresar al menos una imagen para la deformada en pequenas deformaciones.\n')
    fprintf('   IETFEM interpreta que usted no quiere ver el grafico de deformada.\n')
  else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf(' - Se debe ingresar al menos una imagen para la deformada en pequenas deformaciones.\n')
    fprintf('   IETFEM interpreta que usted no quiere ver el grafico de deformada.\n')
  end
  return
  HowManySD(1) == 1;
  Plots(2)     == 0;
  Print(2)     == 0;
end
if HowManySD(2)==0
  if Lenguage == 1
    fprintf('\n********* ATENCION *********\n\n')
    fprintf(' - Se debe ingresar al menos una imagen para la fuerza axial en pequenas deformaciones.\n')
    fprintf('   IETFEM interpreta que usted no quiere ver el grafico de fuerza axial.\n')
  else
    fprintf('\n********* ATENCION *********\n\n')
    fprintf(' - Se debe ingresar al menos una imagen para la fuerza axial en pequenas deformaciones.\n')
    fprintf('   IETFEM interpreta que usted no quiere ver el grafico de fuerza axial.\n')
  end
  return
  HowManySD(2) == 1;
  Plots(3)     == 0;
  Print(3)     == 0;
end
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
PlotView = fscanf( fidparam , '%g' , [5] )' ; % que ver y que no en los graficos
%
for i =1:length(PlotView)
  if PlotView(i) ~= 0 && PlotView(i) ~= 1
    cd ..
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('Se debe ingresar 1 o 0 para los elementos que se deseen visualizar!!!\n\n');
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Se debe ingresar 1 o 0 para los elementos que se deseen visualizar!!!\n\n');
    end
    return
  end
end
%
if Dimensions == 3 % parámetros 3D para los gráficos
  %
  fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
  %
  TresD_View = fscanf(fidparam, '%g' , [6] )' ;
  %
  if TresD_View(4) == 1
	  TresD_View(5) = -37.5; TresD_View(6) = 30;
  end
  if sum(Print([1:5])) == 0
    TresD_View([1:3]) = [0 0 0];
  end
  for i =1:length(TresD_View([1:4]))
  if TresD_View(i) ~= 0 && TresD_View(i) ~= 1
    cd ..
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('Se debe ingresar 1 o 0 para los los graficos 3D que se deseen visualizar!!!\n\n');
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Se debe ingresar 1 o 0 para los los graficos 3D que se deseen visualizar!!!\n\n');
    end
    return
  end
end
end
%
if SD_LD ~= 1
  if Lenguage == 1
    fprintf(' - Large deformation analys parameters.\n')
  else
    fprintf(' - Parametros para el analisis de grandes deformaciones.\n')
  end
  %
  fgets(fidparam);fgets(fidparam);fgets(fidparam);
  %  
  IT = fscanf( fidparam , '%g' , [1] ) ;
  if IT<= 0 || abs(floor(IT)-IT)>0
    cd ..
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('El número de iteraciones debe ser un entero mayor que cero!!!\n\n');
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('El número de iteraciones debe ser un entero mayor que cero!!!\n\n');
    end
    return
  end
  %  
  fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
  %
  DisControl = fscanf( fidparam , '%g' , [2] )' ;
  if DisControl(1)~=0 && DisControl(1)~=1
    cd ..
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('Debe ingresarse 1 o 0 en la primer variable del control de desplazamientos!!!\n\n');
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Debe ingresarse 1 o 0 en la primer variable del control de desplazamientos!!!\n\n');
    end
    return
  end
  %
  fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
  %
  LoadControl = fscanf( fidparam , '%g' , [2] )' ;
  if LoadControl(1)~=0 && LoadControl(1)~=1
    cd ..
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('Debe ingresarse 1 o 0 en la primer variable del control de cargas!!!\n\n');
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Debe ingresarse 1 o 0 en la primer variable del control de cargas!!!\n\n');
    end
    return
  end
  if LoadControl(1) == 0
    LoadControl(2) == 1;
  end
  %
  fgets(fidparam);fgets(fidparam);fgets(fidparam);
  %
  PlotIterations = fscanf( fidparam , '%g' , [1] )' ;
  if PlotIterations(1)~=0 && PlotIterations(1)~=1
    cd ..
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('Debe ingresarse 1 o 0 en la si se desaea o no ver los graficos para todos los estados de carga!!!\n\n');
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Debe ingresarse 1 o 0 en la si se desaea o no ver los graficos para todos los estados de carga!!!\n\n');
    end
    return
  end
  plot_pasos = 1;
  if PlotIterations == 0
    plot_pasos = LoadControl(2); 
  end
  %
end
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
TEXT = fscanf( fidparam , '%g' , [2] ) ;
%
for i =1:length(TEXT)
  if TEXT(i) ~= 0 && TEXT(i) ~= 1
    cd ..
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('Se debe ingresar 1 o 0 para la salida de texto!!!\n\n');
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Se debe ingresar 1 o 0 para la salida de texto!!!\n\n');
    end
    return
  end
end
%
txt="No"; tex="No";
if Lenguage == 1
  if TEXT(1) == 1
    txt = "Yes";
  end
  if TEXT(2) == 1
    tex = "Yes";
  end
  fprintf(' - Text output: %s to .txt file and %s to .tex file.\n',txt,tex)
else
  if TEXT(1) == 1
    txt = "Si";
  end
  if TEXT(2) == 1
    tex = "Si";
  end
  fprintf(' - Salida de texto: %s para el archivo .txt y %s para el archivo .tex.\n',txt,tex)
end
%
if SD_LD == 1
  if sum(TEXT) > 0 || sum(Print) > 0
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name ]);
  end
  if TEXT(1) == 1 || TEXT(2) == 1 || Print(2)== 1 
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' def '/']);
  end
  if TEXT(1) == 1 || TEXT(2) == 1 || Print(3)== 1 
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' axial '/']);
  end
  if TEXT(1) == 1 || TEXT(2) == 1
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' comp '_' out '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' epss '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' sigmas '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' reac '/']);
  end
  if TEXT(1) == 1
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' comp '_' out '/TXT/']);
    complete_txt_lin  = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' comp '_' out '/TXT/' name '_' comp '_' out '_' var '.txt'] , 'w' ) ;
		mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' def '/TXT/']);
    deformed_txt_lin     = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' def '/TXT/' name '_' def '_' var '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' axial '/TXT/']);
    axial_txt_lin        = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' axial '/TXT/' name '_' axial '_' var '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' epss '/TXT/']);
    du_txt_lin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' epss '/TXT/' name '_' epss '_' var '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' sigmas '/TXT/']);
    sigma_txt_lin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' sigmas '/TXT/' name '_' sigmas '_' var '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' reac '/TXT/']);
    reac_txt_lin         = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' reac '/TXT/' name '_' reac '_' var '.txt'] , 'w' ) ;
  end
  if TEXT(2) == 1
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' comp '_' out '/TEX/']);
    complete_tex_lin  = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' comp '_' out '/TEX/' name '_' comp '_' out '_' var '.tex'] , 'w' ) ;
		mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' def '/TEX/']);
    deformed_tex_lin     = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' def '/TEX/' name '_' def '_' var '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' axial '/TEX/']);
    axial_tex_lin        = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' axial '/TEX/' name '_' axial '_' var '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' epss '/TEX/']);
    du_tex_lin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' epss '/TEX/' name '_' epss '_' var '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' sigmas '/TEX/']);
    sigma_tex_lin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' sigmas '/TEX/' name '_' sigmas '_' var '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' reac '/TEX/']);
    reac_tex_lin         = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' reac '/TEX/' name '_' reac '_' var '.tex'] , 'w' ) ;
  end
else
  if sum(TEXT) > 0 || sum(Print) > 0
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name ]);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/']);
  end
  if TEXT(1) == 1 || TEXT(2) == 1 || Print(2)== 1 
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' def '/']);
  end
  if TEXT(1) == 1 || TEXT(2) == 1 || Print(3)== 1 
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' axial '/']);
  end
  if TEXT(1) == 1 || TEXT(2) == 1 || Print(4)== 1 
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' def '/']);
  end
  if TEXT(1) == 1 || TEXT(2) == 1 || Print(5)== 1 
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' axial '/']);
  end
  if TEXT(1) == 1 || TEXT(2) == 1 || Print(6)== 1 
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' conv '/']);
  end
  if TEXT(1) == 1 || TEXT(2) == 1
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' comp '_' out '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' epss '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' sigmas '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' reac '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' comp '_' out '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' epss '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' sigmas '/']);
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' reac '/']);
  end
  if TEXT(1) == 1
		if Lenguage == 1
			var2 = 'sd';
		else
			var2 = 'pd';
		end
		%SD
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' comp '_' out '/TXT/']);
    complete_txt_lin      = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' comp '_' out '/TXT/' name '_' comp '_' out '_' var2 '.txt'] , 'w' ) ;
		mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' def '/TXT/']);
    deformed_txt_lin     = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' def '/TXT/' name '_' def '_' var2 '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' axial '/TXT/']);
    axial_txt_lin        = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' axial '/TXT/' name '_' axial '_' var2 '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' epss '/TXT/']);
    du_txt_lin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' epss '/TXT/' name '_' epss '_' var2 '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' sigmas '/TXT/']);
    sigma_txt_lin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' sigmas '/TXT/' name '_' sigmas '_' var2 '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' reac '/TXT/']);
    reac_txt_lin         = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' reac '/TXT/' name '_' reac '_' var2 '.txt'] , 'w' ) ;
		%LD
		mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' comp '_' out '/TXT/']);
    complete_txt_fin      = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' comp '_' out '/TXT/' name '_' comp '_' out '_' var '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' conv '/TXT/']);
    convergence_txt_fin  = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' conv '/TXT/' name '_' conv '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' def '/TXT/']);
    deformed_txt_fin     = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' def '/TXT/' name '_' def '_' var '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' axial '/TXT/']);
    axial_txt_fin        = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' axial '/TXT/' name '_' axial '_' var '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' epss '/TXT/']);
    du_txt_fin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' epss '/TXT/' name '_' epss '_' var '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' sigmas '/TXT/']);
    sigma_txt_fin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' sigmas '/TXT/' name '_' sigmas '_' var '.txt'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' reac '/TXT/']);
    reac_txt_fin         = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' reac '/TXT/' name '_' reac '_' var '.txt'] , 'w' ) ;
  end
  if TEXT(2) == 1
		%SD
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' comp '_' out '/TEX/']);
    complete_tex_lin      = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' comp '_' out '/TEX/' name '_' comp '_' out '_' var '.tex'] , 'w' ) ;
		mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' def '/TEX/']);
    deformed_tex_lin     = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' def '/TEX/' name '_' def '_' var2 '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' axial '/TEX/']);
    axial_tex_lin        = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' axial '/TEX/' name '_' axial '_' var2 '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' epss '/TEX/']);
    du_tex_lin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' epss '/TEX/' name '_' epss '_' var2 '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' sigmas '/TEX/']);
    sigma_tex_lin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' sigmas '/TEX/' name '_' sigmas '_' var2 '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' reac '/TEX/']);
    reac_tex_lin         = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' reac '/TEX/' name '_' reac '_' var2 '.tex'] , 'w' ) ;
		%LD
		mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' comp '_' out '/TEX/']);
    complete_tex_fin      = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' comp '_' out '/TEX/' name '_' comp '_' out '_' var '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' conv '/TEX/']);
    convergence_tex_fin  = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' conv '/TEX/' name '_' conv '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' def '/TEX/']);
    deformed_tex_fin     = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' def '/TEX/' name '_' def '_' var '.tex'] , 'w' ) ;  
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' axial '/TEX/']);  
    axial_tex_fin        = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' axial '/TEX/' name '_' axial '_' var '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' reac '/TEX/']);
    reac_tex_fin         = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' reac '/TEX/' name '_' reac '_' var '.tex'] , 'w' ) ;
		mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' epss '/TEX/']);
    du_tex_fin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' epss '/TEX/' name '_' epss '_' var '.tex'] , 'w' ) ;
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' sigmas '/TEX/']);
    sigma_tex_fin           = fopen( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' sigmas '/TEX/' name '_' sigmas '_' var '.tex'] , 'w' ) ;
  end
end
%
if Dimensions == 3
  if sum(TresD_View([1:3]))>0
    if SD_LD == 1 && sum(Print([1:3]))>0
    mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/']);
      if TresD_View(1) == 1
        mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XY/']);
        if Print(2) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XY/' def '/']);
        end
        if Print(3) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XY/' axial '/']);
        end
      end
      if TresD_View(2) == 1
        mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XZ/']);
        if Print(2) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XZ/' def '/']);
        end
        if Print(3) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XZ/' axial '/']);
        end
      end
      if TresD_View(3) == 1
        mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/YZ/']);
        if Print(2) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/YZ/' def '/']);
        end
        if Print(3) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/YZ/' axial '/']);
        end
      end
    elseif SD_LD ~= 1 && sum(Print([1,4,5]))>0
      mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/']);
      if TresD_View(1) == 1
        mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XY/']);
        if Print(2) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XY/' def '/']);
        end
        if Print(3) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XY/' axial '/']);
        end
        mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XY/']);
        if Print(4) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XY/' def '/']);
        end
        if Print(5) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XY/' axial '/']);
        end 
      end
      if TresD_View(2) == 1
        mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XZ/']);
        if Print(2) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XZ/' def '/']);
        end
        if Print(3) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XZ/' axial '/']);
        end
        mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XZ/']);
        if Print(4) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XZ/' def '/']);
        end
        if Print(5) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XZ/' axial '/']);
        end
      end
      if TresD_View(3) == 1
        mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/YZ/']);
        if Print(2) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/YZ/' def '/']);
        end
        if Print(3) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/YZ/' axial '/']);
        end
        mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/YZ/']);
        if Print(4) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/YZ/' def '/']);
        end
        if Print(5) == 1
          mkdir(['../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/YZ/' axial '/']);
        end
      end
    end
  end
end
%
reading_time = toc ;

if Lenguage == 1
  fprintf(' - After %6.3f seconds, IETFEM complete Reading module.\n',reading_time)
else
  fprintf(' - Luego de %6.3f segundos, IETFEM competo el modulo "Reading".\n',reading_time)
end

