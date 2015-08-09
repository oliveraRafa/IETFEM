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
  %%%%%%%%%%%%%%%%%%%%%%%%% LINEAR STRAIN
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Archivo en .TEX

fidout_tex = du_tex_lin;

All_text_format
fprintf( fidout_tex , '%sbegin{document}      \n\n','\')

fprintf( fidout_tex , '%s == Encabezado y pie de pagina ==           \n','%')
fprintf( fidout_tex , '%spagestyle{fancy}                            \n','\')
fprintf( fidout_tex , '%scfoot{}                                     \n','\')
if Lenguage == 1
  fprintf( fidout_tex , '%slhead{Project name}                  \n','\')
  fprintf( fidout_tex , '%slfoot{%sfootnotesize Linear Strain}      \n','\','\') 
  fprintf( fidout_tex , '%srfoot{Page %sthepage}                        \n','\','\')
elseif Lenguage == 2
  fprintf( fidout_tex , '%slhead{Nombre del proyecto}                  \n','\')
  fprintf( fidout_tex , '%slfoot{%sfootnotesize Deformación Lineal}      \n','\','\') 
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
	fprintf( fidout_tex , '================== Linear Strain IETFEM v%s ===========================%s\n\n\n',version,'\\\\')
	fprintf( fidout_tex , 'Solve time: $%6.3f$ seconds %s\n\n', tiempo ,'\\')
	fprintf( fidout_tex , 'Inputfile: %sverb|%s|  ... %s\n\n','\', input_file ,'\\')
	if SD_LD == 1
    fprintf( fidout_tex , 'Problem type: %s %sD small deformations and displacements%s \n\n',KP,Dim,'\\') 
  else
		fprintf( fidout_tex , 'Problem type: %s %sD large deformations and displacements%s \n\n',KP,Dim,'\\')
  end
	fprintf( fidout_tex , 'Number of elements: %i %s\n\n', NElem,'\\')

	fprintf( fidout_tex , '%snewpage       \n\n','\')
	
	if Print(1) == 1 && PlotView(3) == 1
		fprintf( fidout_tex , '%sbegin{center}       \n','\')
		fprintf( fidout_tex , '%sincludegraphics[width=.80%stextwidth]{../../%s_%s.png} \n     ','\','\',name,ind)
		fprintf( fidout_tex , '%send{center}       \n\n','\')
	end
	
	fprintf( fidout_tex , 'Linear Elasticity:%s\n\n','\\')
	fprintf( fidout_tex , '%sbegin{center}                                   \n','\')
	fprintf( fidout_tex , '%sbegin{longtable}{|R{1.5cm}|R{2.5cm}|}                      \n','\')
	fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
	fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Linear Strain} %s      \n','\','\\')
	fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
	fprintf( fidout_tex , 'Element   &   Strain                   %s         \n','\\')
	fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
	fprintf( fidout_tex , '%sendfirsthead                                    \n','\')
	fprintf( fidout_tex , '%stoprule[0.8mm]                                  \n','\')
	fprintf( fidout_tex , '%smulticolumn{2}{|c|}{Linear Strain} %s      \n','\','\\')
	fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
	fprintf( fidout_tex , 'Element   &   Strain                   %s         \n','\\')
	fprintf( fidout_tex , '%smidrule[0.5mm]                                  \n','\')
	fprintf( fidout_tex , '%sendhead                                         \n','\')
	fprintf( fidout_tex , '%shline                                           \n','\')
	fprintf( fidout_tex , '%smulticolumn{2}{r}{Next page...}                 \n','\')		
elseif Lenguage == 2
	fprintf( fidout_tex , '================== Deformación Lineal IETFEM v%s ===========================%s\n\n\n',version,'\\\\')
	fprintf( fidout_tex , 'Tiempo en resolver: $%6.3f$ segundos %s\n\n', tiempo ,'\\')
	fprintf( fidout_tex , 'Archivo de entrada: %sverb|%s|  ... %s\n\n','\', input_file ,'\\')
	if SD_LD == 1
    fprintf( fidout_tex , 'Tipo de problema: %s %sD pequeñas deformaciones y desplazamientos%s \n\n',KP,Dim,'\\') 
  else
		fprintf( fidout_tex , 'Tipo de problema: %s %sD grandes deformaciones y desplazamientos%s \n\n',KP,Dim,'\\')
  end
	fprintf( fidout_tex , 'Número de elementos: %i %s\n\n', NElem,'\\')

	fprintf( fidout_tex , '%snewpage       \n\n','\')

	if Print(1) == 1 && PlotView(3) == 1
		fprintf( fidout_tex , '%sbegin{center}       \n','\')
		fprintf( fidout_tex , '%sincludegraphics[width=.80%stextwidth]{../../%s_%s.png} \n     ','\','\',name,ind)
		fprintf( fidout_tex , '%send{center}       \n\n','\')
	end
	
	fprintf( fidout_tex , 'Elasticidad Lineal:%s\n\n','\\')
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
end
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
if Lenguage == 1
	fprintf( fidout_tex , '%scaption{Linear Strain}             \n','\')
else
	fprintf( fidout_tex , '%scaption{Deformación Lineal}             \n','\')
end
fprintf( fidout_tex , '%send{longtable}                                  \n','\')
fprintf( fidout_tex , '%send{center}                                     \n\n','\')

fprintf( fidout_tex , '%send{document}  \n','\')

fclose(fidout_tex) ;
tiempo_du_tex_lin = toc ;
tiempo_TEX = tiempo_TEX + tiempo_du_tex_lin;

