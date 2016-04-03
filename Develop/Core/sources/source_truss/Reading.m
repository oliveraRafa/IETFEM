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
fprintf('\n********* IETFEM COMENZO A EJECUTARSE *********\n\n',name)
fprintf('Leyendo datos ingresados por el usuario en el archivo: %s\n\n',name)
%
tic 

%
% =======================================================
%
% ============== LECTURA DE DATOS =======================
%
fidparam  = fopen( input_file , 'r' ) ;
%
fprintf(' - Magnitud de Fuerza, Magnitud de Longitud y otros parametros.\n')
%
fgets(fidparam);fgets(fidparam);fgets(fidparam);
%
ForceMagnitude = fscanf( fidparam , '%s' , [1] ) ;
%  
%Warning!
if length(ForceMagnitude)>=3
  fprintf('\n********* ATENCION *********\n\n')
  warning('El largo de la magnitud de fuerza es mayor que 2! Pueden aparecer errores en la salida de texto.\n\n');
end
%
fgets(fidparam);
fgets(fidparam);
fgets(fidparam);
%
LengthMagnitude = fscanf( fidparam , '%s' , [1] ) ;
%
if length(LengthMagnitude)>=3
  %Warning!
  fprintf('\n********* ATENCION *********\n\n')
  warning('El largo de la magnitud de longitud es mayor que 2! Pueden aparecer errores en la salida de texto.\n\n');
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
%Warning!
if KindProb == 1
  if NDFPN ~= Dimensions
    cd ..
    fprintf('\n********* ATENCION *********\n\n')
    fprintf('Para problemas de barras la "Dimension" del problema debe ser igual al "Numero de grados de libertad por nodo"!!!\n\n');
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
fprintf(' - Materiales.\n')
%
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
    if size(str2num(aux),1) == 0
      cd ..
      %Warning!
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Posiblemente el "numero de materiales" es mayor que la cantidad de filas que tiene la matriz "Materiales"! DEBEN SER IGUALES!!!\n\n');
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
if size(strtrim(warning1),2)>0
	cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la cantidad de filas que tiene la matriz "Materiales" es mayor que el "numero de materiales"! DEBEN SER IGUALES!!!\n\n');
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
  fprintf(' - Temperatura.\n')
	for i=1:NTemp,
	%
		for j=1:1,
		%
		aux = fscanf( fidparam , '%s' , [1] ) ;
    if size(str2num(aux),1) == 0
      cd ..
      %Warning!
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Posiblemente el numero de "casos de temperatura" es mayor que la cantidad de filas que tiene la matriz "Temperatura"! DEBEN SER IGUALES!!!\n\n');
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
if size(strtrim(warning1),2)>0
	cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la cantidad de filas de la matriz de casos de temperatura es mayor que la cantidad de casos de temperatura! DEBEN SER IGUALES!!!\n\n'); 
  return
end
%
fprintf(' - Secciones.\n')
%
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
    if size(str2num(aux),1) == 0
      cd ..
      %Warning!
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Posiblemente el numero de "secciones" es mayor que la cantidad de filas que tiene la matriz de secciones! DEBEN SER IGUALES!!!\n\n');
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
if size(strtrim(warning1),2)>0
	cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la cantidad de filas de la matriz de secciones es mayor que la cantidad de secciones! DEBEN SER IGUALES!!!\n\n');
  return
end
%  
fprintf(' - Coordenadas de nodos.\n')
%
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
    if size(str2num(aux),1) == 0
      cd ..
      %Warning!
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Posiblemente el numero de nodos es mayor que la cantidad de filas que tiene la matriz de nodos! DEBEN SER IGUALES!!!\n\n');
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
if size(strtrim(warning1),2)>0
	cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la cantidad de filas de la matriz de nodos es mayor que la cantidad de nodos! DEBEN SER IGUALES!!!\n\n');
	return
end
%
fprintf(' - Matriz de conectividad.\n')
%
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
    if size(str2num(aux),1) == 0
      cd ..
      %Warning!
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Posiblemente el numero de elementos es mayor que la cantidad de filas que tiene la matriz conectividad! DEBEN SER IGUALES!!!\n\n');
      return
    end
		%
		auxmat(i,j) = str2num(aux) ; 
		%
	end
	fgets(fidparam);
end
%Warning!
if min(auxmat(:,1))<=0 || max(auxmat(:,1))>size(Matsmat,1),
  cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la primer columna de la matriz de conectividad es incorrecta! 0<valor<=%i !!!\n\n',size(Matsmat,1));
  return
end
%Warning!
if min(auxmat(:,2))<=0 || max(auxmat(:,2))>size(Secsmat,1),
  cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la segunda columna de la matriz de conectividad es incorrecta! 0<valor<=%i !!!\n\n',size(Secsmat,1));
  return
end
%Warning!
if min(auxmat(:,3))<0 || max(auxmat(:,3))>size(Tempmat,1),
  cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la tercer columna de la matriz de conectividad es incorrecta! 0<valor<=%i !!!\n\n',size(Tempmat,1));
  return
end
%
warning1=fgets(fidparam); fgets(fidparam); 
%Warning!
if size(strtrim(warning1),2)>0
	cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la cantidad de filas de la matriz de conectividad es mayor que la cantidad de elementos! DEBEN SER IGUALES!!!\n\n');
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
fprintf(' - Condiciones en desplazamientos.\n')
%
NNodDiriCond = fscanf( fidparam , '%g' , [1] ) ;
%
%Warning!
if NNodDiriCond==0
  cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Se deben poner condiciones de desplazamientos!!!!\n\n');
	return
end
%
fgets(fidparam); fgets(fidparam); fgets(fidparam); fgets(fidparam); 
%
DiriCondMat = zeros(NNodDiriCond,4);
for i =1 : NNodDiriCond,
  aux = fscanf( fidparam , '%s' , [1] ) ;
    %
    if size(str2num(aux),1) == 0
      cd ..
      %Warning!
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('El numero de nodos en condiciones con desplazamientos es mayor que la cantidad de filas que tiene la matriz de nodos con condiciones en desplazamientos! DEBEN SER IGUALES!!!\n\n');
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
if size(strtrim(warning1),2)>0
	cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la cantidad de filas de la matriz de condiciones de desplazamientos es mayor que la cantidad del numero de condiciones en desplazamientos! DEBEN SER IGUALES!!!\n\n');
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
  fprintf(' - Fuerzas puntuales externas.\n')
  for i =1 : NNodNeumCond,
    aux = fscanf( fidparam , '%s' , [1] ) ;
    %
    if size(str2num(aux),1) == 0
      cd ..
      %Warning!
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Posiblemente el numero de cargas puntuales es mayor que la cantidad de filas que tiene la matriz de cargas puntuales! DEBEN SER IGUALES!!!\n\n');
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
if size(strtrim(warning1),2)>0
	cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la cantidad de filas de la matriz de cargas puntuales es mayor que la cantidad de nodos con cargas puntuales! DEBEN SER IGUALES!!!\n\n');
  return
end
%

VolCondMatDead   = zeros(NElem,4);
NEleVolCondDead  = fscanf( fidparam , '%g' , [1] )  ;
%
fgets(fidparam); fgets(fidparam); fgets(fidparam); fgets(fidparam);
%
if NEleVolCondDead~=0
  fprintf(' - Fuerzas de volumen muertas.\n')
  for i =1 : NEleVolCondDead,
    aux = fscanf( fidparam , '%s' , [1] ) ;
    %
    if size(str2num(aux),1) == 0
      cd ..
      %Warning!
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Posiblemente el numero de cargas muertas de volumen es mayor que la cantidad de filas que tiene la matriz de cargas muertas de volumen! DEBEN SER IGUALES!!!\n\n');
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
if size(strtrim(warning1),2)>0
	cd ..
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Posiblemente la cantidad de filas de la matriz de cargas muertas de volumen es mayor que la cantidad de cargas muertas de volumen! DEBEN SER IGUALES!!!\n\n');
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
  fprintf(' - Resortes.\n')
  %
  for i =1 : NNodRobiCond,
    %
    aux = fscanf( fidparam , '%s' , [1] ) ;
    %
    if size(str2num(aux),1) == 0
      cd ..
      %Warning!
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Posiblemente el numero de nodos con resortes es mayor que la cantidad de filas que tiene la matriz de nodos con resortes! DEBEN SER IGUALES!!!\n\n');
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

fprintf(' - Salida de texto en .txt y en .tex (formato LaTeX).\n')
%~ 
mkdir(['../../output_UI/' name ]);
[status, msg, msgid] = copyfile(['../../input_UI/' name  '.txt'],['../../output_UI/' name '/' name  '_UI.txt']);
complete_UI_output  = fopen(['../../output_UI/' name '/' name  '_UI.txt'] , 'a' ) ;
complete_txt_lin  = fopen( ['../../output_UI/' name '/' name  '_TXT.txt'] , 'w' ) ;
complete_tex_lin  = fopen( ['../../output_UI/' name '/' name  '_TEX.tex'] , 'w' ) ;
%
TEXT = [1 1];
reading_time = toc ;

fprintf(' - Luego de %6.3f segundos, IETFEM competo el modulo "Reading".\n',reading_time)


