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
clear all, close all, clc
%
graphics_toolkit("gnuplot") % se usa por los gráficos en 3D que quedan mal sino, es un bug de Octave - gnuplot
version = "2.11"; % En algún momento modificar en todos lados, incluirlo como string
%
TEXT(1)  = 10; % es un controlador del Reading (para que no haya que usar cd ..), a futuro cambiarlo
BAD_COND = 'SI';
% Read the input.txt file
fprintf('\n=========================================================================================\n')
fprintf('=======       Welcome to IETFEM v%s      /       Bienvenido a IETFEM v%s      =======\n\n',version,version)
fprintf('           Choose language - English(1)    /   Elija el lenguaje - Espanol(2)          '); Lenguage=input(':');
if Lenguage ~= 1 && Lenguage ~= 2 
	fprintf('\n********* ERROR *********\n')
	fprintf('\nLANGUAGE ERROR - MUST BE 1 OR 2    /   ERROR EN EL IDIOMA - DEBE SER 1 O 2\n\n')
	return
end
%
if Lenguage == 1
	%
	fprintf('\n\n - IETFEM can resolve (for now) 3 kinds of problems: \n')
	fprintf('   1 - Truss Problems \n')
	fprintf('   2 - Frame Problems \n')
  fprintf('   3 - Arches Problems \n\n')
	%
	KindProb   = input('   Introduce the Poroblem Kind:') ;
	if KindProb ~= 1 && KindProb ~= 2 && KindProb ~= 3
		fprintf('\n********* ERROR *********\n')
		fprintf('\nERROR IN KIND PROBLEM - MUST BE 1 OR 2\n\n')
		return
	end
	%
	if KindProb == 1
		%
		fprintf('\n\n - How many dimensions have your Truss Problem?\n')
		fprintf('   1 - 1D \n')
		fprintf('   2 - 2D \n')
		fprintf('   3 - 3D \n\n')
		%
		Dimensions   = input('   Introduce the Dimension Problem:') ;
		if Dimensions ~= 1 && Dimensions ~= 2 && Dimensions ~= 3
			fprintf('\n********* ERROR *********\n')
			fprintf('\nERROR IN DIMENSIONS PROBLEM - MUST BE 1, 2 OR 3\n\n')
			return
		end
		%
		fprintf('\n\n - For Truss Problems IETFEM, can resolve for:\n')
		fprintf('   1 - Small Deformation and Displacement\n')
		fprintf('   2 - Large Deformation and Displacement\n\n')
		%
		SD_LD        = input('   Small or Large?:') ;
		if SD_LD ~= 1 && SD_LD ~= 2 
			fprintf('\n********* ERROR *********\n')
			fprintf('\nERROR IN ELASTICITY THEORY - MUST BE 1 OR 2\n\n')
			return
		end
    if SD_LD == 2
      fprintf('\n\n - This version of IETFEM does not include this module.\n')
      return
    end
		%
		if SD_LD == 2
			SD_LD = 4; % es para que queden en orden los tipos de problema
		end
		%
		ProbType     = KindProb + (Dimensions-1) + (SD_LD-1);
		%
		fprintf('\n\nPlease insert the name of the problem\n')
		fprintf('The IETFEM will:\n')
		fprintf(' - read the parameters from the "name.txt" file in the input folder \n')
		fprintf(' - produce output files in the name folder inside the output folder. \n\n')
		%
		name       = input('   Introduce the string to replace for name:','s') ;
		%
	elseif KindProb == 2
		%
    fprintf('\n\n - This version of IETFEM does not include this module.\n')
    return
    %fprintf('\n\n - For Frame Problems IETFEM can only resolve for Small Deformation and Displacement, and two dimensions.\n')
		%fprintf('\n\nHow many dimensions have your Frame Problem?\n')
		%fprintf('   1 - 1D \n')
		%fprintf('   2 - 2D \n')
		%fprintf('   3 - 3D \n')
		%
		Dimensions   = 2;%input('Introduce the Dimension Problem:') ;
		%
		%fprintf('\n\n - For Frame Problem, IETFEM can resolve for Small and Large deformation\n')
		%fprintf('   1 - Small Deformation \n')
		%fprintf('   2 - Large Deformation \n')
		%
		SD_LD        = 1;%input('Small o Large Deformation?:') ;
		%
		%if SD_LD == 2
		%	SD_LD = 4; % es para que queden en orden los tipos de problema
		%end
		%
		ProbType     = 5 + KindProb + (Dimensions-1) + (SD_LD-1);
		%
		fprintf('\n\nPlease insert the name of the problem\n')
		fprintf('The IETFEM will:\n')
		fprintf(' - read the parameters from the "name.txt" file in the input folder, \n')
		fprintf(' - produce output files in the name folder inside the output folder. \n\n')
		%
		name       = input('   Introduce the string to replace for name:','s') ;
		%
	elseif KindProb == 3
   %
    fprintf('\n\n - This version of IETFEM does not include this module.\n')
    return
    fprintf('\n\n - For Arch Problems IETFEM works with the program created by students of the signature \n')
    fprintf('   "Metodos Computacionales Aplicados al Calculo de Estructuras" in 2014, named ARCHFEM. \n')
    fprintf('   There are only considered Small Deformations and Small Displacements.\n')
    fprintf('   The autors students are: Mihdi Caballero / Yessica Rodriguez / Francisco Vidovich.\n\n')
    
		%fprintf('\n\nHow many dimensions have your Frame Problem?\n')
		%fprintf('   1 - 1D \n')
		%fprintf('   2 - 2D \n')
		%fprintf('   3 - 3D \n')
		%
		Dimensions   = 2;%input('Introduce the Dimension Problem:') ;
		%
		%fprintf('\n\n - For Frame Problem, IETFEM can resolve for Small and Large deformation\n')
		%fprintf('   1 - Small Deformation \n')
		%fprintf('   2 - Large Deformation \n')
		%
		SD_LD        = 1;%input('Small o Large Deformation?:') ;
		%
		%if SD_LD == 2
		%	SD_LD = 4; % es para que queden en orden los tipos de problema
		%end
		%
		%ProbType     = 5 + KindProb + (Dimensions-1) + (SD_LD-1); QUE ES ESTO??????????? REVISAR PARA PORTICOS Y RETICULADOS
		%
		%~ fprintf('\n\nPlease insert the name of the problem\n')
		%~ fprintf('The IETFEM will:\n')
		%~ fprintf(' - read the parameters from the "name.txt" file in the input folder, \n')
		%~ fprintf(' - produce output files in the name folder inside the output folder. \n\n')
		%~ %
		%~ name       = input('   Introduce the string to replace for name:','s') ;
		%
  end
	%
else	
	%
	fprintf('\n\n - IETFEM puede resolver (por ahora) 3 clases de problemas: \n')
	fprintf('   1 - Problemas de Reticulados \n')
	fprintf('   2 - Problemas de Porticos \n')
  fprintf('   3 - Problemas de Arcos \n\n')
	%
	KindProb   = input('   Introduzca la clase de problema:') ;
	if KindProb ~= 1 && KindProb ~= 2  && KindProb ~= 3
		fprintf('\n********* ERROR *********\n')
		fprintf('\nERROR EN LA CLASE DE PROBLEMA - DEBE SER 1 O 2\n\n')
		return
	end	
	%
	if KindProb == 1
		%
		fprintf('\n\n - Cuantas dimensiones tiene su Problema de Reticulado?\n')
		fprintf('   1 - 1D \n')
		fprintf('   2 - 2D \n')
		fprintf('   3 - 3D \n\n')
		%
		Dimensions   = input('   Introduzca la dimension del problema:') ;
		if Dimensions ~= 1 && Dimensions ~= 2 && Dimensions ~= 3
			fprintf('\n********* ERROR *********\n')
			fprintf('\nERROR EN LAS DIMENSIONES DEL PROBLEMA - DEBE SER 1, 2 O 3\n\n')
			return
		end
		%
		fprintf('\n\n - Para Problemas de Retiulados, IETFEM puede resolver:\n')
		fprintf('   1 - Pequenas Deformaciones y Desplazamientos \n')
		fprintf('   2 - Grandes Deformaciones y Desplazamientos\n\n')
		%
		SD_LD        = input('   Pequenas o Grandes?:') ;
		if SD_LD ~= 1 && SD_LD ~= 2 
			fprintf('\n********* ERROR *********\n')
			fprintf('\nERROR EN TEORIA DE ELASTICIDAD - DEBE SER 1 O 2\n\n')
			return
		end
    if SD_LD == 2
      fprintf('\n\n - Esta version de IETFEM no incluye este modulo.\n')
      return
    end
		%
		if SD_LD == 2
			SD_LD = 4;
		end
		%
		ProbType     = KindProb + (Dimensions-1) + (SD_LD-1);
		%
		fprintf('\n\nPor favor introduzca el nombre del problema\n')
		fprintf('IETFEM se ocupara de:\n')
		fprintf(' - leer los parametros desde el archivo "nombre.txt" que se encuentra en la carpeta "input",\n')
		fprintf(' - producir archivos de salida dentro de la carpeta "output".\n\n')
		%
		name       = input('   Introduzca el nombre del problema:','s') ;
		%
	elseif KindProb == 2
		%
    fprintf('\n\n - Esta version de IETFEM no incluye este modulo.\n')
    return
    fprintf('\n\n - Para Problemas de Potico IETFEM solo puede resolver para Pequenas Deformaciones y Desplazamientos, y en dos dimensiones.\n')
		%fprintf('\n\nCuantas dimensiones tiene su Problema de Pórtico?\n')
		%fprintf('   1 - 1D \n')
		%fprintf('   2 - 2D \n')
		%fprintf('   3 - 3D \n')
		%
		Dimensions   = 2;%input('Introduzca la dimensión del problema:') ;
		%
		%fprintf('\n\n - Para Problemas de Pórtico, IETFEM puede resolver para Pequeñas y Grandes Deformaciones\n')
		%fprintf('   1 - Pequeñas Deformaciones \n')
		%fprintf('   2 - Grandes Deformaciones \n')
		%
		SD_LD        = 1;%input('Pequeñas o Grandes Deformaciones?:') ;
		%
		if SD_LD == 2
			SD_LD = 4;
		end
		%
		ProbType     = 5 + KindProb + (Dimensions-1) + (SD_LD-1);
		%
		fprintf('\n\nPor favor introduzca el nombre del problema\n')
		fprintf('IETFEM se ocupara de:\n')
		fprintf(' - leer los parametros desde el archivo "nombre.txt" que se encuentra en la carpeta "input",\n')
		fprintf(' - producir archivos de salida dentro de la carpeta "output".\n\n')
		%
		name       = input('   Introduzca el nombre del problema:','s') ;
		%
	elseif KindProb == 3
    %
    fprintf('\n\n - Esta version de IETFEM no incluye este modulo.\n')
    return
    fprintf('\n\n - Para Problemas de Arcos IETFEM utiliza el programa que realizaron alumnos del curso \n')
    fprintf('   de Metodos Computacionales Aplicados al Calculo de Estructuras en 2014, llamado ARCHFEM. \n')
    fprintf('   Se considerán unicamente Pequenas Deformaciones y Pequenos Desplazamientos. \n')
    fprintf('   Los alumnos autores son: Mihdi Caballero / Yessica Rodriguez / Francisco Vidovich.\n\n')
		%fprintf('\n\nCuantas dimensiones tiene su Problema de Arco?\n')
		%fprintf('   1 - 1D \n')
		%fprintf('   2 - 2D \n')
		%fprintf('   3 - 3D \n')
		%
		Dimensions   = 2;%input('Introduzca la dimensión del problema:') ;
		%
		%fprintf('\n\n - Para Problemas de Arco, IETFEM/ARCHFEM puede resolver para Pequeñas y Grandes Deformaciones\n')
		%fprintf('   1 - Pequeñas Deformaciones \n')
		%fprintf('   2 - Grandes Deformaciones \n')
		%
		SD_LD        = 1;%input('Pequeñas o Grandes Deformaciones?:') ;
		%
		if SD_LD == 2
			SD_LD = 4;
		end
		%
		%ProbType     = 5 + KindProb + (Dimensions-1) + (SD_LD-1); QUE ES ESTO??????????? REVISAR PARA PORTICOS Y RETICULADOS
		%
		%~ fprintf('\n\nPor favor introduzca el nombre del problema\n')
		%~ fprintf('IETFEM se ocupara de:\n')
		%~ fprintf(' - leer los parametros desde el archivo "nombre.txt" que se encuentra en la carpeta "input",\n')
		%~ fprintf(' - producir archivos de salida dentro de la carpeta "output".\n\n')
		%~ %
		%~ name       = input('   Introduzca el nombre del problema:','s') ;
		%
  end
end	
%
if SD_LD == 1
  var1 = 'sd';
  if Lenguage == 1
    var = 'sd';
  else
    var = 'pd';
  end
else
  var1 = 'ld';
	if Lenguage == 1
    var = 'ld';
  else
    var = 'gd';
  end
end
%
if Lenguage == 1
  elas = 'finite'; elas2= 'linear'; out  = 'text_output'; def  = 'deformed'; epss = 'strains';  sigmas = 'stresses';
  axial= 'axial_force'; reac = 'reactions'; img  = 'images'; ind  = 'undeformed'; conv = 'convergence'; comp = 'complete';
else
  elas = 'finita'; elas2= 'lineal'; out  = 'salida_de_texto'; def  = 'deformada'; epss = 'deformaciones'; sigmas = 'tensiones';
  axial= 'fuerza_axial'; reac = 'reacciones'; img  = 'imagenes'; ind  = 'indeformada'; conv = 'convergencia'; comp = 'completa';
end
%
if KindProb == 1
    KP = 'Truss';
elseif KindProb == 2
    KP = 'Frame';
elseif KindProb == 3
    KP = 'Arch';
end
%
Dim = num2str(Dimensions) ;
%
if exist(['output/'],'dir')~=7 
	mkdir(['output/']);
end
%
if exist(['output/' Dim 'D/'],'dir')~=7 
	mkdir(['output/' Dim 'D/']);
end
if exist(['output/' Dim 'D/' KP '_' Dim 'D_' var1 '/'],'dir')~=7
	mkdir(['output/' Dim 'D/' KP '_' Dim 'D_' var1 '/']);
end




if KindProb ~= 3
  if exist(['input/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '.txt'],'file')~=2 
    if Lenguage == 1
      fprintf('\n********* ERROR *********\n')
      fprintf('\nERROR IN INPUT FILE NAME - DO NOT EXIST INTO "input/%sD/%s_%sD_%s" FOLDER\n\n',Dim,KP,Dim,var1)
      return
    else
      fprintf('\n********* ERROR *********\n')
      fprintf('\nERROR EN EL NOMBRE DE ENTRADA DE DATOS - NO EXISTE EN LA CARPETA "input/%sD/%s_%sD_%s"\n\n',Dim,KP,Dim,var1)
      return
    end
  end
  input_file = [ '../../input/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '.txt' ] ; 
  %
  if exist(['output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name],'dir')==7
    if Lenguage == 1
      fprintf('\n********* ATENTION *********\n\n')
      fprintf('Exist a folder inside "output" folder with the same name to problem name, do you want to delete?\n')
      flag_borrar = input('For YES you can use: Y, y, S, s - For NO you can use any different word:','s') ;
    else
      fprintf('\n********* ATENCION *********\n\n')
      fprintf('Existe una carpeta dentro de "output" con el nombre del archivo a ejecutar, desea borrarla?\n')
      flag_borrar = input('Por SI puede usar: S, s, Y, y - Por NO puede usar cualquier otra letra:','s') ;
    end
    if flag_borrar == 'Y' || flag_borrar == 'y' || flag_borrar == 'S' || flag_borrar == 's'
      [a] = rmdir(['output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name]);
      [b] = exist(['output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name],'dir');
      if a == 0 && b==7
        chdir(['output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name]);
        list=dir(pwd);  %get info of files/folders in current directory
        isfile=~[list.isdir]; %determine index of files vs folders
        filenames1={list(isfile).name}; %create cell array of file names
        for i = 1:length(filenames1)
          unlink(filenames1{i});
        end
        dirnames={list([list.isdir]).name};
        dirnames1=dirnames(~(strcmp('.',dirnames)|strcmp('..',dirnames)));
        for i = 1:length(dirnames1)
          [a] = rmdir([dirnames1{i}]);
          [b] = exist([dirnames1{i}],'dir');
          if a == 0 && b==7
            chdir([dirnames1{i}]);
            list=dir(pwd);  %get info of files/folders in current directory
            isfile=~[list.isdir]; %determine index of files vs folders
            filenames2={list(isfile).name}; %create cell array of file names
            for j = 1:length(filenames2)
              unlink(filenames2{j});
            end
            dirnames={list([list.isdir]).name};
            dirnames2=dirnames(~(strcmp('.',dirnames)|strcmp('..',dirnames)));
            for j = 1:length(dirnames2)
              [a] = rmdir([dirnames2{j}]);
              [b] = exist([dirnames2{j}],'dir');
              if a == 0 && b==7
                chdir([dirnames2{j}]);
                list=dir(pwd);  %get info of files/folders in current directory
                isfile=~[list.isdir]; %determine index of files vs folders
                filenames3={list(isfile).name}; %create cell array of file names
                for k = 1:length(filenames3)
                  unlink(filenames3{k});
                end
                dirnames={list([list.isdir]).name};
                dirnames3=dirnames(~(strcmp('.',dirnames)|strcmp('..',dirnames)));
                for k = 1:length(dirnames3)
                  [a] = rmdir([dirnames3{k}]);
                  [b] = exist([dirnames3{k}],'dir');
                  if a == 0 && b==7
                    chdir([dirnames3{k}]);
                    list=dir(pwd);  %get info of files/folders in current directory
                    isfile=~[list.isdir]; %determine index of files vs folders
                    filenames4={list(isfile).name}; %create cell array of file names
                    for r = 1:length(filenames4)
                      unlink(filenames4{r});
                    end
                    dirnames={list([list.isdir]).name};
                    dirnames4=dirnames(~(strcmp('.',dirnames)|strcmp('..',dirnames)));
                    for r = 1:length(dirnames4)
                      [a] = rmdir([dirnames4{r}]);
                      [b] = exist([dirnames4{r}],'dir');
                      if a == 0 && b==7
                        chdir([dirnames4{r}]);
                        list=dir(pwd);  %get info of files/folders in current directory
                        isfile=~[list.isdir]; %determine index of files vs folders
                        filenames5={list(isfile).name}; %create cell array of file names
                        for m = 1:length(filenames5)
                          unlink(filenames5{m});
                        end
                        dirnames={list([list.isdir]).name};
                        dirnames5=dirnames(~(strcmp('.',dirnames)|strcmp('..',dirnames)));
                        for m = 1:length(dirnames5)
                          [a] = rmdir([dirnames5{m}]);
                          [b] = exist([dirnames5{m}],'dir');
                          if a == 0 && b == 7
                            chdir([dirnames5{m}]);
                            list=dir(pwd);  %get info of files/folders in current directory
                            isfile=~[list.isdir]; %determine index of files vs folders
                            filenames6={list(isfile).name}; %create cell array of file names
                            for h = 1:length(filenames6)
                              unlink(filenames6{h});
                            end
                            cd ..
                          end
                          [a] = rmdir([dirnames5{m}]);
                        end
                        cd ..
                      end
                      [a] = rmdir([dirnames4{r}]);
                    end
                    cd ..
                  end
                  [a] = rmdir([dirnames3{k}]);
                end
                cd ..
              end
              [a] = rmdir([dirnames2{j}]);
            end
            cd ..
          end
          [a] = rmdir([dirnames1{i}]);
        end
        cd ..
        [a] = rmdir([name]);
        cd ../../..
      end
    else
      if Lenguage == 1
        fprintf('\n********* YOU MUST TO INTRODUCE OTHER NAME TO INPUT FILE *********\n\n')
      return
      else
        fprintf('\n********* DEBE INTRODUCIR OTRO NOMBRE DE ARCHIVO DE ENTRADA *********\n\n')
        return
      end
    end
  end
end
%
if KindProb == 1,
	cd sources
	cd source_truss
	%
	Reading
	if TEXT(1) == 10
		if Lenguage == 1
			fprintf('\n********* ATENTION *********\n\n')
			fprintf('\nIETFEM have problems reading input file. You must check the file: input/%sD/%s_%sD_%s/%s.txt.\n\n',Dim,KP,Dim,var,name)
		else
			fprintf('\n********* ATENCION *********\n\n')
			fprintf('\nIETFEM tuvo problemas leyendo el archvio de entrada. Debe chequear el archivo: input/%sD/%s_%sD_%s/%s.txt.\n\n',Dim,KP,Dim,var,name)
		end
    cd ..
		return
	end
	PreProcess
    %MassPreProcess
	BoundaryCond
	Process
	%ModeProcess
	if BAD_COND == 'NO'
		cd ..
		return
	end
	PosProcess
	%ModePosProcess
	Text_Output
  
elseif KindProb == 2,
	cd sources
	cd source_frame
	%
	Reading
	PreProcess4
	MassPreProcess4
	BoundaryCond
	Process
	ModeProcess
	PosProcess4
	ModePosProcess4
	Tables4

elseif KindProb == 3,

  cd sources
  cd source_arch
  %
  archfem
  
end

cd ..
cd ..
