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
clear all, close all, clc
%
version = '0.01';
%
TEXT(1)  = 10; % es un controlador del Reading (para que no haya que usar cd ..), a futuro cambiarlo
BAD_COND = 'SI';
% Read the input.txt file
fprintf('\n=========================================================================================\n')
fprintf('=======       Welcome to IETFEM v%s      /       Bienvenido a IETFEM v%s      =======\n\n',version,version)
fprintf('==== Nowadays the default language is spanish. Future versions will have english too ====\n')
fprintf('=========================================================================================\n\n')

fprintf('Para la version con Interface Gráfica (UI por sus siglas en ingles), IETFEM resuleve:\n')
KindProb = 1; Dimensions = 3; SD_LD = 1;
fprintf('     - Reticulados en tres dimensiones.\n')
fprintf('     - Pequenos desplazamientos y pequenas deformaciones.\n')


fprintf('\n\nPor favor introduzca el nombre del problema\n')
fprintf('IETFEM se ocupara de:\n')
fprintf(' - leer los parametros desde el archivo "nombre.txt" que se encuentra en la carpeta "input_UI",\n')
fprintf(' - producir archivos de salida dentro de la carpeta "output_UI".\n\n')
%
name       = input('   Introduzca el nombre del problema:','s') ;

if exist(['input_UI/' name '.txt'],'file')~=2 
  fprintf('\n********* ERROR *********\n')
  fprintf('\nERROR EN EL NOMBRE DE ENTRADA DE DATOS - NO EXISTE EN LA CARPETA "input_UI"\n\n')
  return
end

input_file = [ '../../input_UI/' name '.txt' ] ; 

if exist(['output_UI/'],'dir')~=7
  mkdir(['output_UI/']);
end

if exist(['output_UI/' name],'dir')==7
  fprintf('\n********* ATENCION *********\n\n')
  fprintf('Existe una carpeta dentro de "output_UI" con el nombre del archivo a ejecutar, desea borrarla?\n')
  flag_borrar = input('Por SI puede usar: S, s, Y, y - Por NO puede usar cualquier otra letra:','s') ;
  if flag_borrar == 'Y' || flag_borrar == 'y' || flag_borrar == 'S' || flag_borrar == 's'
      [a] = rmdir(['output_UI/' name]);
      [b] = exist(['output_UI/' name],'dir');
      if a == 0 && b==7
        chdir(['output_UI/' name]);
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
        end
        cd ..
        [a] = rmdir([name]);
      end
      cd ..
  else
    fprintf('\n********* DEBE INTRODUCIR OTRO NOMBRE DE ARCHIVO DE ENTRADA *********\n\n')
  end
end

cd sources
cd source_truss
%
Reading
PreProcess
  %MassPreProcess
BoundaryCond
Process
%ModeProcess
if BAD_COND == 'NO'
  cd ..
  return
end
%ModePosProcess
Text_Output

cd ..
cd ..
