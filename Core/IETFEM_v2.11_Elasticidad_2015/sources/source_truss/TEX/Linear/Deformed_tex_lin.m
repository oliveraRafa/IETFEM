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
%%%%%%%%%%%%%%%%%%%%%%%%% LINEAR DISPLACEMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Archivo en .TEX

fidout_tex = deformed_tex_lin;

All_text_format
fprintf( fidout_tex , '%sbegin{document}      \n\n','\')

fprintf( fidout_tex , '%s == Encabezado y pie de pagina ==           \n','%')
fprintf( fidout_tex , '%spagestyle{fancy}                            \n','\')
fprintf( fidout_tex , '%scfoot{}                                     \n','\')
if Lenguage == 1
  fprintf( fidout_tex , '%slhead{Project name}                  \n','\')
  fprintf( fidout_tex , '%slfoot{%sfootnotesize Linear Displacement}      \n','\','\') 
  fprintf( fidout_tex , '%srfoot{Page %sthepage}                        \n','\','\')
elseif Lenguage == 2
  fprintf( fidout_tex , '%slhead{Nombre del proyecto}                  \n','\')
  fprintf( fidout_tex , '%slfoot{%sfootnotesize Desplazamiento Lineal}      \n','\','\') 
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
	fprintf( fidout_tex , '================== Linear Displacement IETFEM v%s ===========================%s\n\n\n',version,'\\')
	fprintf( fidout_tex , 'Solve time: $%6.3f$ seconds %s\n\n', tiempo ,'\\')
	fprintf( fidout_tex , 'Inputfile: %sverb|%s|  ... %s\n\n','\', input_file ,'\\')
	if SD_LD == 1
    fprintf( fidout_tex , 'Problem type: %s %sD small deformations and displacements%s \n\n',KP,Dim,'\\') 
  else
		fprintf( fidout_tex , 'Problem type: %s %sD large deformations and displacements%s \n\n',KP,Dim,'\\')
  end
	fprintf( fidout_tex , 'Length Magnitude: %s %s\n\n', LengthMagnitude,'\\')
	fprintf( fidout_tex , 'Number of nodes: %i %s\n\n', NNod,'\\')

elseif Lenguage == 2
	fprintf( fidout_tex , '================== Desplazamiento Lineal IETFEM v%s ===========================%s\n\n\n',version,'\\')
	fprintf( fidout_tex , 'Tiempo en resolver: $%6.3f$ seconds %s\n\n', tiempo ,'\\')
	fprintf( fidout_tex , 'Archivo de entrada: %sverb|%s|  ... %s\n\n','\', input_file ,'\\')
	if SD_LD == 1
    fprintf( fidout_tex , 'Tipo de problema: %s %sD pequeñas deformaciones y desplazamientos%s \n\n',KP,Dim,'\\') 
  else
		fprintf( fidout_tex , 'Tipo de problema: %s %sD grandes deformaciones y desplazamientos%s \n\n',KP,Dim,'\\')
  end
  fprintf( fidout_tex , 'Magnitud de longitud: %s %s\n\n', LengthMagnitude,'\\')
	fprintf( fidout_tex , 'Número de nodos: %i %s\n\n', NNod,'\\')

end

fprintf( fidout_tex , '%snewpage       \n\n','\')		

if Print(1) == 1 && PlotView(2) == 1
	fprintf( fidout_tex , '%sbegin{center}       \n','\')
	fprintf( fidout_tex , '%sincludegraphics[width=.80%stextwidth]{../../%s_%s.png}    \n  ','\','\',name,ind)
	fprintf( fidout_tex , '%send{center}       \n\n','\')
end

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
for i = 1:size(M)(1)                                              % Un for en las filas
	for j = 1:size(M)(2)                                            % Un for en las columnas
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
	if Lenguage == 1
		fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
		fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}\n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Displacements (%s)    }  %s  \n','\',LengthMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $u$                  %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Displacements (%s)    }  %s  \n','\',LengthMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $u$                  %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendhead                                         \n','\')
		fprintf( fidout_tex , '%shline                                           \n','\')
		fprintf( fidout_tex , '%smulticolumn{2}{r}{Next page...}                 \n','\')
	elseif Lenguage == 2
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
	end
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNod
		auxxx = node2dof(node,3)(1);
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
	if Lenguage == 1
		fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
		fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Displacements (%s)   }  %s  \n','\',LengthMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $u$ & $v$          %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , '%smulticolumn{3}{|c|}{Displacements (%s)   }  %s  \n','\',LengthMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $u$ & $v$          %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendhead                                         \n','\')
		fprintf( fidout_tex , '%shline                                           \n','\')
		fprintf( fidout_tex , '%smulticolumn{3}{r}{Next page...}                 \n','\')
	elseif Lenguage == 2
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
	end
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNod
		auxxx = node2dof(node,3)(1);
		if Ulineal(auxxx) == 0
			fprintf( fidout_tex , ' %4i & %i ',node,Ulineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' %4i & %6.2f ',node,Ulineal(auxxx))
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',node,Ulineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = node2dof(node,3)(2);
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
	if Lenguage == 1
		fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
		fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|R{2.5cm}|R{2.5cm}|}\n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Displacements (%s)   }  %s  \n','\',LengthMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $u$ & $v$ & $w$  %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
		fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
		fprintf( fidout_tex , '%smulticolumn{4}{|c|}{Displacements (%s)   }  %s  \n','\',LengthMagnitude,'\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , 'Node & $u$ & $v$ & $w$  %s               \n','\\')
		fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
		fprintf( fidout_tex , '%sendhead                                         \n','\')
		fprintf( fidout_tex , '%shline                                           \n','\')
		fprintf( fidout_tex , '%smulticolumn{4}{r}{Next page...}                 \n','\')
	elseif Lenguage == 2
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
	end
	fprintf( fidout_tex , '%sendfoot                                         \n','\')
	fprintf( fidout_tex , '%sendlastfoot                                     \n','\')
	
	for node = 1:NNod
		auxxx = node2dof(node,3)(1);
		if Ulineal(auxxx) == 0
			fprintf( fidout_tex , ' %4i & %i ',node,Ulineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' %4i & %6.2f ',node,Ulineal(auxxx))
			else
				fprintf( fidout_tex , ' %4i & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',node,Ulineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = node2dof(node,3)(2);
		if Ulineal(auxxx) == 0
			fprintf( fidout_tex , ' & %i ',Ulineal(auxxx))
		else
			if EXP(auxxx)>=0 && EXP(auxxx)<=4
				fprintf( fidout_tex , ' & %6.2f ',Ulineal(auxxx))
			else
				fprintf( fidout_tex , ' & %12.2f $%stimes$ 10$^{%stext{%12i}}$ ',Ulineal(auxxx)/10^EXP(auxxx),'\','\',EXP(auxxx))
			end
		end
		auxxx = node2dof(node,3)(3);
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
if Lenguage == 1
	fprintf( fidout_tex , '%scaption{Linear Displacement}             \n','\')
else
	fprintf( fidout_tex , '%scaption{Desplazamiento Lineal}             \n','\')
end
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')

fprintf( fidout_tex , '%snewpage       \n\n','\')


if Print(2) == 1
	if Lenguage == 1
		a = 'Images for linear elasticity';
		b = 'Video for linear elasticity';
	else
		a = 'Imagenes para elasticidad lineal';
		b = 'Video para elasticidad lineal';
	end
	fprintf( fidout_tex , '%snewpage       \n','\')
	fprintf( fidout_tex , '%sbegin{center}       \n','\')
	if Dimensions == 3
		fprintf( fidout_tex , '%s - AZIMUTH: $%6.2f$%sgrad and ELEVATION: $%6.2f$%sgrad\n\n',a,TresD_View(5),'\',TresD_View(6),'\')
	else
		fprintf( fidout_tex , '%s \n\n',a)
	end
	fprintf( fidout_tex , '%sincludegraphics[width=.80%stextwidth]{../%s_%s_%s.png}      \n\n','\','\',name,def,num2str(HowManySD(1)))
	if HowManySD(1) > 1
		if Dimensions == 3
			fprintf( fidout_tex , '%s - AZIMUTH: $%6.2f$%sgrad and ELEVATION: $%6.2f$%sgrad\n\n',b,TresD_View(5),'\',TresD_View(6),'\')
		else
			fprintf( fidout_tex , '%s \n\n',b)
		end
		fprintf( fidout_tex , '%sanimategraphics[controls,loop,height=10cm]{6}{../%s_%s_}{1}{%s}      \n\n','\',name,def,num2str(HowManySD(1)))
	end
	fprintf( fidout_tex , '%send{center}       \n','\')
	if Dimensions == 3
		if TresD_View(1) == 1
			fprintf( fidout_tex , '%snewpage       \n','\')
			fprintf( fidout_tex , '%sbegin{center}       \n','\')
			fprintf( fidout_tex , '%s -  $XY$ - $Z=%stext{cte}$ \n\n',a,'\')
			fprintf( fidout_tex , '%sincludegraphics[width=.80%stextwidth]{../../XY_XZ_YZ/XY/%s/%s_%s_XY_%s.png}      \n\n','\','\',def,name,def,num2str(HowManySD(1)))
			if HowManySD(1) > 1
				fprintf( fidout_tex , '\n%s -  $XY$ - $Z=%stext{cte}$ \n\n',b,'\')
				fprintf( fidout_tex , '%sanimategraphics[controls,loop,height=10cm]{6}{../../XY_XZ_YZ/XY/%s/%s_%s_XY_}{1}{%s}      \n\n','\',def,name,def,num2str(HowManySD(1)))
			end
			fprintf( fidout_tex , '%send{center}       \n','\')
		end
		if TresD_View(2) == 1
			fprintf( fidout_tex , '%snewpage       \n','\')
			fprintf( fidout_tex , '%sbegin{center}       \n','\')
			fprintf( fidout_tex , '%s -  $XZ$ - $Y=%stext{cte}$ \n\n',a,'\')
			fprintf( fidout_tex , '%sincludegraphics[width=.80%stextwidth]{../../XY_XZ_YZ/XZ/%s/%s_%s_XZ_%s.png}      \n\n','\','\',def,name,def,num2str(HowManySD(1)))
			if HowManySD(1) > 1
				fprintf( fidout_tex , '\n%s -  $XZ$ - $Y=%stext{cte}$ \n\n',b,'\')
				fprintf( fidout_tex , '%sanimategraphics[controls,loop,height=10cm]{6}{../../XY_XZ_YZ/XZ/%s/%s_%s_XZ_}{1}{%s}      \n\n','\',def,name,def,num2str(HowManySD(1)))
			end
			fprintf( fidout_tex , '%send{center}       \n','\')
		end
		if TresD_View(3) == 1
			fprintf( fidout_tex , '%snewpage       \n','\')
			fprintf( fidout_tex , '%sbegin{center}       \n','\')
			fprintf( fidout_tex , '%s -  $YZ$ - $X=%stext{cte}$ \n\n',a,'\')
			fprintf( fidout_tex , '%sincludegraphics[width=.80%stextwidth]{../../XY_XZ_YZ/YZ/%s/%s_%s_YZ_%s.png}      \n\n','\','\',def,name,def,num2str(HowManySD(1)))
			if HowManySD(1) > 1
				fprintf( fidout_tex , '\n%s -  $YZ$ - $X=%stext{cte}$ \n\n',b,'\')
				fprintf( fidout_tex , '%sanimategraphics[controls,loop,height=10cm]{6}{../../XY_XZ_YZ/YZ/%s/%s_%s_YZ_}{1}{%s}      \n\n','\',def,name,def,num2str(HowManySD(1)))
			end
			fprintf( fidout_tex , '%send{center}       \n','\')
		end
	end
end

fprintf( fidout_tex , '%send{document}  \n','\')
fclose(fidout_tex) ;

tiempo_deformed_tex_lin = toc ;
tiempo_TEX = tiempo_TEX + tiempo_deformed_tex_lin;

