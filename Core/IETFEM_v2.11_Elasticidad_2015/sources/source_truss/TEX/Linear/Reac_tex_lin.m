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
%%%%%%%%%%%%%%%%%%%%%%%%% LINEAR REACTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Archivo en .TEX

fidout_tex = reac_tex_lin;

All_text_format
fprintf( fidout_tex , '%sbegin{document}      \n\n','\')

fprintf( fidout_tex , '%s == Encabezado y pie de pagina ==           \n','%')
fprintf( fidout_tex , '%spagestyle{fancy}                            \n','\')
fprintf( fidout_tex , '%scfoot{}                                     \n','\')
if Lenguage == 1
  fprintf( fidout_tex , '%slhead{Project name}                  \n','\')
  fprintf( fidout_tex , '%slfoot{%sfootnotesize Linear Reaction}      \n','\','\') 
  fprintf( fidout_tex , '%srfoot{Page %sthepage}                        \n','\','\')
elseif Lenguage == 2
  fprintf( fidout_tex , '%slhead{Nombre del proyecto}                  \n','\')
  fprintf( fidout_tex , '%slfoot{%sfootnotesize Reacción Lineal}      \n','\','\') 
  fprintf( fidout_tex , '%srfoot{Pág. %sthepage}                        \n','\','\')
end
fprintf( fidout_tex , '%s ================================           \n\n','%')


fprintf( fidout_tex , '%s ======== Texto ==========  \n\n','%')

fprintf( fidout_tex , '%sbegin{minipage}[t]{1%stextwidth}      \n','\','\')
fprintf( fidout_tex , '%svspace{0.5mm}      \n','\')
fprintf( fidout_tex , '%snoindent      \n','\')
fprintf( fidout_tex , 'Curso de Elasticidad 2014 %s     \n','\\')
fprintf( fidout_tex , 'Ingeniería Civil - Plan 97 %s      \n','\\')
fprintf( fidout_tex , 'Materia: Resistencia de Materiales      \n\n')

fprintf( fidout_tex , '%sbegin{center}      \n','\')
if Lenguage == 1
  fprintf( fidout_tex , '%stextbf{%sLarge{ Input file:}}%sLarge{ %sverb+%s.txt+}  %s      \n','\','\','\','\',name,'\\')
  fprintf( fidout_tex , '%slarge{Project name %s}       \n','\','\\')
elseif Lenguage == 2
  fprintf( fidout_tex , '%stextbf{%sLarge{ Archivo de entrada:}}%sLarge{ %sverb+%s.txt+}  %s      \n','\','\','\','\',name,'\\')
  fprintf( fidout_tex , '%slarge{Nombre del proyecto%s}       \n','\','\\')
end
      
fprintf( fidout_tex , '%stoday%s      \n','\','\\')
fprintf( fidout_tex , 'IETFEM v%s      \n',version)      
fprintf( fidout_tex , '%svspace{-2.9cm}      \n','\')      
fprintf( fidout_tex , '%send{center}      \n','\')      
fprintf( fidout_tex , '%send{minipage}      \n','\')      
fprintf( fidout_tex , '%shspace{-2cm}      \n','\')
fprintf( fidout_tex , '%sbegin{minipage}[t]{.1%stextwidth}      \n','\','\')
fprintf( fidout_tex , '%svspace{0.0mm}      \n','\')
if SD_LD == 1
	fprintf( fidout_tex , '%sincludegraphics[width=.95%stextwidth]{../../../../../../sources/Figs/logo_udelar}      \n','\','\')
else
	fprintf( fidout_tex , '%sincludegraphics[width=.95%stextwidth]{../../../../../../../sources/Figs/logo_udelar}      \n','\','\')
end
fprintf( fidout_tex , '%send{minipage}      \n\n','\')

fprintf( fidout_tex , '%svspace{1cm}       \n\n','\')

fprintf( fidout_tex , '%shspace{1.5cm}       \n','\')
fprintf( fidout_tex , '%sbegin{center}       \n','\')
if SD_LD == 1
	fprintf( fidout_tex , '%sincludegraphics[width=.95%stextwidth]{../../../../../../sources/Figs/logo_ietfem}      \n','\','\')
else
	fprintf( fidout_tex , '%sincludegraphics[width=.95%stextwidth]{../../../../../../../sources/Figs/logo_ietfem}      \n','\','\')
end
fprintf( fidout_tex , '%send{center}       \n','\')
fprintf( fidout_tex , '%svspace{0.5cm}       \n\n','\')

fprintf( fidout_tex , '%s hace índice        \n','%')
fprintf( fidout_tex , '%s%stableofcontents     \n\n','%','\')

if Lenguage == 1
	fprintf( fidout_tex , '================== Linear Reaction IETFEM v%s ===========================%s\n\n\n',version,'\\\\')
	fprintf( fidout_tex , 'Solve time: $%6.3f$ seconds %s\n\n', tiempo ,'\\')
	fprintf( fidout_tex , 'Inputfile: %sverb|%s|  ... %s\n\n','\', input_file ,'\\')
	if SD_LD == 1
    fprintf( fidout_tex , 'Problem type: %s %sD small deformations and displacements%s \n\n',KP,Dim,'\\') 
  else
		fprintf( fidout_tex , 'Problem type: %s %sD large deformations and displacements%s \n\n',KP,Dim,'\\')
  end
	fprintf( fidout_tex , 'Force magnitude: %s %s\n\n ', ForceMagnitude,'\\')
	fprintf( fidout_tex , 'Number of supports: %i %s\n\n', NNodDiriCond,'\\')

elseif Lenguage == 2
	fprintf( fidout_tex , '================== Reacción Lineal IETFEM v%s ===========================%s\n\n\n',version,'\\\\')
	fprintf( fidout_tex , 'Tiempo en resolver: $%6.3f$ seconds %s\n\n', tiempo ,'\\')
	fprintf( fidout_tex , 'Archivo de entrada: %sverb|%s|  ... %s\n\n','\', input_file ,'\\')
	if SD_LD == 1
    fprintf( fidout_tex , 'Tipo de problema: %s %sD pequeñas deformaciones y desplazamientos%s \n\n',KP,Dim,'\\') 
  else
		fprintf( fidout_tex , 'Tipo de problema: %s %sD grandes deformaciones y desplazamientos%s \n\n',KP,Dim,'\\')
  end
  fprintf( fidout_tex , 'Magnitud de fuerza: %s %s\n\n', ForceMagnitude,'\\')
	fprintf( fidout_tex , 'Número de apoyos: %i %s\n\n', NNodDiriCond,'\\')

end

fprintf( fidout_tex , '%snewpage       \n\n','\')		

if Print(1) == 1 && PlotView(2) == 1
	fprintf( fidout_tex , '%sbegin{center}       \n','\')
	fprintf( fidout_tex , '%sincludegraphics[width=.80%stextwidth]{../../%s_%s.png}    \n  ','\','\',name,ind)
	fprintf( fidout_tex , '%send{center}       \n\n','\')
end


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
for i = 1:size(M)(1)                                              % Un for en las filas
	for j = 1:size(M)(2)                                            % Un for en las columnas
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

if Lenguage == 1
    fprintf( fidout_tex , "Support's reactions:                  %s               \n",'\\')
  elseif Lenguage == 2
    fprintf( fidout_tex , 'Reacciones en apoyos:                  %s               \n','\\')
  end

if NDFPN == 1
	if Lenguage == 1
		fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
		fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}\n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , "%smulticolumn{2}{|c|}{Support's reactions (%s)    }  %s  \n",'\',ForceMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $R_x$                  %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , "%smulticolumn{2}{|c|}{Support's reactions (%s)    }  %s  \n",'\',ForceMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $R_x$                  %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendhead                                         \n','\')
		fprintf( fidout_tex , '%shline                                           \n','\')
		fprintf( fidout_tex , '%smulticolumn{2}{r}{Next page...}                 \n','\')
	elseif Lenguage == 2
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
	end
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNodDiriCond
		auxxx = node2dof(ReadingDiriCondMat(node,1),3)(1);
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
	if Lenguage == 1
		fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
		fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , "%smulticolumn{3}{|c|}{Support's reactions (%s)    }  %s  \n",'\',ForceMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $R_x$ & $R_y$          %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , "%smulticolumn{3}{|c|}{Support's reactions (%s)    }  %s  \n",'\',ForceMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $R_x$ & $R_y$          %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendhead                                         \n','\')
		fprintf( fidout_tex , '%shline                                           \n','\')
		fprintf( fidout_tex , '%smulticolumn{3}{r}{Next page...}                 \n','\')
	elseif Lenguage == 2
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
	end
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNodDiriCond
		auxxx = node2dof(ReadingDiriCondMat(node,1),3)(1);
		if R_lineal(auxxx) == 0
			fprintf( fidout_tex , ' %4i & %i ',ReadingDiriCondMat(node,1),R_lineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' %4i & %6.2f ',ReadingDiriCondMat(node,1),R_lineal(auxxx))
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',ReadingDiriCondMat(node,1),R_lineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = node2dof(ReadingDiriCondMat(node,1),3)(2);
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
	if Lenguage == 1
		fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
		fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , "%smulticolumn{4}{|c|}{Support's reactions (%s)    }  %s  \n",'\',ForceMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $R_x$ & $R_y$ & $R_z$  %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , "%smulticolumn{4}{|c|}{Support's reactions (%s)    }  %s  \n",'\',ForceMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $R_x$ & $R_y$ & $R_z$  %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendhead                                         \n','\')
		fprintf( fidout_tex , '%shline                                           \n','\')
		fprintf( fidout_tex , '%smulticolumn{4}{r}{Next page...}                 \n','\')
	elseif Lenguage == 2
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
	end
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNodDiriCond
		auxxx = node2dof(ReadingDiriCondMat(node,1),3)(1);
		if R_lineal(auxxx) == 0
			fprintf( fidout_tex , ' %4i & %i ',ReadingDiriCondMat(node,1),R_lineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' %4i & %6.2f ',ReadingDiriCondMat(node,1),R_lineal(auxxx))
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$  ',ReadingDiriCondMat(node,1),R_lineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = node2dof(ReadingDiriCondMat(node,1),3)(2);
		if R_lineal(auxxx) == 0
			fprintf( fidout_tex , ' & %i ',R_lineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' & %6.2f ',R_lineal(auxxx))
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',R_lineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = node2dof(ReadingDiriCondMat(node,1),3)(3);
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
if Lenguage == 1
	fprintf( fidout_tex , '%scaption{Linear Reaction}             \n','\')
else
	fprintf( fidout_tex , '%scaption{Reacciones Lineales}             \n','\')
end
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')




%%%%%%%% RESORTES


if NNodRobiCond > 0
	fprintf( fidout_tex , '%snewpage                                     \n','\')
  Fuerzas_resortes_x_lin=zeros(NNodRobiCond,1);
  Fuerzas_resortes_y_lin=zeros(NNodRobiCond,1);
  Fuerzas_resortes_z_lin=zeros(NNodRobiCond,1);
  for i=1:NNodRobiCond,
    Fuerzas_resortes_x_lin(i) = -Ulineal(node2dof(RobiCondMat(i,1),3)(1))*RobiCondMat(i,2);
    Fuerzas_resortes_y_lin(i) = -Ulineal(node2dof(RobiCondMat(i,1),3)(2))*RobiCondMat(i,3);
    Fuerzas_resortes_z_lin(i) = -Ulineal(node2dof(RobiCondMat(i,1),3)(3))*RobiCondMat(i,4);
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
  for i = 1:size(M)(1)                                              % Un for en las filas
    for j = 1:size(M)(2)                                            % Un for en las columnas
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
  for i = 1:size(M)(1)                                              % Un for en las filas
    for j = 1:size(M)(2)                                            % Un for en las columnas
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
  for i = 1:size(M)(1)                                              % Un for en las filas
    for j = 1:size(M)(2)                                            % Un for en las columnas
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

  if Lenguage == 1
    fprintf( fidout_tex , "Spring's reactions:                  %s               \n",'\\')
  elseif Lenguage == 2
    fprintf( fidout_tex , 'Reacciones en resortes:                  %s               \n','\\')
  end

  if NDFPN == 1
    if Lenguage == 1
      fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
      fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}\n','\')
      fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
      fprintf( fidout_tex , "%smulticolumn{2}{|c|}{Spring's eactions (%s)   }  %s  \n",'\',ForceMagnitude,'\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , 'Node & $SR_x$                  %s               \n','\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
      fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
      fprintf( fidout_tex , "%smulticolumn{2}{|c|}{Spring's eactions (%s)   }  %s  \n",'\',ForceMagnitude,'\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , 'Node & $SR_x$                  %s               \n','\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , '%sendhead                                         \n','\')
      fprintf( fidout_tex , '%shline                                           \n','\')
      fprintf( fidout_tex , '%smulticolumn{2}{r}{Next page...}                 \n','\')
    elseif Lenguage == 2
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
    end
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
    if Lenguage == 1
      fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
      fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
      fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
      fprintf( fidout_tex , "%smulticolumn{3}{|c|}{Spring's eactions (%s)   }  %s  \n",'\',ForceMagnitude,'\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , 'Node & $SR_x$ & $SR_y$          %s               \n','\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
      fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
      fprintf( fidout_tex , "%smulticolumn{3}{|c|}{Spring's eactions (%s)   }  %s  \n",'\',ForceMagnitude,'\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , 'Node & $SR_x$ & $SR_y$          %s               \n','\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , '%sendhead                                         \n','\')
      fprintf( fidout_tex , '%shline                                           \n','\')
      fprintf( fidout_tex , '%smulticolumn{3}{r}{Next page...}                 \n','\')
    elseif Lenguage == 2
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
    end
    
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
    if Lenguage == 1
      fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
      fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
      fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
      fprintf( fidout_tex , "%smulticolumn{4}{|c|}{Spring's eactions (%s)   }  %s  \n",'\',ForceMagnitude,'\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , 'Node & $SR_x$ & $SR_y$ & $SR_z$  %s               \n','\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
      fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
      fprintf( fidout_tex , "%smulticolumn{4}{|c|}{Spring's eactions (%s)   }  %s  \n",'\',ForceMagnitude,'\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , 'Node & $SR_x$ & $SR_y$ & $SR_z$  %s               \n','\\')
      fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
      fprintf( fidout_tex , '%sendhead                                         \n','\')
      fprintf( fidout_tex , '%shline                                           \n','\')
      fprintf( fidout_tex , '%smulticolumn{4}{r}{Next page...}                 \n','\')
    elseif Lenguage == 2
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
    end
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
  if Lenguage == 1
    fprintf( fidout_tex , "%scaption{Linear spring's reactions}             \n",'\')
  else
    fprintf( fidout_tex , '%scaption{Reacciones lineales en resortes}             \n','\')
  end
  fprintf( fidout_tex , '%send{longtable}                                  \n','\')
  fprintf( fidout_tex , '%send{center}                                     \n\n','\')
end




fprintf( fidout_tex , '%send{document}  \n','\')
fclose(fidout_tex) ;

tiempo_reac_tex_lin = toc ;
tiempo_TEX = tiempo_TEX + tiempo_reac_tex_lin;

