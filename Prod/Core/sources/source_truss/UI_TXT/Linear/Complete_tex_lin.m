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
%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL SD OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Archivo en .TEX

fidout_tex = complete_tex_lin;

All_text_format
fprintf( fidout_tex , '%sbegin{document}      \n\n','\')

fprintf( fidout_tex , '%s == Encabezado y pie de pagina ==           \n','%')
fprintf( fidout_tex , '%spagestyle{fancy}                            \n','\')
fprintf( fidout_tex , '%scfoot{}                                     \n','\')
fprintf( fidout_tex , '%slhead{Nombre del proyecto}                  \n','\')
fprintf( fidout_tex , '%slfoot{%sfootnotesize Salida Completa de Pequeñas Deformaciones y Desplazamientos}      \n','\','\') 
fprintf( fidout_tex , '%srfoot{Pág. %sthepage}                        \n','\','\')
fprintf( fidout_tex , '%s ================================           \n\n','%')


fprintf( fidout_tex , '%s ======== Texto ==========  \n\n','%')

fprintf( fidout_tex , '%sbegin{minipage}[t]{1%stextwidth}      \n','\','\')
fprintf( fidout_tex , '%svspace{0.5mm}      \n','\')
fprintf( fidout_tex , '%snoindent      \n','\')
fprintf( fidout_tex , 'Curso de Elasticidad 2014 %s     \n','\\')
fprintf( fidout_tex , 'Ingeniería Civil - Plan 97 %s      \n','\\')
fprintf( fidout_tex , 'Materia: Resistencia de Materiales      \n\n')

fprintf( fidout_tex , '%sbegin{center}      \n','\')
fprintf( fidout_tex , '%stextbf{%sLarge{ Archivo de entrada:}}%sLarge{ %sverb+%s.txt+}  %s      \n','\','\','\','\',name,'\\')
fprintf( fidout_tex , '%slarge{Nombre del proyecto%s}       \n','\','\\')
      
fprintf( fidout_tex , '%stoday%s      \n','\','\\')
fprintf( fidout_tex , 'IETFEM v%s      \n',version)      
fprintf( fidout_tex , '%svspace{-2.9cm}      \n','\')      
fprintf( fidout_tex , '%send{center}      \n','\')      
fprintf( fidout_tex , '%send{minipage}      \n','\')      
fprintf( fidout_tex , '%shspace{-2cm}      \n','\')
fprintf( fidout_tex , '%sbegin{minipage}[t]{.1%stextwidth}      \n','\','\')
fprintf( fidout_tex , '%svspace{0.0mm}      \n','\')

fprintf( fidout_tex , '%sincludegraphics[width=.95%stextwidth]{../../sources/Figs/logo_udelar}      \n','\','\')
fprintf( fidout_tex , '%send{minipage}      \n\n','\')

fprintf( fidout_tex , '%svspace{1cm}       \n\n','\')

fprintf( fidout_tex , '%shspace{1.5cm}       \n','\')
fprintf( fidout_tex , '%sbegin{center}       \n','\')
fprintf( fidout_tex , '%sincludegraphics[width=.7%stextwidth]{../../sources/Figs/logo_ietfem}      \n','\','\')
fprintf( fidout_tex , '%send{center}       \n','\')

fprintf( fidout_tex , '%snewpage \n\n','\')



fprintf( fidout_tex , '================== Salida Completa IETFEM%s_UI v%s ===========================%s\n','\',version,'\\')
fprintf( fidout_tex , '================== Solución de elasticidad lineal ===========================\n')
fprintf( fidout_tex , '%s hace índice        \n','%')
fprintf( fidout_tex , '%stableofcontents     \n\n','\')



fprintf( fidout_tex , '%snewpage     \n\n','\')


fprintf( fidout_tex , '%ssection{Entrada General} \n\n', '\')
fprintf( fidout_tex , 'Archivo de entrada: %sverb|%s|  ... %s\n\n','\', input_file ,'\\')
fprintf( fidout_tex , 'Tiempo en resolver: $%6.3f$ seconds %s\n\n', tiempo ,'\\')
if SD_LD == 1
  fprintf( fidout_tex , 'Tipo de problema: Reticulados 3D pequeñas deformaciones y desplazamientos%s \n\n','\\') 
else
  fprintf( fidout_tex , 'Tipo de problema: Reticulados 3D grandes deformaciones y desplazamientos%s \n\n','\\')
end
fprintf( fidout_tex , 'Magnitud de longitud: %s %s\n\n', LengthMagnitude,'\\')
fprintf( fidout_tex , 'Magnitud de fuerza: %s %s\n\n', ForceMagnitude,'\\')
fprintf( fidout_tex , 'Número de grados de libertad por nodo: %i %s\n\n', NDFPN,'\\')
fprintf( fidout_tex , 'Número de nodos por elemento: %i %s\n\n', NNodPE,'\\')
fprintf( fidout_tex , 'Número de materiales: %i %s\n\n', NMats,'\\')
fprintf( fidout_tex , 'Número de secciones: %i %s\n\n', NSecs,'\\')
fprintf( fidout_tex , 'Número de nodos: %i %s\n\n', NNod,'\\')
fprintf( fidout_tex , 'Número de elementos: %i %s\n\n', NElem,'\\')




fprintf( fidout_tex , '%snewpage       \n\n','\')		


%%%%%%% COORDENADAS DE LOS NODOS
% Acá se calculan exponentes y demás para la salida
M = abs(NodCoordMat) ;
tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
[fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
for i=1:length(fil)
	NodCoordMat(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
end
G = abs(NodCoordMat) ;                                               % No necesariamente es igual a M
L = floor(G) ;
EXP = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
for i = 1:size(M,1)                                              % Un for en las filas
	for j = 1:size(M,2)                                            % Un for en las columnas
		if NodCoordMat(i,j) ~=0
			while L(i,j) > 0
				G(i,j)=G(i,j)/10;
				L(i,j)=floor(G(i,j)) ;
				EXP(i,j)=EXP(i,j)+1 ;
			end
			while L(i,j) == 0
				G(i,j)=G(i,j)*10;
				L(i,j)=floor(G(i,j)) ;
				EXP(i,j)=EXP(i,j)-1 ;
			end
		end
	end
end

fprintf( fidout_tex , '%ssection{Coordenadas de los nodos} \n\n', '\' )

if NDFPN == 1
  fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
  fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.4cm}|}\n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Coordenadas (%s)    }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $X$                 %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Coordenadas (%s)    }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $X$                 %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendhead                                         \n','\')
  fprintf( fidout_tex , '%shline                                           \n','\')
  fprintf( fidout_tex , '%smulticolumn{2}{r}{Próxima página...}                 \n','\')
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNod
		j=1;
		if NodCoordMat(node,j) == 0
			fprintf( fidout_tex , ' %4i & %i %s \n',node,NodCoordMat(node,j),'\\')
		else
			if EXP(node,j)>=0 && EXP(node,j)<=4
				fprintf( fidout_tex , ' %4i & %12.2e %s \n',node,NodCoordMat(node,j),'\\')
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',node,NodCoordMat(node,j)/10^EXP(node,j),'\','\',EXP(node,j),'\\')
			end
		end
	end
			
elseif NDFPN == 2
  fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
  fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.4cm}|R{2.4cm}|  }\n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Coordenadas (%s)   }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $X$ & $Y$         %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Coordenadas (%s)   }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $X$ & $Y$         %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendhead                                         \n','\')
  fprintf( fidout_tex , '%shline                                           \n','\')
  fprintf( fidout_tex , '%smulticolumn{3}{r}{Próxima página...}                 \n','\')
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNod
		j=1;
		if NodCoordMat(node,j) == 0
			fprintf( fidout_tex , ' %4i & %i ',node,NodCoordMat(node,j))
		else
			if EXP(node,j)>=0 && EXP(node,j)<=4
				fprintf( fidout_tex , ' %4i & %6.2f ',node,NodCoordMat(node,j))
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',node,NodCoordMat(node,j)/10^EXP(node,j),'\','\',EXP(node,j))
			end
		end
		j=2;
		if NodCoordMat(node,j) == 0
			fprintf( fidout_tex , ' & %i %s\n',NodCoordMat(node,j),'\\')
		else
			if EXP(node,j)>=0 && EXP(node,j)<=4
				fprintf( fidout_tex , ' & %6.2f %s \n',NodCoordMat(node,j),'\\')
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',NodCoordMat(node,j)/10^EXP(node,j),'\','\',EXP(node,j),'\\')
			end
		end
	end
	
elseif NDFPN == 3
  fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
  fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.4cm}|R{2.4cm}|R{2.4cm}|}\n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Coordenadas (%s)   }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $X$ & $Y$ & $Z$  %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Coordenadas (%s)   }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $X$ & $Y$ & $Z$  %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendhead                                         \n','\')
  fprintf( fidout_tex , '%shline                                           \n','\')
  fprintf( fidout_tex , '%smulticolumn{4}{r}{Próxima página...}                 \n','\')
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNod
		j=1;
		if NodCoordMat(node,j) == 0
			fprintf( fidout_tex , ' %4i & %i ',node,NodCoordMat(node,j))
		else
			if EXP(node,j)>=0 && EXP(node,j)<=4
				fprintf( fidout_tex , ' %4i & %6.2f ',node,NodCoordMat(node,j))
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',node,NodCoordMat(node,j)/10^EXP(node,j),'\','\',EXP(node,j))
			end
		end
		j=2;
		if NodCoordMat(node,j) == 0
			fprintf( fidout_tex , ' & %i ',NodCoordMat(node,j))
		else
			if EXP(node,j)>=0 && EXP(node,j)<=4
				fprintf( fidout_tex , ' & %6.2f ',NodCoordMat(node,j))
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',NodCoordMat(node,j)/10^EXP(node,j),'\','\',EXP(node,j))
			end
		end
		j=3;
		if NodCoordMat(node,j) == 0
			fprintf( fidout_tex , ' & %i %s \n',NodCoordMat(node,j),'\\')
		else
			if EXP(node,j)>=0 && EXP(node,j)<=4
				fprintf( fidout_tex , ' & %6.2f %s \n',NodCoordMat(node,j),'\\')
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',NodCoordMat(node,j)/10^EXP(node,j),'\','\',EXP(node,j),'\\')
			end
		end
	end
end
fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
fprintf( fidout_tex , '%scaption{Coordenadas de los nodos}             \n','\')
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')

fprintf( fidout_tex , '%snewpage       \n\n','\')		
%%%%%%%%%%%%%%%%%% CONECTIVIDAD

fprintf( fidout_tex , '%ssection{Conectividad de los elementos} \n\n', '\' )
fprintf( fidout_tex , 'Inicial: Nodo inicial - Final: Nodo final.\n' )
fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{1.5cm}|R{1.5cm}|}\n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Conectividad de los elementos    }  %s  \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento & Inicial & Final %s','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Conectividad de los elementos    }  %s  \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento & Inicial & Final %s','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendhead                                         \n','\')
fprintf( fidout_tex , '%shline                                           \n','\')
fprintf( fidout_tex , '%smulticolumn{3}{r}{Próxima página...}                 \n','\')
fprintf( fidout_tex , '%sendfoot                                         \n','\')
fprintf( fidout_tex , '%sendlastfoot                                     \n','\')

for elem = 1:NElem
  fprintf( fidout_tex , ' %4i & %4i & %4i %s\n',elem,ConectMat(elem,1),ConectMat(elem,2),'\\')
end

fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
fprintf( fidout_tex , '%scaption{Conectividad de los elementos }             \n','\')
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')

fprintf( fidout_tex , '%snewpage       \n\n','\')		
%%%%%%%%%%%%%%% Propiedades de los elementos
% Acá se calculan exponentes y demás para la salida
M = abs(Largos) ;
tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
[fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
for i=1:length(fil)
	Largos(fil(i),col(i)) = 0;											                % Hace cero las entradas menores a la toleracia
end
G = abs(Largos) ;                                                 % No necesariamente es igual a M
L = floor(G) ;
EXP1 = zeros(size(L)) ;                                           % Tantos ceros como valores, matriz de exponentes
for i = 1:size(M,1)                                              % Un for en las filas
	for j = 1:size(M,2)                                            % Un for en las columnas
		if Largos(i,j) ~=0
			while L(i,j) > 0
				G(i,j)=G(i,j)/10;
				L(i,j)=floor(G(i,j)) ;
				EXP1(i,j)=EXP1(i,j)+1 ;
			end
			while L(i,j) == 0
				G(i,j)=G(i,j)*10;
				L(i,j)=floor(G(i,j)) ;
				EXP1(i,j)=EXP1(i,j)-1 ;
			end
		end
	end
end
% Acá se calculan exponentes y demás para la salida
M = abs(Areas) ;
tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
[fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
for i=1:length(fil)
	Areas(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
end
G = abs(Areas) ;                                               % No necesariamente es igual a M
L = floor(G) ;
EXP2 = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
for i = 1:size(M,1)                                              % Un for en las filas
	for j = 1:size(M,2)                                            % Un for en las columnas
		if Areas(i,j) ~=0
			while L(i,j) > 0
				G(i,j)=G(i,j)/10;
				L(i,j)=floor(G(i,j)) ;
				EXP2(i,j)=EXP2(i,j)+1 ;
			end
			while L(i,j) == 0
				G(i,j)=G(i,j)*10;
				L(i,j)=floor(G(i,j)) ;
				EXP2(i,j)=EXP2(i,j)-1 ;
			end
		end
	end
end
% Acá se calculan exponentes y demás para la salida
M = abs(Youngs) ;
tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
[fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
for i=1:length(fil)
	Youngs(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
end
G = abs(Youngs) ;                                               % No necesariamente es igual a M
L = floor(G) ;
EXP3 = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
for i = 1:size(M,1)                                              % Un for en las filas
	for j = 1:size(M,2)                                            % Un for en las columnas
		if Youngs(i,j) ~=0
			while L(i,j) > 0
				G(i,j)=G(i,j)/10;
				L(i,j)=floor(G(i,j)) ;
				EXP3(i,j)=EXP3(i,j)+1 ;
			end
			while L(i,j) == 0
				G(i,j)=G(i,j)*10;
				L(i,j)=floor(G(i,j)) ;
				EXP3(i,j)=EXP3(i,j)-1 ;
			end
		end
	end
end
% Acá se calculan exponentes y demás para la salida
M = abs(Temp);
tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
[fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
for i=1:length(fil)
	Temp(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
end
G = abs(Temp) ;                                               % No necesariamente es igual a M
L = floor(G) ;
EXP4 = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
for i = 1:size(M,1)                                              % Un for en las filas
	for j = 1:size(M,2)                                            % Un for en las columnas
		if Temp(i,j) ~=0
			while L(i,j) > 0
				G(i,j)=G(i,j)/10;
				L(i,j)=floor(G(i,j)) ;
				EXP4(i,j)=EXP4(i,j)+1 ;
			end
			while L(i,j) == 0
				G(i,j)=G(i,j)*10;
				L(i,j)=floor(G(i,j)) ;
				EXP4(i,j)=EXP4(i,j)-1 ;
			end
		end
	end
end
% Acá se calculan exponentes y demás para la salida
M = abs(Gammas);
tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
[fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
for i=1:length(fil)
	Gammas(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
end
G = abs(Gammas) ;                                               % No necesariamente es igual a M
L = floor(G) ;
EXP5 = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
for i = 1:size(M,1)                                              % Un for en las filas
	for j = 1:size(M,2)                                            % Un for en las columnas
		if Gammas(i,j) ~=0
			while L(i,j) > 0
				G(i,j)=G(i,j)/10;
				L(i,j)=floor(G(i,j)) ;
				EXP5(i,j)=EXP5(i,j)+1 ;
			end
			while L(i,j) == 0
				G(i,j)=G(i,j)*10;
				L(i,j)=floor(G(i,j)) ;
				EXP5(i,j)=EXP5(i,j)-1 ;
			end
		end
	end
end

fprintf( fidout_tex , '%ssection{Propiedades de los elementos} \n\n', '\' )
fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.4cm}|R{2.4cm}|R{2.4cm}|R{2.4cm}|R{2.4cm}|}\n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{6}{|c|}{Propiedades de los elementos    }  %s  \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento & $L %sleft(%stext{%s}%sright)$ & $A %sleft(%stext{%s}^%stext{2}%sright)$ & $E %sleft(%stext{%s/%s}^%stext{2}%sright)$ & $%stheta %sleft(%stext{%sgrad C}%sright)$ & $%sgamma %sleft(%stext{%s/%s}^%stext{3}%sright)$   %s\n','\','\',LengthMagnitude,'\','\','\',LengthMagnitude,'\','\','\','\',ForceMagnitude,LengthMagnitude,'\','\','\','\','\','\','\','\','\','\',ForceMagnitude,LengthMagnitude,'\','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{6}{|c|}{Propiedades de los elementos    }  %s  \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento & $L %sleft(%stext{%s}%sright)$ & $A %sleft(%stext{%s}^%stext{2}%sright)$ & $E %sleft(%stext{%s/%s}^%stext{2}%sright)$ & $%stheta %sleft(%stext{%sgrad C}%sright)$ & $%sgamma %sleft(%stext{%s/%s}^%stext{3}%sright)$   %s\n','\','\',LengthMagnitude,'\','\','\',LengthMagnitude,'\','\','\','\',ForceMagnitude,LengthMagnitude,'\','\','\','\','\','\','\','\','\','\',ForceMagnitude,LengthMagnitude,'\','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendhead                                         \n','\')
fprintf( fidout_tex , '%shline                                           \n','\')
fprintf( fidout_tex , '%smulticolumn{6}{r}{Próxima página...}                 \n','\')
fprintf( fidout_tex , '%sendfoot                                         \n','\')
fprintf( fidout_tex , '%sendlastfoot                                     \n','\')

for elem = 1:NElem
  if Largos(elem) == 0
    fprintf( fidout_tex , ' %4i & %i ',elem,Largos(elem))
  else
    if EXP1(elem)>=0 && EXP1(elem)<=4
      fprintf( fidout_tex , ' %4i & %6.2f ',elem,Largos(elem))
    else
      fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',elem,Largos(elem)/10^EXP1(elem),'\','\',EXP1(elem))
    end
  end
  if Areas(elem) == 0
    fprintf( fidout_tex , ' & %i ',Areas(elem))
  else
    if EXP2(elem)>=0 && EXP2(elem)<=4
      fprintf( fidout_tex , ' & %6.2f',Areas(elem))
    else
      fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',Areas(elem)/10^EXP2(elem),'\','\',EXP2(elem))
    end
  end
  if Youngs(elem) == 0
    fprintf( fidout_tex , ' & %i ',Youngs(elem))
  else
    if EXP3(elem)>=0 && EXP3(elem)<=4
      fprintf( fidout_tex , ' & %6.2f',Youngs(elem))
    else
      fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',Youngs(elem)/10^EXP3(elem),'\','\',EXP3(elem))
    end
  end
  if Temp(elem) == 0
    fprintf( fidout_tex , ' & %i ',Temp(elem))
  else
    if EXP4(elem)>=0 && EXP4(elem)<=4
      fprintf( fidout_tex , ' & %6.2f',Temp(elem))
    else
      fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',Temp(elem)/10^EXP4(elem),'\','\',EXP4(elem))
    end
  end
  if Gammas(elem) == 0
    fprintf( fidout_tex , ' & %i %s\n',Gammas(elem),'\\')
  else
    if EXP5(elem)>=0 && EXP5(elem)<=4
      fprintf( fidout_tex , ' & %6.2f %s\n',Gammas(elem),'\\')
    else
      fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s\n',Gammas(elem)/10^EXP5(elem),'\','\',EXP5(elem),'\\')
    end
  end
end

fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
fprintf( fidout_tex , '%scaption{Propiedades de los elementos}             \n','\')
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')


fprintf( fidout_tex , '%snewpage   \n\n','\')


%%%%%%%%%%%%%%%% FUERZAS EXTERNAS PUNTUALES APLICADAS

if NNodNeumCond > 0
  fprintf( fidout_tex , '%ssection{Fuerzas puntuales externas}             \n\n','\')
  
  AUX=NeumCondMat;
  % Acá se calculan exponentes y demás para la salida
  M = abs(AUX) ;
  tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
  [fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
  for i=1:length(fil)
    AUX(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
  end
  G = abs(AUX) ;                                               % No necesariamente es igual a M
  L = floor(G) ;
  EXP = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
  for i = 1:size(M,1)                                              % Un for en las filas
    for j = 1:size(M,2)                                            % Un for en las columnas
      if AUX(i,j) ~=0
        while L(i,j) > 0
          G(i,j)=G(i,j)/10;
          L(i,j)=floor(G(i,j)) ;
          EXP(i,j)=EXP(i,j)+1 ;
        end
        while L(i,j) == 0
          G(i,j)=G(i,j)*10;
          L(i,j)=floor(G(i,j)) ;
          EXP(i,j)=EXP(i,j)-1 ;
        end
      end
    end
  end

  if NDFPN == 1
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Fuerzas puntuales externas (%s)    }  %s  \n','\',ForceMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $F_x$                 %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Fuerzas puntuales externas (%s)    }  %s  \n','\',ForceMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $F_x$                 %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{r}{Próxima página...}                 \n','\')
    fprintf( fidout_tex , '%sendfoot                                         \n','\')
    fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
    
    for node = 1:NNodNeumCond
      auxxx = 2;
      if NeumCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' %4i & %i %s \n',NeumCondMat(node,1),NeumCondMat(node,auxxx),'\\')
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' %4i & %6.2f %s \n',NeumCondMat(node,1),NeumCondMat(node,auxxx),'\\')
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',NeumCondMat(node,1),NeumCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx),'\\')
        end
      end
    end
        
  elseif NDFPN == 2
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|  }\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Fuerzas puntuales externas (%s)   }  %s  \n','\',ForceMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $F_x$ & $F_y$         %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Fuerzas puntuales externas (%s)   }  %s  \n','\',ForceMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $F_x$ & $F_y$         %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{r}{Próxima página...}                 \n','\')
		fprintf( fidout_tex , '%sendfoot                                         \n','\')
		fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
    
    for node = 1:NNodNeumCond
      auxxx = 2;
      if NeumCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' %4i & %i ',NeumCondMat(node,1),NeumCondMat(node,auxxx))
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' %4i & %6.2f ',NeumCondMat(node,1),NeumCondMat(node,auxxx))
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',NeumCondMat(node,1),NeumCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx))
        end
      end
      auxxx = 3;
      if NeumCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' & %i %s\n',NeumCondMat(node,auxxx),'\\')
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' & %6.2f %s \n',NeumCondMat(node,auxxx),'\\')
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',NeumCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx),'\\')
        end
      end
    end
    
  elseif NDFPN == 3
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Fuerzas puntuales externas (%s)   }  %s  \n','\',ForceMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $F_x$ & $F_y$ & $F_z$  %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Fuerzas puntuales externas (%s)   }  %s  \n','\',ForceMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $F_x$ & $F_y$ & $F_z$  %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{r}{Próxima página...}                 \n','\')
    fprintf( fidout_tex , '%sendfoot                                         \n','\')
    fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
    
    for node = 1:NNodNeumCond
      auxxx = 2;
      if NeumCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' %4i & %i ',NeumCondMat(node,1),NeumCondMat(node,auxxx))
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' %4i & %6.2f ',NeumCondMat(node,1),NeumCondMat(node,auxxx))
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',NeumCondMat(node,1),NeumCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx))
        end
      end
      auxxx = 3;
      if NeumCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' & %i ',NeumCondMat(node,auxxx))
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' & %6.2f ',NeumCondMat(node,auxxx))
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',NeumCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx))
        end
      end
      auxxx = 4;
      if NeumCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' & %i %s \n',NeumCondMat(node,auxxx),'\\')
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' & %6.2f %s \n',NeumCondMat(node,auxxx),'\\')
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',NeumCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx),'\\')
        end
      end
    end
  end

  fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
  fprintf( fidout_tex , '%scaption{Fuerzas externas puntuales}             \n','\')
  fprintf( fidout_tex , '%send{longtable}                                  \n','\')
  fprintf( fidout_tex , '%send{center}                                     \n\n','\')
  
  fprintf( fidout_tex , '%snewpage                                     \n\n','\')

end


%%%%%%%%%%%%%%%% FUERZAS EXTERNAS DE VOLUMEN

if NEleVolCondDead > 0

  fprintf( fidout_tex , '%ssection{Fuerzas de volumen externas}             \n\n','\')
  AUX=auxVolCondMatDead;
  % Acá se calculan exponentes y demás para la salida
  M = abs(AUX) ;
  tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
  [fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
  for i=1:length(fil)
    AUX(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
  end
  G = abs(AUX) ;                                               % No necesariamente es igual a M
  L = floor(G) ;
  EXP = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
  for i = 1:size(M,1)                                              % Un for en las filas
    for j = 1:size(M,2)                                            % Un for en las columnas
      if AUX(i,j) ~=0
        while L(i,j) > 0
          G(i,j)=G(i,j)/10;
          L(i,j)=floor(G(i,j)) ;
          EXP(i,j)=EXP(i,j)+1 ;
        end
        while L(i,j) == 0
          G(i,j)=G(i,j)*10;
          L(i,j)=floor(G(i,j)) ;
          EXP(i,j)=EXP(i,j)-1 ;
        end
      end
    end
  end

  if NDFPN == 1
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Fuerzas de volumen externas (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $b_x$                 %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Fuerzas de volumen externas (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $b_x$                 %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{r}{Next page...}                 \n','\')
    fprintf( fidout_tex , '%sendfoot                                         \n','\')
    fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
    
    for node = 1:NEleVolCondDead
      auxxx = 2;
      if auxVolCondMatDead(node,auxxx) == 0
        fprintf( fidout_tex , ' %4i & %i %s \n',auxVolCondMatDead(node,1),auxVolCondMatDead(node,auxxx),'\\')
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' %4i & %6.2f %s \n',auxVolCondMatDead(node,1),auxVolCondMatDead(node,auxxx),'\\')
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',auxVolCondMatDead(node,1),auxVolCondMatDead(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx),'\\')
        end
      end
    end
        
  elseif NDFPN == 2
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|  }\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Fuerzas de volumen externas (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $b_x$ & $b_y$         %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Fuerzas de volumen externas (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $b_x$ & $b_y$         %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{r}{Próxima página...}                 \n','\')
    
    for node = 1:NEleVolCondDead
      auxxx = 2;
      if auxVolCondMatDead(node,auxxx) == 0
        fprintf( fidout_tex , ' %4i & %i ',auxVolCondMatDead(node,1),auxVolCondMatDead(node,auxxx))
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' %4i & %6.2f ',auxVolCondMatDead(node,1),auxVolCondMatDead(node,auxxx))
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',auxVolCondMatDead(node,1),auxVolCondMatDead(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx))
        end
      end
      auxxx = 3;
      if auxVolCondMatDead(node,auxxx) == 0
        fprintf( fidout_tex , ' & %i %s\n',auxVolCondMatDead(node,auxxx),'\\')
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' & %6.2f %s \n',auxVolCondMatDead(node,auxxx),'\\')
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',auxVolCondMatDead(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx),'\\')
        end
      end
    end
    
  elseif NDFPN == 3
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Fuerzas de volumen externas (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $b_x$ & $b_y$ & $b_z$  %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Fuerzas de volumen externas (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $b_x$ & $b_y$ & $b_z$  %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{r}{Próxima página...}                 \n','\')
    fprintf( fidout_tex , '%sendfoot                                         \n','\')
    fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
    
    for node = 1:NEleVolCondDead
      auxxx = 2;
      if auxVolCondMatDead(node,auxxx) == 0
        fprintf( fidout_tex , ' %4i & %i ',auxVolCondMatDead(node,1),auxVolCondMatDead(node,auxxx))
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' %4i & %6.2f ',auxVolCondMatDead(node,1),auxVolCondMatDead(node,auxxx))
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',auxVolCondMatDead(node,1),auxVolCondMatDead(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx))
        end
      end
      auxxx = 3;
      if auxVolCondMatDead(node,auxxx) == 0
        fprintf( fidout_tex , ' & %i ',auxVolCondMatDead(node,auxxx))
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' & %6.2f ',auxVolCondMatDead(node,auxxx))
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',auxVolCondMatDead(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx))
        end
      end
      auxxx = 4;
      if auxVolCondMatDead(node,auxxx) == 0
        fprintf( fidout_tex , ' & %i %s \n',auxVolCondMatDead(node,auxxx),'\\')
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' & %6.2f %s \n',auxVolCondMatDead(node,auxxx),'\\')
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',auxVolCondMatDead(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx),'\\')
        end
      end
    end
  end

  fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
  fprintf( fidout_tex , '%scaption{Fuerzas de volumen puntuales}             \n','\')
  fprintf( fidout_tex , '%send{longtable}                                  \n','\')
  fprintf( fidout_tex , '%send{center}                                     \n\n','\')
  
  fprintf( fidout_tex , '%snewpage                                     \n\n','\')

end


%%%%%%%%%%%%%%%% PROPIEDADES DE RESORTES

if NNodRobiCond > 0

  fprintf( fidout_tex , '%ssection{Propiedades de resortes}             \n\n','\')
  AUX=RobiCondMat;
  % Acá se calculan exponentes y demás para la salida
  M = abs(AUX) ;
  tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
  [fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
  for i=1:length(fil)
    AUX(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
  end
  G = abs(AUX) ;                                               % No necesariamente es igual a M
  L = floor(G) ;
  EXP = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
  for i = 1:size(M,1)                                              % Un for en las filas
    for j = 1:size(M,2)                                            % Un for en las columnas
      if AUX(i,j) ~=0
        while L(i,j) > 0
          G(i,j)=G(i,j)/10;
          L(i,j)=floor(G(i,j)) ;
          EXP(i,j)=EXP(i,j)+1 ;
        end
        while L(i,j) == 0
          G(i,j)=G(i,j)*10;
          L(i,j)=floor(G(i,j)) ;
          EXP(i,j)=EXP(i,j)-1 ;
        end
      end
    end
  end

  if NDFPN == 1
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Propiedades de resortes (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $k_x$                 %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Propiedades de resortes (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $k_x$                 %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{r}{Next page...}                 \n','\')
    fprintf( fidout_tex , '%sendfoot                                         \n','\')
    fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
    
    for node = 1:NNodRobiCond
      auxxx = 2;
      if RobiCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' %4i & %i %s \n',RobiCondMat(node,1),RobiCondMat(node,auxxx),'\\')
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' %4i & %6.2f %s \n',RobiCondMat(node,1),RobiCondMat(node,auxxx),'\\')
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',RobiCondMat(node,1),RobiCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx),'\\')
        end
      end
    end
        
  elseif NDFPN == 2
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|  }\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Propiedades de resortes (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $k_x$ & $k_y$         %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Propiedades de resortes (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $k_x$ & $k_y$         %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{r}{Próxima página...}                 \n','\')
    
    for node = 1:NNodRobiCond
      auxxx = 2;
      if RobiCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' %4i & %i ',RobiCondMat(node,1),RobiCondMat(node,auxxx))
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' %4i & %6.2f ',RobiCondMat(node,1),RobiCondMat(node,auxxx))
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',RobiCondMat(node,1),RobiCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx))
        end
      end
      auxxx = 3;
      if RobiCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' & %i %s\n',RobiCondMat(node,auxxx),'\\')
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' & %6.2f %s \n',RobiCondMat(node,auxxx),'\\')
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',RobiCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx),'\\')
        end
      end
    end
    
  elseif NDFPN == 3
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Propiedades de resortes (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $k_x$ & $k_y$ & $k_z$  %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Propiedades de resortes (%s/%s)    }  %s  \n','\',ForceMagnitude,LengthMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $k_x$ & $k_y$ & $k_z$  %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{r}{Próxima página...}                 \n','\')
    fprintf( fidout_tex , '%sendfoot                                         \n','\')
    fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
    
    for node = 1:NNodRobiCond
      auxxx = 2;
      if RobiCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' %4i & %i ',RobiCondMat(node,1),RobiCondMat(node,auxxx))
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' %4i & %6.2f ',RobiCondMat(node,1),RobiCondMat(node,auxxx))
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',RobiCondMat(node,1),RobiCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx))
        end
      end
      auxxx = 3;
      if RobiCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' & %i ',RobiCondMat(node,auxxx))
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' & %6.2f ',RobiCondMat(node,auxxx))
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',RobiCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx))
        end
      end
      auxxx = 4;
      if RobiCondMat(node,auxxx) == 0
        fprintf( fidout_tex , ' & %i %s \n',RobiCondMat(node,auxxx),'\\')
      else
        if EXP(node,auxxx)>=0 && EXP(node,auxxx)<=4
          fprintf( fidout_tex , ' & %6.2f %s \n',RobiCondMat(node,auxxx),'\\')
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',RobiCondMat(node,auxxx)/10^EXP(node,auxxx),'\','\',EXP(node,auxxx),'\\')
        end
      end
    end
  end

  fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
  fprintf( fidout_tex , '%scaption{Propiedades de resortes}             \n','\')
  fprintf( fidout_tex , '%send{longtable}                                  \n','\')
  fprintf( fidout_tex , '%send{center}                                     \n\n','\')
  
  fprintf( fidout_tex , '%snewpage                                     \n\n','\')

end






%%%%%%%%%%%%%%%%%%%% MATRIZ GLOBAL DE LA ESTRUCTURA


fprintf( fidout_tex , '%ssection{Matriz de rigidez global de la estructura}   \n\n','\')

if size(Klineal_total,1)<=8
	K = Klineal_total;
	M = abs(K) ;
	tolzero = 1e-10 ;
	[a,b] = find(M<tolzero) ;
	for i=1:length(a)
		K(a(i),b(i)) = 0;
		M(a(i),b(i)) = inf;
	end

	G=min(min(abs(M))) ;
	L=floor(G) ;
	a =  0 ;

	if L~=0
		while L > 0
			G=G/10 ;
			L=floor(G) ;
			a=a+1 ;
		end
	else
		while L == 0
			G=G*10
			L=floor(G) ;
			a=a-1
		end
	end
	
	

  fprintf( fidout_tex , 'Matriz de rigidez global de la estructura - Unidades: %sleft(%s/%s%srigth).%s   \n\n','\','\',ForceMagnitude,LengthMagnitude,'\\')

	fprintf( fidout_tex , '$$K=%sleft( %sbegin{array}{','\','\')
	 for j=1:length(NeumDF)
		if j<length(NeumDF)
			fprintf( fidout_tex , 'r')
		else
			fprintf( fidout_tex , 'r} \n')
		end
	end
	for i=1:length(NeumDF)
		for j=1:length(NeumDF)
			if j<length(NeumDF)
				fprintf( fidout_tex , '%12.2f &', K(i,j)/10^(a-1))
			else
				fprintf( fidout_tex , '%12.2f %s \n',K(i,j)/10^(a-1),'\\')
			end
		end
	end
	if a == 1
		fprintf( fidout_tex , '%send{array}%sright) $$ \n\n','\','\','\')
	elseif a == 2
		fprintf( fidout_tex , '%send{array}%sright)%stimes 10^{%12i} $$ \n\n','\','\','\')
	else
		fprintf( fidout_tex , '%send{array}%sright)%stimes 10^{%12i} $$ \n\n','\','\','\',a-1)
	end
else
  fprintf( fidout_tex , 'La matriz de rigidez global de la estructura no se muestra debido a que sus dimensiones son mayores que $8%stimes8$.   \n\n','\')
end


if size(Klineal_reducida,1)<=8
	fprintf( fidout_tex , '%snewpage   \n\n','\')
end

fprintf( fidout_tex , '%ssection{Matriz de rigidez reducida de la estructura}   \n\n','\')
if size(Klineal_reducida,1)<=8
	K = Klineal_reducida;
	M = abs(K) ;
	tolzero = 1e-10 ;
	[a,b] = find(M<tolzero) ;
	for i=1:length(a)
		K(a(i),b(i)) = 0;
		M(a(i),b(i)) = inf;
	end

	G=min(min(abs(M))) ;
	L=floor(G) ;
	a =  0 ;

	if L~=0
		while L > 0
			G=G/10 ;
			L=floor(G) ;
			a=a+1 ;
		end
	else
		while L == 0
			G=G*10
			L=floor(G) ;
			a=a-1
		end
	end
	
	

  fprintf( fidout_tex , 'Matriz de rigidez reducida - Unidades: (%s/%s).%s   \n\n',ForceMagnitude,LengthMagnitude,'\\')


	fprintf( fidout_tex , '$$K=%sleft( %sbegin{array}{','\','\')
	 for j=1:length(NeumDF)
		if j<length(NeumDF)
			fprintf( fidout_tex , 'r')
		else
			fprintf( fidout_tex , 'r} \n')
		end
	end
	for i=1:length(NeumDF)
		for j=1:length(NeumDF)
			if j<length(NeumDF)
				fprintf( fidout_tex , '%12.2f &', K(i,j)/10^(a-1))
			else
				fprintf( fidout_tex , '%12.2f %s \n',K(i,j)/10^(a-1),'\\')
			end
		end
	end
	if a == 1
		fprintf( fidout_tex , '%send{array}%sright) $$ \n\n','\','\','\')
	elseif a == 2
		fprintf( fidout_tex , '%send{array}%sright)%stimes 10^{%12i} $$ \n\n','\','\','\')
	else
		fprintf( fidout_tex , '%send{array}%sright)%stimes 10^{%12i} $$ \n\n','\','\','\',a-1)
	end
else
  fprintf( fidout_tex , 'La matriz de rigidez reducida de la estructura no se muestra debido a que es mayor que $8%stimes8$.   \n\n','\')
end

fprintf( fidout_tex , '%snewpage       \n\n','\')

fprintf( fidout_tex , '%ssection{Algunos parámetros internos del cálculo}       \n\n','\')


%%%%%%%%%%%%%%%%%%% LINEAR LENGTH
% Acá se calculan exponentes y demás para la salida
M = abs(largos_lineal) ;
tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
[fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
for i=1:length(fil)
	largos_lineal(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
end
G = abs(largos_lineal) ;                                               % No necesariamente es igual a M
L = floor(G) ;
EXP = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
for i = 1:size(M,1)                                              % Un for en las filas
	for j = 1:size(M,2)                                            % Un for en las columnas
		if largos_lineal(i,j) ~=0
			while L(i,j) > 0
				G(i,j)=G(i,j)/10;
				L(i,j)=floor(G(i,j)) ;
				EXP(i,j)=EXP(i,j)+1 ;
			end
			while L(i,j) == 0
				G(i,j)=G(i,j)*10;
				L(i,j)=floor(G(i,j)) ;
				EXP(i,j)=EXP(i,j)-1 ;
			end
		end
	end
end



fprintf( fidout_tex , 'Largo final con pequeñas deformaciones y desplazamientos:')
fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}\n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Largo final} %s      \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento & $%sell$ (%s) %s\n','\',LengthMagnitude,'\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Largo final} %s      \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento & $%sell$ (%s) %s\n','\',LengthMagnitude,'\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendhead                                         \n','\')
fprintf( fidout_tex , '%shline                                           \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{r}{Próxima página...}                 \n','\')

fprintf( fidout_tex , '%sendfoot                                         \n','\')
fprintf( fidout_tex , '%sendlastfoot                                     \n','\')

for elem = 1:NElem
  fprintf( fidout_tex , ' %4i ',elem)
  if largos_lineal(elem) == 0
    fprintf( fidout_tex , ' & %i %s \n',largos_lineal(elem) ,'\\')
  else
    if EXP(elem)>=0 && EXP(elem)<=4
      fprintf( fidout_tex , ' & %12.2f %s \n',largos_lineal(elem) ,'\\')
    else
      fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',largos_lineal(elem)/10^EXP(elem),'\','\',EXP(elem) ,'\\')
    end
  end
end
fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
fprintf( fidout_tex , '%scaption{Largo final}             \n','\')
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')



fprintf( fidout_tex , '%snewpage       \n\n','\')		

fprintf( fidout_tex , '%ssection{Reacciones en apoyos}\n\n', '\')
% Acá se calculan exponentes y demás para la salida
M = abs(R_lineal) ;
tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
[fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
for i=1:length(fil)
	R_lineal(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
end
G = abs(R_lineal) ;                                               % No necesariamente es igual a M
L = floor(G) ;
EXP = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
for i = 1:size(M,1)                                              % Un for en las filas
	for j = 1:size(M,2)                                            % Un for en las columnas
		if R_lineal(i,j) ~=0
			while L(i,j) > 0
				G(i,j)=G(i,j)/10;
				L(i,j)=floor(G(i,j)) ;
				EXP(i,j)=EXP(i,j)+1 ;
			end
			while L(i,j) == 0
				G(i,j)=G(i,j)*10;
				L(i,j)=floor(G(i,j)) ;
				EXP(i,j)=EXP(i,j)-1 ;
			end
		end
	end
end

fprintf( fidout_tex , 'Reacciones en apoyos:                  %s               \n','\\')

if NDFPN == 1
  fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
  fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}\n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Reacciones en apoyos (%s)    }  %s  \n','\',ForceMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $R_x$                 %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Reacciones en apoyos (%s)    }  %s  \n','\',ForceMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $R_x$                 %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendhead                                         \n','\')
  fprintf( fidout_tex , '%shline                                           \n','\')
  fprintf( fidout_tex , '%smulticolumn{2}{r}{Próxima página...}                 \n','\')
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNodDiriCond
		aux   = node2dof(ReadingDiriCondMat(node,1),3);
		auxxx = aux(1);
		if R_lineal(auxxx) == 0
			fprintf( fidout_tex , ' %4i & %i %s \n',ReadingDiriCondMat(node,1),R_lineal(auxxx),'\\')
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' %4i & %6.2f %s \n',ReadingDiriCondMat(node,1),R_lineal(auxxx),'\\')
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',ReadingDiriCondMat(node,1),R_lineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx),'\\')
			end
		end
	end
			
elseif NDFPN == 2
  fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
  fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|  }\n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Reacciones en apoyos (%s)   }  %s  \n','\',ForceMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $R_x$ & $R_y$         %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Reacciones en apoyos (%s)   }  %s  \n','\',ForceMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $R_x$ & $R_y$         %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendhead                                         \n','\')
  fprintf( fidout_tex , '%shline                                           \n','\')
  fprintf( fidout_tex , '%smulticolumn{3}{r}{Próxima página...}                 \n','\')
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNodDiriCond
		aux   = node2dof(ReadingDiriCondMat(node,1),3);
		auxxx = aux(1);
		if R_lineal(auxxx) == 0
			fprintf( fidout_tex , ' %4i & %i ',ReadingDiriCondMat(node,1),R_lineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' %4i & %6.2f ',ReadingDiriCondMat(node,1),R_lineal(auxxx))
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',ReadingDiriCondMat(node,1),R_lineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		aux   = node2dof(ReadingDiriCondMat(node,1),3);
		auxxx = aux(2);
		if R_lineal(auxxx) == 0
			fprintf( fidout_tex , ' & %i %s\n',R_lineal(auxxx),'\\')
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' & %6.2f %s \n',R_lineal(auxxx),'\\')
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',R_lineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx),'\\')
			end
		end
	end
	
elseif NDFPN == 3
  fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
  fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Reacciones en apoyos (%s)   }  %s  \n','\',ForceMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $R_x$ & $R_y$ & $R_z$  %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Reacciones en apoyos (%s)   }  %s  \n','\',ForceMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $R_x$ & $R_y$ & $R_z$  %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendhead                                         \n','\')
  fprintf( fidout_tex , '%shline                                           \n','\')
  fprintf( fidout_tex , '%smulticolumn{4}{r}{Próxima página...}                 \n','\')
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNodDiriCond
		aux   = node2dof(ReadingDiriCondMat(node,1),3);
		auxxx = aux(1);
		if R_lineal(auxxx) == 0
			fprintf( fidout_tex , ' %4i & %i ',ReadingDiriCondMat(node,1),R_lineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' %4i & %6.2f ',ReadingDiriCondMat(node,1),R_lineal(auxxx))
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',ReadingDiriCondMat(node,1),R_lineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = aux(2);
		if R_lineal(auxxx) == 0
			fprintf( fidout_tex , ' & %i ',R_lineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' & %6.2f ',R_lineal(auxxx))
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',R_lineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = aux(3);
		if R_lineal(auxxx) == 0
			fprintf( fidout_tex , ' & %i %s \n',R_lineal(auxxx),'\\')
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' & %6.2f %s \n',R_lineal(auxxx),'\\')
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',R_lineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx),'\\')
			end
		end
	end
end

fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
fprintf( fidout_tex , '%scaption{Reacciones Lineales}             \n','\')
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')

%%%%%%%% RESORTES


if NNodRobiCond > 0
	fprintf( fidout_tex , '%snewpage       \n\n','\')		
  fprintf( fidout_tex , '%ssection{Reacciones en resortes}\n\n', '\')
  Fuerzas_resortes_x_lin=zeros(NNodRobiCond,1);
  Fuerzas_resortes_y_lin=zeros(NNodRobiCond,1);
  Fuerzas_resortes_z_lin=zeros(NNodRobiCond,1);
  for i=1:NNodRobiCond,
	aux =	node2dof(RobiCondMat(i,1),3);
    Fuerzas_resortes_x_lin(i) = -Ulineal(aux(1))*RobiCondMat(i,2);
    Fuerzas_resortes_y_lin(i) = -Ulineal(aux(2))*RobiCondMat(i,3);
    Fuerzas_resortes_z_lin(i) = -Ulineal(aux(3))*RobiCondMat(i,4);
  end
  % Acá se calculan exponentes y demás para la salida
  M = abs(Fuerzas_resortes_x_lin) ;
  tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
  [fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
  for i=1:length(fil)
    Fuerzas_resortes_x_lin(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
  end
  G = abs(Fuerzas_resortes_x_lin) ;                                               % No necesariamente es igual a M
  L = floor(G) ;
  EXP1 = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
  for i = 1:size(M,1)                                              % Un for en las filas
    for j = 1:size(M,2)                                            % Un for en las columnas
      if Fuerzas_resortes_x_lin(i,j) ~=0
        while L(i,j) > 0
          G(i,j)=G(i,j)/10;
          L(i,j)=floor(G(i,j)) ;
          EXP1(i,j)=EXP1(i,j)+1 ;
        end
        while L(i,j) == 0
          G(i,j)=G(i,j)*10;
          L(i,j)=floor(G(i,j)) ;
          EXP1(i,j)=EXP1(i,j)-1 ;
        end
      end
    end
  end
  
  % Acá se calculan exponentes y demás para la salida
  M = abs(Fuerzas_resortes_y_lin) ;
  tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
  [fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
  for i=1:length(fil)
    Fuerzas_resortes_y_lin(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
  end
  G = abs(Fuerzas_resortes_y_lin) ;                                               % No necesariamente es igual a M
  L = floor(G) ;
  EXP2 = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
  for i = 1:size(M,1)                                              % Un for en las filas
    for j = 1:size(M,2)                                            % Un for en las columnas
      if Fuerzas_resortes_y_lin(i,j) ~=0
        while L(i,j) > 0
          G(i,j)=G(i,j)/10;
          L(i,j)=floor(G(i,j)) ;
          EXP2(i,j)=EXP2(i,j)+1 ;
        end
        while L(i,j) == 0
          G(i,j)=G(i,j)*10;
          L(i,j)=floor(G(i,j)) ;
          EXP2(i,j)=EXP2(i,j)-1 ;
        end
      end
    end
  end
  
   % Acá se calculan exponentes y demás para la salida
  M = abs(Fuerzas_resortes_z_lin) ;
  tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
  [fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
  for i=1:length(fil)
    Fuerzas_resortes_z_lin(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
  end
  G = abs(Fuerzas_resortes_z_lin) ;                                               % No necesariamente es igual a M
  L = floor(G) ;
  EXP3 = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
  for i = 1:size(M,1)                                              % Un for en las filas
    for j = 1:size(M,2)                                            % Un for en las columnas
      if Fuerzas_resortes_z_lin(i,j) ~=0
        while L(i,j) > 0
          G(i,j)=G(i,j)/10;
          L(i,j)=floor(G(i,j)) ;
          EXP3(i,j)=EXP3(i,j)+1 ;
        end
        while L(i,j) == 0
          G(i,j)=G(i,j)*10;
          L(i,j)=floor(G(i,j)) ;
          EXP3(i,j)=EXP3(i,j)-1 ;
        end
      end
    end
  end
  fprintf( fidout_tex , 'Reacciones en resortes:                  %s               \n','\\')

  if NDFPN == 1
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Reacciones en resortes (%s)   }  %s  \n','\',ForceMagnitude,paso,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $RR_x$                 %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Reacciones en resortes (%s)   }  %s  \n','\',ForceMagnitude,paso,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $RFR_x$                 %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{2}{r}{Próxima página...}                 \n','\')
    fprintf( fidout_tex , '%sendfoot                                         \n','\')
    fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
    
    for node = 1:NNodRobiCond
      if Fuerzas_resortes_x_lin(node) == 0
        fprintf( fidout_tex , ' %4i & %i %s\n',RobiCondMat(node,1),Fuerzas_resortes_x_lin(node),'\\')
      else
        if EXP1(auxxx)>=0 && EXP1(auxxx)<=4
          fprintf( fidout_tex , ' %4i & %6.2f %s \n',RobiCondMat(node,1),Fuerzas_resortes_x_lin(node),'\\')
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',RobiCondMat(node,1),Fuerzas_resortes_x_lin(node)/10^EXP1(auxxx),'\','\',EXP1(node),'\\')
        end
      end
    end
        
  elseif NDFPN == 2
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|  }\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Reacciones en resortes (%s)   }  %s  \n','\',ForceMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $RR_x$ & $RR_y$         %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Reacciones en resortes (%s)   }  %s  \n','\',ForceMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $RR_x$ & $RR_y$         %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{3}{r}{Próxima página...}                 \n','\')
    
    for node = 1:NNodRobiCond
      if Fuerzas_resortes_x_lin(node) == 0
        fprintf( fidout_tex , ' %4i & %i ',RobiCondMat(node,1),Fuerzas_resortes_x_lin(node))
      else
        if EXP1(node)>=0 && EXP1(node)<=4
          fprintf( fidout_tex , ' %4i & %6.2f ',RobiCondMat(node,1),Fuerzas_resortes_x_lin(node))
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',RobiCondMat(node,1),Fuerzas_resortes_x_lin(node)/10^EXP1(node),'\','\',EXP1(node))
        end
      end
      if Fuerzas_resortes_y_lin(node) == 0
        fprintf( fidout_tex , ' & %i %s\n',Fuerzas_resortes_y_lin(node),'\\')
      else
        if EXP2(node)>=0 && EXP2(node)<=4
          fprintf( fidout_tex , ' & %6.2f %s \n',Fuerzas_resortes_y_lin(node),'\\')
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',Fuerzas_resortes_y_lin(node)/10^EXP2(node),'\','\',EXP2(node),'\\')
        end
      end
    end
    
  elseif NDFPN == 3
    fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
    fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Reacciones en resortes (%s)   }  %s  \n','\',ForceMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodo & $RR_x$ & $RR_y$ & $RR_z$  %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
    fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Reacciones en resortes (%s)   }  %s  \n','\',ForceMagnitude,'\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , 'Nodoo & $RR_x$ & $RR_y$ & $RR_z$  %s               \n','\\')
    fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
    fprintf( fidout_tex , '%sendhead                                         \n','\')
    fprintf( fidout_tex , '%shline                                           \n','\')
    fprintf( fidout_tex , '%smulticolumn{4}{r}{Próxima página...}                 \n','\')
    fprintf( fidout_tex , '%sendfoot                                         \n','\')
    fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
    
    for node = 1:NNodRobiCond
      if Fuerzas_resortes_x_lin(node) == 0
        fprintf( fidout_tex , ' %4i & %i ',RobiCondMat(node,1),Fuerzas_resortes_x_lin(node))
      else
        if EXP1(node)>=0 && EXP1(node)<=4
          fprintf( fidout_tex , ' %4i & %6.2f ',RobiCondMat(node,1),Fuerzas_resortes_x_lin(node))
        else
          fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',RobiCondMat(node,1),Fuerzas_resortes_x_lin(node)/10^EXP1(node),'\','\',EXP1(node))
        end
      end
      if Fuerzas_resortes_y_lin(node) == 0
        fprintf( fidout_tex , ' & %i ',Fuerzas_resortes_y_lin(node))
      else
        if EXP2(node)>=0 && EXP2(node)<=4
          fprintf( fidout_tex , ' & %6.2f',Fuerzas_resortes_y_lin(node))
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',Fuerzas_resortes_y_lin(node)/10^EXP2(node),'\','\',EXP2(node))
        end
      end
      if Fuerzas_resortes_z_lin(node) == 0
        fprintf( fidout_tex , ' & %i %s\n',Fuerzas_resortes_z_lin(node),'\\')
      else
        if EXP3(node)>=0 && EXP3(node)<=4
          fprintf( fidout_tex , ' & %6.2f %s \n',Fuerzas_resortes_z_lin(node),'\\')
        else
          fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',Fuerzas_resortes_z_lin(node)/10^EXP3(node),'\','\',EXP3(node),'\\')
        end
      end
    end
  end

  fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
  fprintf( fidout_tex , '%scaption{Reacciones lineales en resortes}             \n','\')
  fprintf( fidout_tex , '%send{longtable}                                  \n','\')
  fprintf( fidout_tex , '%send{center}                                     \n\n','\')
end


fprintf( fidout_tex , '%snewpage       \n\n','\')		
fprintf( fidout_tex , '%ssection{Desplazamientos nodales}\n\n', '\')
% Acá se calculan exponentes y demás para la salida
M = abs(Ulineal) ;
tolzero = 1e-10 ; 																								% toleracia arbitraria OJO
[fil,col] = find(M<tolzero) ; 																		% filas y columnas que indican entradas menores a la toleracia
for i=1:length(fil)
	Ulineal(fil(i),col(i)) = 0;											              % Hace cero las entradas menores a la toleracia
end
G = abs(Ulineal) ;                                               % No necesariamente es igual a M
L = floor(G) ;
EXP = zeros(size(L)) ;                                            % Tantos ceros como valores, matriz de exponentes
for i = 1:size(M,1)                                              % Un for en las filas
	for j = 1:size(M,2)                                            % Un for en las columnas
		if Ulineal(i,j) ~=0
			while L(i,j) > 0
				G(i,j)=G(i,j)/10;
				L(i,j)=floor(G(i,j)) ;
				EXP(i,j)=EXP(i,j)+1 ;
			end
			while L(i,j) == 0
				G(i,j)=G(i,j)*10;
				L(i,j)=floor(G(i,j)) ;
				EXP(i,j)=EXP(i,j)-1 ;
			end
		end
	end
end

if NDFPN == 1
  fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
  fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}\n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Desplazamientos (%s)    }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $u$                 %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Desplazamientos (%s)    }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $u$                 %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendhead                                         \n','\')
  fprintf( fidout_tex , '%shline                                           \n','\')
  fprintf( fidout_tex , '%smulticolumn{2}{r}{Próxima página...}                 \n','\')
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNod
		aux   = node2dof(node,3);
		auxxx = aux(1);
		if Ulineal(auxxx) == 0
			fprintf( fidout_tex , ' %4i & %i %s \n',node,Ulineal(auxxx),'\\')
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' %4i & %6.2f %s \n',node,Ulineal(auxxx),'\\')
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',node,Ulineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx),'\\')
			end
		end
	end
			
elseif NDFPN == 2
  fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
  fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|  }\n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Desplazamientos (%s)   }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $u$ & $v$         %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Desplazamientos (%s)   }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $u$ & $v$         %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendhead                                         \n','\')
  fprintf( fidout_tex , '%shline                                           \n','\')
  fprintf( fidout_tex , '%smulticolumn{3}{r}{Próxima página...}                 \n','\')
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNod
		aux   = node2dof(node,3);
		auxxx = aux(1);
		if Ulineal(auxxx) == 0
			fprintf( fidout_tex , ' %4i & %i ',node,Ulineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' %4i & %6.2f ',node,Ulineal(auxxx))
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',node,Ulineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = aux(2);
		if Ulineal(auxxx) == 0
			fprintf( fidout_tex , ' & %i %s \n',Ulineal(auxxx),'\\')
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' & %6.2f %s \n',Ulineal(auxxx),'\\')
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',Ulineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx),'\\')
			end
		end
	end
elseif NDFPN == 3
  fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
  fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Desplazamientos (%s)   }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $u$ & $v$ & $w$  %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
  fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
  fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Desplazamientos (%s)   }  %s  \n','\',LengthMagnitude,'\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , 'Nodo & $u$ & $v$ & $w$  %s               \n','\\')
  fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
  fprintf( fidout_tex , '%sendhead                                         \n','\')
  fprintf( fidout_tex , '%shline                                           \n','\')
  fprintf( fidout_tex , '%smulticolumn{4}{r}{Próxima página...}                 \n','\')
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNod
		aux   = node2dof(node,3);
		auxxx = aux(1);
		if Ulineal(auxxx) == 0
			fprintf( fidout_tex , ' %4i & %i ',node,Ulineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' %4i & %6.2f ',node,Ulineal(auxxx))
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',node,Ulineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = aux(2);
		if Ulineal(auxxx) == 0
			fprintf( fidout_tex , ' & %i ',Ulineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' & %6.2f ',Ulineal(auxxx))
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',Ulineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = aux(3);
		if Ulineal(auxxx) == 0
			fprintf( fidout_tex , ' & %i %s \n',Ulineal(auxxx),'\\')
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' & %6.2f %s \n',Ulineal(auxxx),'\\')
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ %s \n',Ulineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx),'\\')
			end
		end
	end
end

fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
fprintf( fidout_tex , '%scaption{Desplazamiento Lineal}             \n','\')
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')

fprintf( fidout_tex , '%snewpage       \n\n','\')		
fprintf( fidout_tex , '%ssection{Fuerza axial}\n\n', '\')

fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}                      \n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Fuerza Axial Lineal} %s      \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento   &   Fuerza (%s)                  %s         \n',ForceMagnitude,'\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Fuerza Axial Lineal} %s      \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento   &   Fuerza (%s)                  %s         \n',ForceMagnitude,'\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendhead                                         \n','\')
fprintf( fidout_tex , '%shline                                           \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{r}{Próxima página...}                 \n','\')
fprintf( fidout_tex , '%sendfoot                                         \n','\')
fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
M = abs(N_lineal) ;
tolzero = 1e-10 ;
[a,b] = find(M<tolzero) ;
for i=1:length(a)
	N_lineal(a(i),b(i)) = 0;
end
for i=1:NElem,
	G=abs(N_lineal(i)) ;
	L=floor(G) ;
	a =  [0] ;
	if N_lineal(i) ~=0
		if L(1)~=0
			while L(1) > 0
				G(1)=G(1)/10;
				L(1)=floor(G(1)) ;
				a(1)=a(1)+1 ;
			end
		else
			while L(1) == 0
				G(1)=G(1)*10;
				L(1)=floor(G(1)) ;
				a(1)=a(1)-1 ;
			end
		end
	end
	for l=1:1
		if a(l)>0
			a(l)=a(l)-1;
		end
	end
  if N_lineal(i) == min(N_lineal);
    if a(1)>=0 && a(1)<=4
      fprintf( fidout_tex , ' {%scolor{red}%4i} & {%scolor{red}%12.2f} %s\n','\',i,'\',N_lineal(i),'\\' )
    else
      fprintf( fidout_tex , ' {%scolor{red}%4i} & {%scolor{red}%12.2f $%stimes 10^{%12i}}$ %s\n','\',i,'\',N_lineal(i)/10^a(1),'\',a(1),'\\' )
    end
  elseif N_lineal(i) == max(N_lineal);
    if a(1)>=0 && a(1)<=4
      fprintf( fidout_tex , ' {%scolor{OliveGreen}%4i} & {%scolor{OliveGreen}%12.2f} %s\n','\',i,'\',N_lineal(i),'\\' )
    else
      fprintf( fidout_tex , ' {%scolor{OliveGreen}%4i} & {%scolor{OliveGreen}%12.2f $%stimes 10^{%12i}}$ %s\n','\',i,'\',N_lineal(i)/10^a(1),'\',a(1),'\\' )
    end
  else
    if a(1)>=0 && a(1)<=4
      fprintf( fidout_tex , ' %4i & %12.2f %s\n',i,N_lineal(i),'\\' )
    else
      fprintf( fidout_tex , ' %4i & %12.2f $%stimes 10^{%12i}$ %s\n',i,N_lineal(i)/10^a(1),'\',a(1),'\\' )
    end
  end
end
fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
fprintf( fidout_tex , '%scaption{Fuerza Axial Lineal}             \n','\')
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')


fprintf( fidout_tex , '%snewpage       \n\n','\')		
fprintf( fidout_tex , '%ssection{Tensiones}\n\n', '\')

fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}                      \n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Tensión lineal} %s      \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento   &   Tensión (%s/%s$^%stext{2}$)                  %s         \n',ForceMagnitude,LengthMagnitude,'\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Tensión lineal} %s      \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento   &   Tensión (%s/%s$^%stext{2}$)                  %s         \n',ForceMagnitude,LengthMagnitude,'\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendhead                                         \n','\')
fprintf( fidout_tex , '%shline                                           \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{r}{Próxima página...}                 \n','\')
fprintf( fidout_tex , '%sendfoot                                         \n','\')
fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
M = abs(Sigma_lin) ;
tolzero = 1e-10 ;
[a,b] = find(M<tolzero) ;
for i=1:length(a)
	Sigma_lin(a(i),b(i)) = 0;
end
for i=1:NElem,
	G=abs(Sigma_lin(i)) ;
	L=floor(G) ;
	a =  [0] ;
	if Sigma_lin(i) ~=0
		if L(1)~=0
			while L(1) > 0
				G(1)=G(1)/10;
				L(1)=floor(G(1)) ;
				a(1)=a(1)+1 ;
			end
		else
			while L(1) == 0
				G(1)=G(1)*10;
				L(1)=floor(G(1)) ;
				a(1)=a(1)-1 ;
			end
		end
	end
	for l=1:1
		if a(l)>0
			a(l)=a(l)-1;
		end
	end
  if Sigma_lin(i) == min(Sigma_lin);
    if a(1)>=0 && a(1)<=4
      fprintf( fidout_tex , ' {%scolor{red}%4i} & {%scolor{red}%12.2f} %s\n','\',i,'\',Sigma_lin(i),'\\' )
    else
      fprintf( fidout_tex , ' {%scolor{red}%4i} & {%scolor{red}%12.2f $%stimes 10^{%12i}$}%s\n','\',i,'\',Sigma_lin(i)/10^a(1),'\',a(1),'\\' )
    end
  elseif Sigma_lin(i) == max(Sigma_lin);
    if a(1)>=0 && a(1)<=4
      fprintf( fidout_tex , ' {%scolor{OliveGreen}%4i} & {%scolor{OliveGreen}%12.2f} %s\n','\',i,'\',Sigma_lin(i),'\\' )
    else
      fprintf( fidout_tex , ' {%scolor{OliveGreen}%4i} & {%scolor{OliveGreen}%12.2f $%stimes 10^{%12i}$} %s\n','\',i,'\',Sigma_lin(i)/10^a(1),'\',a(1),'\\' )
    end
  else
    if a(1)>=0 && a(1)<=4
      fprintf( fidout_tex , ' %4i & %12.2f %s\n',i,Sigma_lin(i),'\\' )
    else
      fprintf( fidout_tex , ' %4i & %12.2f $%stimes 10^{%12i}$ %s\n',i,Sigma_lin(i)/10^a(1),'\',a(1),'\\' )
    end
  end
end
fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
fprintf( fidout_tex , '%scaption{Tensión Lineal}             \n','\')
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')


fprintf( fidout_tex , '%snewpage       \n\n','\')		
fprintf( fidout_tex , '%ssection{Deformaciones}\n\n', '\')



fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}                      \n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Deformación Lineal} %s      \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento   &   Deformación              %s        \n','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Deformación Lineal} %s      \n','\','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , 'Elemento   &   Deformación             %s         \n','\\')
fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
fprintf( fidout_tex , '%sendhead                                         \n','\')
fprintf( fidout_tex , '%shline                                           \n','\')
fprintf( fidout_tex , '%smulticolumn{2}{r}{Próxima página...}                 \n','\')
fprintf( fidout_tex , '%sendfoot                                         \n','\')
fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
M = abs(EPS_lineal) ;
tolzero = 1e-10 ;
[a,b] = find(M<tolzero) ;
for i=1:length(a)
	EPS_lineal(a(i),b(i)) = 0;
end
for i=1:NElem,
	G=abs(EPS_lineal(i)) ;
	L=floor(G) ;
	a =  [0] ;
	if EPS_lineal(i) ~=0
		if L(1)~=0
			while L(1) > 0
				G(1)=G(1)/10;
				L(1)=floor(G(1)) ;
				a(1)=a(1)+1 ;
			end
		else
			while L(1) == 0
				G(1)=G(1)*10;
				L(1)=floor(G(1)) ;
				a(1)=a(1)-1 ;
			end
		end
	end
	for l=1:1
		if a(l)>0
			a(l)=a(l)-1;
		end
	end
	if EPS_lineal(i) == min(EPS_lineal);
    if a(1)>=0 && a(1)<=4
      fprintf( fidout_tex , ' {%scolor{red}%4i} & {%scolor{red}%12.2f} %s\n','\',i,'\',EPS_lineal(i),'\\' )
    else
      fprintf( fidout_tex , ' {%scolor{red}%4i} & {%scolor{red}%12.2f $%stimes 10^{%12i}$} %s\n','\',i,'\',EPS_lineal(i)/10^a(1),'\',a(1),'\\' )
    end
  elseif EPS_lineal(i) == max(EPS_lineal);
    if a(1)>=0 && a(1)<=4
      fprintf( fidout_tex , ' {%scolor{OliveGreen}%4i} & {%scolor{OliveGreen}%12.2f} %s\n','\',i,'\',EPS_lineal(i),'\\' )
    else
      fprintf( fidout_tex , ' {%scolor{OliveGreen}%4i} & {%scolor{OliveGreen}%12.2f $%stimes 10^{%12i}$} %s\n','\',i,'\',EPS_lineal(i)/10^a(1),'\',a(1),'\\' )
    end
  else
    if a(1)>=0 && a(1)<=4
      fprintf( fidout_tex , ' %4i & %12.2f %s\n',i,EPS_lineal(i),'\\' )
    else
      fprintf( fidout_tex , ' %4i & %12.2f $%stimes 10^{%12i}$ %s\n',i,EPS_lineal(i)/10^a(1),'\',a(1),'\\' )
    end
  end
end
fprintf( fidout_tex , '%sbottomrule[0.8mm]                               \n','\')
fprintf( fidout_tex , '%scaption{Deformación Lineal}             \n','\')
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')

fprintf( fidout_tex , '%snewpage  \n','\')
fprintf( fidout_tex , '%slistoftables  \n','\')

fprintf( fidout_tex , '%send{document}  \n','\')
fclose(fidout_tex) ;



