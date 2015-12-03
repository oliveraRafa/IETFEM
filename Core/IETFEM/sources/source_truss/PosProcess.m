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

if sum(Plots) == 0
  posprocess_time = 0;
else
  parameters_time  = 0;
  undeformed_time  = 0;
  deformed_time    = 0;
  axial_time       = 0;
	if Lenguage == 1
		fprintf('\nHere IETFEM start to plot and print some figures:\n\n')
	else
		fprintf('\nAqui IETFEM comienza a realizar el grafico e impresion de algunas figuras:\n\n')
	end
  if Lenguage == 1
		fprintf(' - Some important parameters to plot and images.\n')
	else
		fprintf(' - Algunos parametros importantes para la creacion de graficos e imagenes.\n')
	end
	% ============ FACTORS ====================================================
	tic
	%Area factors
	grosorminimo = 0.25                           ;
	grosormaximo = grosorminimo*ScaleFactor(3) ;
	area_factor  = ones(NElem,1) * ( grosormaximo + grosorminimo ) / 2 ;
	%
	if max(Areas)-min(Areas)~=0
		for i = 1 : NElem
			area_factor(i) = grosormaximo+(grosormaximo-grosorminimo)*(Areas(i)-max(Areas))/(max(Areas)-min(Areas));
		end
	end
	offsetx = abs((max(NodCoordMat(:,1))-min(NodCoordMat(:,1)))*0.3) + min(Largos) *ScaleFactor(5) ;   % 0.3 is any number ...
	offsety = abs((max(NodCoordMat(:,2))-min(NodCoordMat(:,2)))*0.3) + min(Largos) *ScaleFactor(5) ;
	offsetz = abs((max(NodCoordMat(:,3))-min(NodCoordMat(:,3)))*0.3) + min(Largos) *ScaleFactor(5) ;
	%
	%Force factors
	largominimo = sum(Largos)/NElem/2   ; % LA FLECHA M�?S CHICA ES LA MITAD DEL PROMEDIO DE LOS LARGOS
	largomaximo = largominimo*ScaleFactor(4) ;
	%
	force_factor = ones(NNodNeumCond,1)*(largomaximo+largominimo)/2;
  if NNodNeumCond ~=0
    force_module = sqrt(NeumCondMat(:,2).^2 + NeumCondMat(:,3).^2 + NeumCondMat(:,4).^2 );
    if max(force_module)-min(force_module)~=0
      for i = 1 : NNodNeumCond
        force_factor(i) = largomaximo+(largomaximo-largominimo)*(force_module(i)-max(force_module))/(max(force_module)-min(force_module));
      end
    end
	end
  

  if SD_LD ~= 1 
    % ============ DEFORMADA FINITA =================================================
    
    pasos = LoadControl(2);
    if PlotIterations == 1
      pasos = 1;
    end
   

    DEFORMED_OFFSETX_FIN = zeros(1,LoadControl(2)-pasos+1);
    DEFORMED_OFFSETY_FIN = zeros(1,LoadControl(2)-pasos+1);
    DEFORMED_OFFSETZ_FIN = zeros(1,LoadControl(2)-pasos+1);

	AXIAL_DEFORMED_OFFSETX_FIN = zeros(1,LoadControl(2)-pasos+1);
    AXIAL_DEFORMED_OFFSETY_FIN = zeros(1,LoadControl(2)-pasos+1);
    AXIAL_DEFORMED_OFFSETZ_FIN = zeros(1,LoadControl(2)-pasos+1);

    DEF_XElemMat_fin    = []; 
    DEF_YElemMat_fin    = []; 
    DEF_ZElemMat_fin    = []; 
    DEF_NodCoordMat_fin = [];
    AxialDefNodCoordMat_fin = [];
	AxialDEF_NodCoordMat_fin = [];
	AxialDEF_XElemMat_fin    = []; 
    AxialDEF_YElemMat_fin    = []; 
    AxialDEF_ZElemMat_fin    = [];
	
    for paso = pasos : LoadControl(2)
      %
      for i =1 : NNod,
        aux = node2dof(i,3);
        DefNodCoordMat_fin(i,:)      = NodCoordMat(i,:) + ScaleFactor(7)*Upasos(:,paso)(aux)';
		AxialDefNodCoordMat_fin(i,:) = NodCoordMat(i,:) + Upasos(:,paso)(aux)';
      end
      
      DEF_NodCoordMat_fin      = [DEF_NodCoordMat_fin, DefNodCoordMat_fin];
      AxialDEF_NodCoordMat_fin = [AxialDEF_NodCoordMat_fin, AxialDefNodCoordMat_fin];

      deformed_offsetx_fin = abs((max(DefNodCoordMat_fin(:,1))-min(DefNodCoordMat_fin(:,1)))/4)+min(Largos)/2;
      deformed_offsety_fin = abs((max(DefNodCoordMat_fin(:,2))-min(DefNodCoordMat_fin(:,2)))/4)+min(Largos)/2;
      deformed_offsetz_fin = abs((max(DefNodCoordMat_fin(:,3))-min(DefNodCoordMat_fin(:,3)))/4)+min(Largos)/2;
      
      axial_deformed_offsetx_fin = abs((max(AxialDefNodCoordMat_fin(:,1))-min(AxialDefNodCoordMat_fin(:,1)))/4)+min(Largos)/2;
      axial_deformed_offsety_fin = abs((max(AxialDefNodCoordMat_fin(:,2))-min(AxialDefNodCoordMat_fin(:,2)))/4)+min(Largos)/2;
      axial_deformed_offsetz_fin = abs((max(AxialDefNodCoordMat_fin(:,3))-min(AxialDefNodCoordMat_fin(:,3)))/4)+min(Largos)/2;
      
      DEFORMED_OFFSETX_FIN = [DEFORMED_OFFSETX_FIN, deformed_offsetx_fin];
      DEFORMED_OFFSETY_FIN = [DEFORMED_OFFSETY_FIN, deformed_offsety_fin];
      DEFORMED_OFFSETZ_FIN = [DEFORMED_OFFSETZ_FIN, deformed_offsetz_fin];
      
      AXIAL_DEFORMED_OFFSETX_FIN = [AXIAL_DEFORMED_OFFSETX_FIN, axial_deformed_offsetx_fin];
      AXIAL_DEFORMED_OFFSETY_FIN = [AXIAL_DEFORMED_OFFSETY_FIN, axial_deformed_offsety_fin];
      AXIAL_DEFORMED_OFFSETZ_FIN = [AXIAL_DEFORMED_OFFSETZ_FIN, axial_deformed_offsetz_fin];
      
      DefXElemMat_fin = []; 
      DefYElemMat_fin = [];
      DefZElemMat_fin = [];
      
      AxialDefXElemMat_fin = []; 
      AxialDefYElemMat_fin = [];
      AxialDefZElemMat_fin = [];

      for j = 1:NElem
		  DefXElemMat_fin (j,:) = DefNodCoordMat_fin( ConectMat (j,:) , 1 )' ;
		  DefYElemMat_fin (j,:) = DefNodCoordMat_fin( ConectMat (j,:) , 2 )' ;
		  DefZElemMat_fin (j,:) = DefNodCoordMat_fin( ConectMat (j,:) , 3 )' ;
		  AxialDefXElemMat_fin (j,:) = AxialDefNodCoordMat_fin( ConectMat (j,:) , 1 )' ;
		  AxialDefYElemMat_fin (j,:) = AxialDefNodCoordMat_fin( ConectMat (j,:) , 2 )' ;
		  AxialDefZElemMat_fin (j,:) = AxialDefNodCoordMat_fin( ConectMat (j,:) , 3 )' ;
      end
      %
      DEF_XElemMat_fin = [DEF_XElemMat_fin, DefXElemMat_fin]; 
      DEF_YElemMat_fin = [DEF_YElemMat_fin, DefYElemMat_fin]; 
      DEF_ZElemMat_fin = [DEF_ZElemMat_fin, DefZElemMat_fin]; 
      %
      AxialDEF_XElemMat_fin = [AxialDEF_XElemMat_fin, AxialDefXElemMat_fin]; 
      AxialDEF_YElemMat_fin = [AxialDEF_YElemMat_fin, AxialDefYElemMat_fin]; 
      AxialDEF_ZElemMat_fin = [AxialDEF_ZElemMat_fin, AxialDefZElemMat_fin]; 
      %
    end

    deformed_offsetx_fin = max(DEFORMED_OFFSETX_FIN);
    deformed_offsety_fin = max(DEFORMED_OFFSETY_FIN);
    deformed_offsetz_fin = max(DEFORMED_OFFSETZ_FIN);
	
	axial_deformed_offsetx_fin = max(AXIAL_DEFORMED_OFFSETX_FIN);
    axial_deformed_offsety_fin = max(AXIAL_DEFORMED_OFFSETY_FIN);
    axial_deformed_offsetz_fin = max(AXIAL_DEFORMED_OFFSETZ_FIN);
	
    % =========================================================================
  end
	% ============ DEFORMADA LINEAL =================================================
	for i =1 : NNod,
		aux = node2dof(i,3);
		DefNodCoordMat_lin(i,:) = NodCoordMat(i,:) + ScaleFactor(1)*Ulineal(aux)';
	end

	deformed_offsetx_lin = abs((max(DefNodCoordMat_lin(:,1))-min(DefNodCoordMat_lin(:,1)))/4)+min(Largos)/2;
	deformed_offsety_lin = abs((max(DefNodCoordMat_lin(:,2))-min(DefNodCoordMat_lin(:,2)))/4)+min(Largos)/2;
	deformed_offsetz_lin = abs((max(DefNodCoordMat_lin(:,3))-min(DefNodCoordMat_lin(:,3)))/4)+min(Largos)/2;

	DefXElemMat_lin = []; 
	DefYElemMat_lin = [];
	DefZElemMat_lin = [];

	for j = 1:NElem
	  DefXElemMat_lin (j,:) = DefNodCoordMat_lin( ConectMat (j,:) , 1 )' ;
	  DefYElemMat_lin (j,:) = DefNodCoordMat_lin( ConectMat (j,:) , 2 )' ;
	  DefZElemMat_lin (j,:) = DefNodCoordMat_lin( ConectMat (j,:) , 3 )' ;
	end

	% =========================================================================
	parameters_time = toc;
	% ============ PLOTTING ===================================================
	
	% ============ UNDEFORMED =================================================
  undeformed_plot_time = 0;
  undeformed_print_time = 0;
  undeformed_lin_print_time = 0;
  undeformed_fin_print_time = 0;
  offset1=min(Largos)/7*ScaleFactor(6);
  cuadro=[min(NodCoordMat(:,1))-min([offsetx,offsety,offsetz]) max(NodCoordMat(:,1))+min([offsetx,offsety,offsetz]) min(NodCoordMat(:,2))-min([offsetx,offsety,offsetz]) max(NodCoordMat(:,2))+min([offsetx,offsety,offsetz]) min(NodCoordMat(:,3))-min([offsetx,offsety,offsetz]) max(NodCoordMat(:,3))+min([offsetx,offsety,offsetz])];

	if Plots(1) == 1
    if Lenguage == 1
      fprintf(' - Undeformed Plot.\n')
    else
      fprintf(' - Grafico de Indeformada.\n')
    end
    tic
		figure(1)

		hold ("on") ;
    grid on
		
		axis ( cuadro , 'equal')
    if Lenguage == 1
      title(['Undeformed [',LengthMagnitude,']'])
		else
      title(['Indeformada [',LengthMagnitude,']'])
    end
		xlabel(['x [',LengthMagnitude,']'])
		ylabel(['y [',LengthMagnitude,']'])
		zlabel(['z [',LengthMagnitude,']'])
	  
		% Undeformed
		if Dimensions == 3
			for j = 1: NElem
				plot3( XElemMat(j,:) , YElemMat(j,:) , ZElemMat(j,:) ,'k', 'linewidth', area_factor(j) )
			end
    else
			for j = 1: NElem
				plot( XElemMat(j,:) , YElemMat(j,:) ,'k', 'linewidth', area_factor(j) )
			end
		end
		%
    if PlotView(1) == 1 % Supports
      % Dirichlet supports
			if Dimensions == 3
				for i = 1 : NNodDiriCond
					for j = 1:NDFPN
						Value = ReadingDiriCondMat(i,1+j);
						if Value == 0
							[ H1 , H2 , H3 , color] = Supports( j , NodCoordMat( ReadingDiriCondMat (i,1),:) , ScaleFactor(2)*offset1 , ProbType ) ;
							plot3( H1 , H2 , H3 , 'Color',color,'linewidth',grosorminimo)
						end
					end
				end
      else
				for i = 1 : NNodDiriCond
					for j = 1:NDFPN
						Value = ReadingDiriCondMat(i,1+j);
						if Value == 0
							[ H1 , H2 , H3 , color] = Supports( j , NodCoordMat( ReadingDiriCondMat (i,1),:) , ScaleFactor(2)*offset1 , ProbType ) ;
							plot( H1 , H2 , 'Color',color,'linewidth',grosorminimo)
						end
					end
				end
			end
			%Robi supports
			if Dimensions == 3
				for i = 1 : NNodRobiCond
					for j = 1:NDFPN
						Value = RobiCondMat(i,1+j);
						if Value ~= 0
							[ H1 , H2 , H3 , color] = Supports( j+3 , NodCoordMat( RobiCondMat (i,1),:) , ScaleFactor(2)*offset1 , ProbType ) ;
							plot3( H1 , H2 , H3 , 'Color',color,'linewidth',grosorminimo)
						end
					end
				end
			else
				for i = 1 : NNodRobiCond
					for j = 1:NDFPN
						Value = RobiCondMat(i,1+j);
						if Value ~= 0
							[ H1 , H2 , H3 , color] = Supports( j+3 , NodCoordMat( RobiCondMat (i,1),:) , ScaleFactor(2)*offset1 , ProbType ) ;
							plot( H1 , H2 , 'Color',color,'linewidth',grosorminimo)
						end
					end
				end
			end
		end
    %
		if PlotView(2) == 1 % Node's numbers
			if Dimensions == 3
				for i = 1 : NNod
					text( NodCoordMat ( i , 1 )+offset1, NodCoordMat ( i , 2 )+offset1, NodCoordMat ( i , 3 )+offset1, num2str ( i ),'Color',[0.02,0.3,0.07] )
				end
			else
				for i = 1 : NNod
					text( NodCoordMat ( i , 1 )+offset1, NodCoordMat ( i , 2 )+offset1, num2str ( i ),'Color',[0.02,0.3,0.07] )
				end
			end
		end	
    %
    if PlotView(3) == 1 % Element's numbers
			if Dimensions == 3
				for i = 1 : NElem
					pos = [(XElemMat( i , 2 ) + XElemMat( i , 1 ))*0.5 , (YElemMat( i , 2 ) + YElemMat( i , 1 ))*0.5, (ZElemMat( i , 2 ) + ZElemMat( i , 1 ))*0.5] ;
					text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( i ),'Color',[1,0.3,0] )
				end
			else
				for i = 1 : NElem
					pos = [(XElemMat( i , 2 ) + XElemMat( i , 1 ))*0.5 , (YElemMat( i , 2 ) + YElemMat( i , 1 ))*0.5] ;
					text( pos(1)+offset1,  pos(2)+offset1 , num2str ( i ),'Color',[1,0.3,0] )
				end
			end
		end
    if PlotView(4) == 1 %Forces
      if Dimensions == 3
				if NNodNeumCond ~= 0
					for i = 1 : NNodNeumCond
						aux_x = NodCoordMat ( NeumCondMat( i , 1 ) , 1 ) ; aux_y = NodCoordMat ( NeumCondMat( i , 1 ) , 2 ) ; aux_z = NodCoordMat ( NeumCondMat( i , 1 ) , 3 ) ;
						F_x   = sign(NeumCondMat ( i , 2 )) * force_factor(i) ; F_y   = sign(NeumCondMat ( i , 3 )) * force_factor(i) ; F_z   = sign(NeumCondMat ( i , 4 )) * force_factor(i) ;
						pos1 = aux_x-F_x; pos2 = aux_y-F_y; pos3 = aux_z-F_z;
						Hq    = quiver3 ( pos1,  pos2 , pos3 , F_x , F_y , F_z , 'linewidth' , 1.5 , 'Color' , [0,0,1] );
						set( Hq,'maxheadsize',0.2)
					end
				end
			else
				if NNodNeumCond ~= 0
					for i = 1 : NNodNeumCond
						aux_x = NodCoordMat ( NeumCondMat( i , 1 ) , 1 ) ; aux_y = NodCoordMat ( NeumCondMat( i , 1 ) , 2 ) ; aux_z = NodCoordMat ( NeumCondMat( i , 1 ) , 3 ) ;
						F_x   = sign(NeumCondMat ( i , 2 )) * force_factor(i) ; F_y   = sign(NeumCondMat ( i , 3 )) * force_factor(i) ; F_z   = sign(NeumCondMat ( i , 4 )) * force_factor(i) ;
						pos1 = aux_x-F_x; pos2 = aux_y-F_y; pos3 = aux_z-F_z;
						Hq    = quiver ( pos1,  pos2 , F_x , F_y , 'linewidth' , 1.5 , 'Color' , [0,0,1] );
						set( Hq,'maxheadsize',0.2)
					end
				end
			end
		end
		undeformed_plot_time = toc;
		if Print(1) == 1,
			%
			if Dimensions ~= 3
				if SD_LD ==1
          if Lenguage == 1
            fprintf(' - Undeformed 2D Print for small deformations.\n')
          else
            fprintf(' - Impresion de Indeformada 2D para pequenas deformaciones.\n')
          end
          tic
					print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' name '_' ind '.png' ] ,'-dpng')
          undeformed_lin_print_time = toc;
				else
          if Lenguage == 1
            fprintf(' - Undeformed 2D Print for small deformations.\n')
          else
            fprintf(' - Impresion de Indeformada 2D para pequenas deformaciones.\n')
          end
          tic
					print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' name '_' ind '.png' ] ,'-dpng')
          print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' name '_' ind '.png' ] ,'-dpng')
          undeformed_fin_print_time = toc;
				end

			else 
				if SD_LD == 1
          if Lenguage == 1
            fprintf(' - Undeformed 3D Print for small deformations.\n')
          else
            fprintf(' - Impresion de Indeformada 3D para pequenas deformaciones.\n')
          end
          tic
            view(TresD_View(5),TresD_View(6)) 
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' name '_' ind '.png' ] ,'-dpng')
				  if TresD_View(1) == 1
            view(0,90) % XY
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XY/' name '_' ind '_XY.png' ] ,'-dpng')
				  end
				  if TresD_View(2) == 1
            view(0,0) % XZ
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XZ/' name '_' ind '_XZ.png' ] ,'-dpng')
				  end
				  if TresD_View(3) == 1
            view(90,0) % YZ
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/YZ/' name '_' ind '_YZ.png' ] ,'-dpng')
				  end
          undeformed_lin_print_time = toc;
				else
          if Lenguage == 1
            fprintf(' - Undeformed 3D Print for small deformations.\n')
          else
            fprintf(' - Impresion de Indeformada 3D para pequenas deformaciones.\n')
          end
          tic
				  if TresD_View(1) == 1
            view(0,90) % XY
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XY/' name '_' ind '_XY.png' ] ,'-dpng')
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XY/' name '_' ind '_XY.png' ] ,'-dpng') 
				  end
				  if TresD_View(2) == 1
            view(0,0) % XZ
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XZ/' name '_' ind '_XZ.png' ] ,'-dpng')
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XZ/' name '_' ind '_XZ.png' ] ,'-dpng')
				  end
				  if TresD_View(3) == 1
            view(90,0) % YZ
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/YZ/' name '_' ind '_YZ.png' ] ,'-dpng')
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/YZ/' name '_' ind '_YZ.png' ] ,'-dpng')
				  end
            view(TresD_View(5),TresD_View(6))
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' name '_' ind '.png' ] ,'-dpng')
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' name '_' ind '.png' ] ,'-dpng')
          undeformed_fin_print_time = toc;
				end
			end
		end%
    undeformed_print_time = undeformed_lin_print_time+undeformed_fin_print_time;
	end
	undeformed_time = undeformed_plot_time + undeformed_print_time;
	% =========================================================================

	% ============ DEFORMED VS Undeformed =====================================
	
  % Ploteo lineal
  deformed_lin_plot_time = 0;
  deformed_lin_print_time = 0;
	if Plots(2) == 1
		if Lenguage == 1
		  fprintf(' - Deformed Plot for small deformations.\n')
		else
		  fprintf(' - Grafico de Deformada para pequenas deformaciones.\n')
		end
  tic
		%
		deformedcuadro_lin = [min(min(NodCoordMat(:,1),DefNodCoordMat_lin(:,1)))-min([offsetx,offsety,offsetz,deformed_offsetx_lin,deformed_offsety_lin,deformed_offsetz_lin]),
							  max(max(NodCoordMat(:,1),DefNodCoordMat_lin(:,1)))+min([offsetx,offsety,offsetz,deformed_offsetx_lin,deformed_offsety_lin,deformed_offsetz_lin]),
							  min(min(NodCoordMat(:,2),DefNodCoordMat_lin(:,2)))-min([offsetx,offsety,offsetz,deformed_offsetx_lin,deformed_offsety_lin,deformed_offsetz_lin]),
							  max(max(NodCoordMat(:,2),DefNodCoordMat_lin(:,2)))+min([offsetx,offsety,offsetz,deformed_offsetx_lin,deformed_offsety_lin,deformed_offsetz_lin]),
							  min(min(NodCoordMat(:,3),DefNodCoordMat_lin(:,3)))-min([offsetx,offsety,offsetz,deformed_offsetx_lin,deformed_offsety_lin,deformed_offsetz_lin]),
							  max(max(NodCoordMat(:,3),DefNodCoordMat_lin(:,3)))+min([offsetx,offsety,offsetz,deformed_offsetx_lin,deformed_offsety_lin,deformed_offsetz_lin])];
    %
    
    deformed_lin_plot_time = toc;
    
    if Print(2) == 1
      if Dimensions ~= 3
        if Lenguage == 1
          fprintf(' - Deformed 2D Print for small deformations for %i steps.\n', HowManySD(1))
        else
          fprintf(' - Impresion de Deformada 2D para pequenas deformaciones para %i pasos.\n', HowManySD(1))
        end
      else
        if Lenguage == 1
          fprintf(' - Deformed 3D Print for small deformations for %i steps.\n', HowManySD(1))
        else
          fprintf(' - Impresion de Deformada 3D para pequenas deformaciones para %i pasos.\n', HowManySD(1))
        end
		  end
    end
    
		DefNodCoordMat_lin_aux = (DefNodCoordMat_lin - NodCoordMat)/HowManySD(1);
		DefXElemMat_lin_aux    = (DefXElemMat_lin-XElemMat)/HowManySD(1);
		DefYElemMat_lin_aux    = (DefYElemMat_lin-YElemMat)/HowManySD(1);
		DefZElemMat_lin_aux    = (DefZElemMat_lin-ZElemMat)/HowManySD(1);
		
    for i = 1 : HowManySD(1)
		DefNodCoordMat_lin = NodCoordMat + i*DefNodCoordMat_lin_aux;
		DefXElemMat_lin    = XElemMat + i*DefXElemMat_lin_aux;
		DefYElemMat_lin    = YElemMat + i*DefYElemMat_lin_aux;
		DefZElemMat_lin    = ZElemMat + i*DefZElemMat_lin_aux;
		tic
      %
      figure(2)
      hold ("on") ;
      grid on
      if Lenguage == 1
        title(['Deformed - SD (blue) VS Undeformed (black) [',LengthMagnitude,']- SF : ',num2str(ScaleFactor(1)),' - Image: ',num2str(i),'/',num2str(HowManySD(1)),''])
      else
        title(['Deformada - PD (Azul) VS Indeformada (Negro) [',LengthMagnitude,']- FE : ',num2str(ScaleFactor(1)),'  - Imagen: ',num2str(i),'/',num2str(HowManySD(1)),''])
      end
      %
      axis ( deformedcuadro_lin ,'equal')
      xlabel(['x [',LengthMagnitude,']'])
      ylabel(['y [',LengthMagnitude,']'])
      zlabel(['z [',LengthMagnitude,']'])
      % Undeformed
			if Dimensions == 3
				for j = 1: NElem
					plot3( XElemMat(j,:) , YElemMat(j,:) , ZElemMat(j,:) ,'k:', 'linewidth', area_factor(j)/2 )
				end
      else
				for j = 1: NElem
					plot( XElemMat(j,:) , YElemMat(j,:) ,'k:', 'linewidth', area_factor(j)/2 )
				end
			end
			if PlotView(2) == 1
        % Node's numbers
				if Dimensions == 3
					for j = 1 : NNod
						text( DefNodCoordMat_lin ( j , 1 )+offset1, DefNodCoordMat_lin ( j , 2 )+offset1, DefNodCoordMat_lin ( j , 3 )+offset1, num2str ( j ),'Color',[0.02,0.3,0.07] )
					end
				else
					for j = 1 : NNod
						text( DefNodCoordMat_lin ( j , 1 )+offset1, DefNodCoordMat_lin ( j , 2 )+offset1, num2str ( j ),'Color',[0.02,0.3,0.07] )
					end
				end
			end
      % Deformed
			if Dimensions == 3
				for j = 1: NElem
					 plot3( DefXElemMat_lin(j,:) , DefYElemMat_lin(j,:) , DefZElemMat_lin(j,:),'b-','linewidth',area_factor(j),'markersize',ScaleFactor(3)/20)
				end
			else
				for j = 1: NElem
					 plot( DefXElemMat_lin(j,:) , DefYElemMat_lin(j,:),'b-','linewidth',area_factor(j),'markersize',ScaleFactor(3)/20)
				end
			end
      %
    deformed_lin_plot_time = deformed_lin_plot_time + toc;
      if Print(2) == 1
        tic
        a=0;
        if Dimensions ~= 3
					if SD_LD == 1
						print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' def '/' name '_' def '_' num2str(i) '.png' ] ,'-dpng')
					else
						print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' def '/' name '_' def '_' num2str(i) '.png' ] ,'-dpng')
					end
				else 
					if SD_LD == 1
						if TresD_View(1) == 1
							view(0,90) % XY
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XY/' def '/' name '_' def '_XY_' num2str(i) '.png' ] ,'-dpng')
							pause(0.1)
						end
						if TresD_View(2) == 1
							view(0,0) % XZ
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XZ/' def '/' name '_' def '_XZ_' num2str(i) '.png' ] ,'-dpng')
							pause(0.1)
						end
						if TresD_View(3) == 1
							view(90,0) % YZ
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/YZ/' def '/' name '_' def '_YZ_' num2str(i) '.png' ] ,'-dpng')
							pause(0.1)
						end
							view(TresD_View(5),TresD_View(6))
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' def '/' name '_' def '_' num2str(i) '.png' ] ,'-dpng')
					else
						if TresD_View(1) == 1
							view(0,90) % XY
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XY/' def '/' name '_' def '_XY_' num2str(i) '.png' ] ,'-dpng')
							pause(0.1)
						end
						if TresD_View(2) == 1
							view(0,0) % XZ
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XZ/' def '/' name '_' def '_XZ_' num2str(i) '.png' ] ,'-dpng')
							pause(0.1)
						end
						if TresD_View(3) == 1
							view(90,0) % YZ
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/YZ/' def '/' name '_' def '_YZ_' num2str(i) '.png' ] ,'-dpng')
							pause(0.1)
						end
							view(TresD_View(5),TresD_View(6))
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' def '/' name '_' def '_' num2str(i) '.png' ] ,'-dpng')
					end
					a=sum(TresD_View([1:3]))*0.1;
				end
		hold ("off") ;
		pause(0.2);
        if i<HowManySD(1)
			close (figure(2))
		end
        deformed_lin_print_time = deformed_lin_print_time + toc - 0.2 - a;
	end
      %
		end
		%
	end
  deformed_lin_time = deformed_lin_plot_time+deformed_lin_print_time;

	% Ploteo no lineal
  deformed_fin_plot_time = 0;
  deformed_fin_print_time = 0;
	if Plots(4) == 1 && SD_LD ~= 1
    if Lenguage == 1
      fprintf(' - Deformed Plot for large deformation.\n')
    else
      fprintf(' - Grafico de Deformada para grandes deformaciones.\n')
    end
  tic
		%
		aux1_fin = [1,2,3];
		aux2_fin = [1,2];
		deformedcuadro_fin = [min(min(NodCoordMat(:,1),min(min(DEF_NodCoordMat_fin(:,[1:3:end])))))-min([offsetx,offsety,offsetz,deformed_offsetx_fin,deformed_offsety_fin,deformed_offsetz_fin]),
							  max(max(NodCoordMat(:,1),max(max(DEF_NodCoordMat_fin(:,[1:3:end])))))+min([offsetx,offsety,offsetz,deformed_offsetx_fin,deformed_offsety_fin,deformed_offsetz_fin]),
							  min(min(NodCoordMat(:,2),min(min(DEF_NodCoordMat_fin(:,[2:3:end])))))-min([offsetx,offsety,offsetz,deformed_offsetx_fin,deformed_offsety_fin,deformed_offsetz_fin]),
							  max(max(NodCoordMat(:,2),max(max(DEF_NodCoordMat_fin(:,[2:3:end])))))+min([offsetx,offsety,offsetz,deformed_offsetx_fin,deformed_offsety_fin,deformed_offsetz_fin]),
							  min(min(NodCoordMat(:,3),min(min(DEF_NodCoordMat_fin(:,[3:3:end])))))-min([offsetx,offsety,offsetz,deformed_offsetx_fin,deformed_offsety_fin,deformed_offsetz_fin]),
							  max(max(NodCoordMat(:,3),max(max(DEF_NodCoordMat_fin(:,[3:3:end])))))+min([offsetx,offsety,offsetz,deformed_offsetx_fin,deformed_offsety_fin,deformed_offsetz_fin])];
    %
		
    deformed_fin_plot_time = toc;
    
    if Print(4) == 1
      if Lenguage == 1
				if plot_pasos == LoadControl(2)
					g = 'the last load step';
				else
					g = 'all load steps';
				end
				fprintf(' - Deformed %sD Print for large deformations for %s (%i).\n',Dim, g, LoadControl(2))
			else
				if plot_pasos == LoadControl(2)
					g = 'el ultimo estado de carga';
				else
					g = 'todos los estados de carga';
				end
				fprintf(' - Impresion de Deformada %sD para grandes deformaciones para %s (%i).\n',Dim, g, LoadControl(2))
			end
    end
    
    for i = plot_pasos : LoadControl(2)
    tic
      %
      figure(4)
      hold ("on") ;
      grid on
      if Lenguage == 1
        title(['Deformed - LD (blue) VS Undeformed (black) [',LengthMagnitude,']- SF : ',num2str(ScaleFactor(7)),'  - Load Step:',num2str(i),'/',num2str(LoadControl(2)),''])
      else
        title(['Deformada - GD (Azul) VS Indeformada (Negro) [',LengthMagnitude,']- SF : ',num2str(ScaleFactor(7)),'  - Estado de Carga:',num2str(i),'/',num2str(LoadControl(2)),''])
      end
      %
      axis ( deformedcuadro_fin ,'equal')
      xlabel(['x [',LengthMagnitude,']'])
      ylabel(['y [',LengthMagnitude,']'])
      zlabel(['z [',LengthMagnitude,']'])
      % Undeformed
			if Dimensions == 3
				for j = 1: NElem
					plot3( XElemMat(j,:) , YElemMat(j,:) , ZElemMat(j,:) ,'k:', 'linewidth', area_factor(j)/2 )
				end
      else
				for j = 1: NElem
					plot( XElemMat(j,:) , YElemMat(j,:) ,'k:', 'linewidth', area_factor(j)/2 )
				end
			end
			if PlotView(2) == 1
        % Node's numbers
				if Dimensions == 3
					for nodo = 1 : NNod
						text( DEF_NodCoordMat_fin ( nodo , aux1_fin(1) )+offset1, DEF_NodCoordMat_fin ( nodo , aux1_fin(2) )+offset1, DEF_NodCoordMat_fin ( nodo , aux1_fin(3) )+offset1, num2str ( nodo ),'Color',[0.02,0.3,0.07] );
					end
				else
					for nodo = 1 : NNod
						text( DEF_NodCoordMat_fin ( nodo , aux1_fin(1) )+offset1, DEF_NodCoordMat_fin ( nodo , aux1_fin(2) )+offset1, num2str ( nodo ),'Color',[0.02,0.3,0.07] );
					end
				end
			end
      aux1_fin = aux1_fin + 3;
			if Dimensions == 3
				for j = 1: NElem				
					plot3( DEF_XElemMat_fin(j,aux2_fin) , DEF_YElemMat_fin(j,aux2_fin) , DEF_ZElemMat_fin(j,aux2_fin),'b-','linewidth',area_factor(j),'markersize',ScaleFactor(3)/20)
				end
			else
				for j = 1: NElem				
					plot( DEF_XElemMat_fin(j,aux2_fin) , DEF_YElemMat_fin(j,aux2_fin) , 'b-','linewidth',area_factor(j),'markersize',ScaleFactor(3)/20)
				end
			end
			aux2_fin = aux2_fin + 2;
      %
    deformed_fin_plot_time = deformed_fin_plot_time + toc;
      if Print(4) == 1
        tic
        a=0;
        if Dimensions ~= 3
          print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' def '/' name '_' def '_' num2str(i) '.png' ] ,'-dpng')
        else 
          if TresD_View(1) == 1
            view(0,90) % XY
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XY/' def '/' name '_' def '_XY_' num2str(i) '.png' ] ,'-dpng')
            pause(0.1);
          end
          if TresD_View(2) == 1
            view(0,0) % XZ
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XZ/' def '/' name '_' def '_XZ_' num2str(i) '.png' ] ,'-dpng')
            pause(0.1);
          end
          if TresD_View(3) == 1
            view(90,0) % YZ
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/YZ/' def '/' name '_' def '_YZ_' num2str(i) '.png' ] ,'-dpng')
            pause(0.1);
          end
            view(TresD_View(5),TresD_View(6))
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' def '/' name '_' def '_' num2str(i) '.png' ] ,'-dpng')
          a=sum(TresD_View([1:3]))*0.1;
        end
				hold ("off") ;
				pause(0.2);
        if i<LoadControl(2)
					close (figure(4))
				end
        deformed_fin_print_time = deformed_fin_print_time + toc - 0.2 - a;
			end
      %
		end
		%
	end
  deformed_fin_time = deformed_fin_plot_time+deformed_fin_print_time;
  deformed_time     = deformed_lin_time + deformed_fin_time;
	% ==========================================================================
  
	% =========================================================================
	% ============ AXIAL FORCE =====================================
  axial_lin_plot_time = 0;
  axial_lin_print_time = 0;
	% Ploteo lineal
	if Plots(3) == 1 
		
    if Lenguage == 1
      fprintf(' - Axial Force plot for small deformations.\n')
    else
      fprintf(' - Grafico de Fuerza Axial para pequenas deformaciones.\n')
    end
		%
    if Print(3) == 1
      if Dimensions ~= 3
        if Lenguage == 1
          fprintf(' - Axial Force 2D Print for small deformations for %i steps.\n', HowManySD(2))
        else
          fprintf(' - Impresion de Fuerza Axial 2D para pequenas deformaciones para %i pasos.\n', HowManySD(2))
        end
      else
        if Lenguage == 1
          fprintf(' - Axial Force 3D Print for small deformations for %i steps.\n', HowManySD(2))
        else
          fprintf(' - Impresion de Fuerza Axial 3D para pequenas deformaciones para %i pasos.\n', HowManySD(2))
        end
		  end
    end
    %
    Disp_N_lineal = N_lineal;
    N_lineal_aux = Disp_N_lineal/HowManySD(2);
    %
    for i = 1 : HowManySD(2)
      %
      Disp_N_lineal = i*N_lineal_aux;
      tic
      figure(3)
      hold ("on") ;
      grid on
      if Lenguage == 1
        title(['Axial Force - SD [',ForceMagnitude,'] (red: negative; green: positive; blue: zero) - Image:',num2str(i),'/',num2str(HowManySD(2)),''])
      else
        title(['Fuerza Axial - PD [',ForceMagnitude,'] (rojo: negativa; verde: positiva; azul: cero) - Imagen:',num2str(i),'/',num2str(HowManySD(2)),''])
      end
      %
      axis ( cuadro ,'equal')
      xlabel(['x [',LengthMagnitude,']'])
      ylabel(['y [',LengthMagnitude,']'])
      zlabel(['z [',LengthMagnitude,']'])
      for elem = 1: NElem
        pos = [(XElemMat( elem , 2 ) + XElemMat( elem , 1 ))*0.5 , (YElemMat( elem , 2 ) + YElemMat( elem , 1 ))*0.5, (ZElemMat( elem , 2 ) + ZElemMat( elem , 1 ))*0.5] ;
        if Disp_N_lineal(elem)<-0.00000001,
          if Dimensions == 3;
            plot3( XElemMat(elem,:) , YElemMat(elem,:) , ZElemMat(elem,:) ,'r','linewidth',area_factor(elem) )
            if PlotView(3) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( elem ),'Color', 'r' )
            elseif PlotView(5) == 1
              Disp_N_lineal(elem) = floor(Disp_N_lineal(elem)*100)/100;
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( Disp_N_lineal(elem) ),'Color', 'r' )
            end
          else
            plot( XElemMat(elem,:) , YElemMat(elem,:) ,'r','linewidth',area_factor(elem) )
            if PlotView(3) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1 , num2str ( elem ),'Color', 'r' )
            elseif PlotView(5) == 1
              Disp_N_lineal(elem) = floor(Disp_N_lineal(elem)*100)/100;
              text( pos(1)+offset1,  pos(2)+offset1, num2str ( Disp_N_lineal(elem) ),'Color', 'r' )
            end
          end
        elseif Disp_N_lineal(elem)>0.00000001,
          if Dimensions == 3;
            plot3( XElemMat(elem,:) , YElemMat(elem,:) , ZElemMat(elem,:) ,'g','linewidth',area_factor(elem) )
            if PlotView(3) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( elem ),'Color', 'g' )
            elseif PlotView(5) == 1
              Disp_N_lineal(elem) = ceil(Disp_N_lineal(elem)*100)/100;
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( Disp_N_lineal(elem) ),'Color', 'g' )
            end
          else
            plot( XElemMat(elem,:) , YElemMat(elem,:) ,'g','linewidth',area_factor(elem) )
            if PlotView(3) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1 , num2str ( elem ),'Color', 'g' )
            elseif PlotView(5) == 1
              Disp_N_lineal(elem) = ceil(Disp_N_lineal(elem)*100)/100;
              text( pos(1)+offset1,  pos(2)+offset1, num2str ( Disp_N_lineal(elem) ),'Color', 'g' )
            end
          end
        elseif abs(Disp_N_lineal(elem))<0.00000001
          if Dimensions == 3;
            plot3( XElemMat(elem,:) , YElemMat(elem,:) , ZElemMat(elem,:) ,'b','linewidth',area_factor(elem) )
            if PlotView(3) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( elem ),'Color', 'b' )
            elseif PlotView(5) == 1
              Disp_N_lineal(elem) = 0;
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( Disp_N_lineal(elem) ),'Color', 'b' )
            end
          else
            plot( XElemMat(elem,:) , YElemMat(elem,:) ,'b','linewidth',area_factor(elem) )
            if PlotView(3) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1 , num2str ( elem ),'Color', 'b' )
            elseif PlotView(5) == 1
              Disp_N_lineal(elem) = 0;
              text( pos(1)+offset1,  pos(2)+offset1, num2str ( Disp_N_lineal(elem) ),'Color', 'b' )
            end
          end
        end
      end
      %
      axial_lin_plot_time = axial_lin_plot_time +toc;
      if Print(3) == 1
        tic
        a=0;
        if Dimensions ~= 3
          if SD_LD == 1
						print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' axial '/' name '_' axial '_' num2str(i) '.png' ] ,'-dpng')
					else
						print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' axial '/' name '_' axial '_' num2str(i) '.png' ] ,'-dpng')
					end
        else 
          if SD_LD == 1
						if TresD_View(1) == 1
							view(0,90) % XY
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XY/' axial '/' name '_' axial '_XY_' num2str(i) '.png' ] ,'-dpng')
						pause(0.1)
						end
						if TresD_View(2) == 1
							view(0,0) % XZ
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/XZ/' axial '/' name '_' axial '_XZ_' num2str(i) '.png' ] ,'-dpng')
						pause(0.1)
						end
						if TresD_View(3) == 1
							view(90,0) % YZ
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/XY_XZ_YZ/YZ/' axial '/' name '_' axial '_YZ_' num2str(i) '.png' ] ,'-dpng')
						pause(0.1)
						end
            view(TresD_View(5),TresD_View(6))
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' axial '/' name '_' axial '_' num2str(i) '.png' ] ,'-dpng')
					else
						if TresD_View(1) == 1
							view(0,90) % XY
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XY/' axial '/' name '_' axial '_XY_' num2str(i) '.png' ] ,'-dpng')
						pause(0.1)
						end
						if TresD_View(2) == 1
							view(0,0) % XZ
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/XZ/' axial '/' name '_' axial '_XZ_' num2str(i) '.png' ] ,'-dpng')
						pause(0.1)
						end
						if TresD_View(3) == 1
							view(90,0) % YZ
							print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/XY_XZ_YZ/YZ/' axial '/' name '_' axial '_YZ_' num2str(i) '.png' ] ,'-dpng')
						pause(0.1)
						end
            view(TresD_View(5),TresD_View(6))
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas2 '/' axial '/' name '_' axial '_' num2str(i) '.png' ] ,'-dpng')
					end
				a=sum(TresD_View([1:3]))*0.1;	
				end
        hold ("off") ;
        pause(0.2);
        if i<HowManySD(2)
          close (figure(3))
        end
        axial_lin_print_time = axial_lin_print_time + toc - 0.2-a;
      end
    end
		%
	end
  axial_lin_time = axial_lin_plot_time + axial_lin_print_time;
  %
  axial_fin_plot_time = 0;
  axial_fin_print_time = 0;
	% Ploteo no lineal
	if Plots(5) == 1 && SD_LD ~= 1
		axial_deformedcuadro_fin = [min(min(NodCoordMat(:,1),min(min(AxialDEF_NodCoordMat_fin(:,[1:3:end])))))-min([offsetx,offsety,offsetz,axial_deformed_offsetx_fin,axial_deformed_offsety_fin,axial_deformed_offsetz_fin]),
							  max(max(NodCoordMat(:,1),max(max(AxialDEF_NodCoordMat_fin(:,[1:3:end])))))+min([offsetx,offsety,offsetz,axial_deformed_offsetx_fin,axial_deformed_offsety_fin,axial_deformed_offsetz_fin]),
							  min(min(NodCoordMat(:,2),min(min(AxialDEF_NodCoordMat_fin(:,[2:3:end])))))-min([offsetx,offsety,offsetz,axial_deformed_offsetx_fin,axial_deformed_offsety_fin,axial_deformed_offsetz_fin]),
							  max(max(NodCoordMat(:,2),max(max(AxialDEF_NodCoordMat_fin(:,[2:3:end])))))+min([offsetx,offsety,offsetz,axial_deformed_offsetx_fin,axial_deformed_offsety_fin,axial_deformed_offsetz_fin]),
							  min(min(NodCoordMat(:,3),min(min(AxialDEF_NodCoordMat_fin(:,[3:3:end])))))-min([offsetx,offsety,offsetz,axial_deformed_offsetx_fin,axial_deformed_offsety_fin,axial_deformed_offsetz_fin]),
							  max(max(NodCoordMat(:,3),max(max(AxialDEF_NodCoordMat_fin(:,[3:3:end])))))+min([offsetx,offsety,offsetz,axial_deformed_offsetx_fin,axial_deformed_offsety_fin,axial_deformed_offsetz_fin])];
		
    
    if Lenguage == 1
      fprintf(' - Axial Force Plot for large deformation.\n')
    else
      fprintf(' - Grafico de Fuerza Axial para grandes deformaciones.\n')
    end
		%
    if Print(5) == 1
      if Lenguage == 1
				if plot_pasos == LoadControl(2)
					g = 'the last load step';
				else
					g = 'all load steps';
				end
				fprintf(' - Axial Force %sD Print for large deformations for %s (%i).\n',Dim, g, LoadControl(2))
			else
				if plot_pasos == LoadControl(2)
					g = 'el ultimo estado de carga';
				else
					g = 'todos los estados de carga';
				end
				fprintf(' - Impresion de Fuerza Axial %sD para grandes deformaciones para %s (%i).\n',Dim, g, LoadControl(2))
			end
    end
    
    Disp_N_finita = N_finita;
		aux1_fin = [1,2,3];
		aux2_fin = [1,2];
    for paso = plot_pasos : LoadControl(2)
      %
      tic
      figure(5)
      hold ("on") ;
      grid on
      if Lenguage == 1
        title(['Axial Force - LD [',ForceMagnitude,'] (red: negative; green: positive; blue: zero) - Load Step:',num2str(paso),'/',num2str(LoadControl(2)),''])
      else
        title(['Fuerza Axial - GD [',ForceMagnitude,'] (rojo: negativa; verde: positiva; azul: cero) - Load Step:',num2str(paso),'/',num2str(LoadControl(2)),''])
      end
      %
      axis ( axial_deformedcuadro_fin ,'equal')
      xlabel(['x [',LengthMagnitude,']'])
      ylabel(['y [',LengthMagnitude,']'])
      zlabel(['z [',LengthMagnitude,']'])
      for i = 1: NElem
        pos = [(AxialDEF_XElemMat_fin(i,aux2_fin)(2) + AxialDEF_XElemMat_fin(i,aux2_fin)(1))*0.5 , (AxialDEF_YElemMat_fin(i,aux2_fin)(2) + DEF_YElemMat_fin(i,aux2_fin)(1))*0.5, (DEF_ZElemMat_fin(i,aux2_fin)(2) + DEF_ZElemMat_fin(i,aux2_fin)(1))*0.5] ;
        if Disp_N_finita(i,paso)<-0.00000001,
          if Dimensions == 3
            plot3( AxialDEF_XElemMat_fin(i,aux2_fin) , AxialDEF_YElemMat_fin(i,aux2_fin) , AxialDEF_ZElemMat_fin(i,aux2_fin) ,'r','linewidth',area_factor(i) )
            if PlotView(2) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( i ),'Color', 'r' )
            elseif PlotView(5) == 1
              Disp_N_finita(i,paso) = floor(Disp_N_finita(i,paso)*100)/100;
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( Disp_N_finita(i,paso) ),'Color', 'r' )
            end
          else
            plot( AxialDEF_XElemMat_fin(i,aux2_fin) , AxialDEF_YElemMat_fin(i,aux2_fin),'r','linewidth',area_factor(i) )
            if PlotView(2) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1, num2str ( i ),'Color', 'r' )
            elseif PlotView(5) == 1
              Disp_N_finita(i,paso) = floor(Disp_N_finita(i,paso)*100)/100;
              text( pos(1)+offset1,  pos(2)+offset1 , num2str ( Disp_N_finita(i,paso) ),'Color', 'r' )
            end
          end
        elseif Disp_N_finita(i,paso)>0.00000001,
          if Dimensions == 3
            plot3( AxialDEF_XElemMat_fin(i,aux2_fin) , AxialDEF_YElemMat_fin(i,aux2_fin) , AxialDEF_ZElemMat_fin(i,aux2_fin) ,'g','linewidth',area_factor(i) )
            if PlotView(2) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( i ),'Color', 'g' )
            elseif PlotView(5) == 1
              Disp_N_finita(i,paso) = ceil(Disp_N_finita(i,paso)*100)/100;
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( Disp_N_finita(i,paso) ),'Color', 'g' )
            end
          else
            plot( AxialDEF_XElemMat_fin(i,aux2_fin) , AxialDEF_YElemMat_fin(i,aux2_fin),'g','linewidth',area_factor(i) )
            if PlotView(2) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1, num2str ( i ),'Color', 'g' )
            elseif PlotView(5) == 1
              Disp_N_finita(i,paso) = ceil(Disp_N_finita(i,paso)*100)/100;
              text( pos(1)+offset1,  pos(2)+offset1 , num2str ( Disp_N_finita(i,paso) ),'Color', 'g' )
            end
          end
        elseif abs(Disp_N_finita(i,paso))<0.00000001
          if Dimensions == 3
            plot3( AxialDEF_XElemMat_fin(i,aux2_fin) , AxialDEF_YElemMat_fin(i,aux2_fin), AxialDEF_ZElemMat_fin(i,aux2_fin) ,'b','linewidth',area_factor(i) )
            if PlotView(2) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( i ),'Color', 'b' )
            elseif PlotView(5) == 1
              Disp_N_finita(i,paso) = 0;
              text( pos(1)+offset1,  pos(2)+offset1,  pos(3)+offset1 , num2str ( Disp_N_finita(i,paso) ),'Color', 'b' )
            end
          else
            plot( AxialDEF_XElemMat_fin(i,aux2_fin) , AxialDEF_YElemMat_fin(i,aux2_fin),'b','linewidth',area_factor(i) )
            if PlotView(2) == 1 && PlotView(5) == 0
              text( pos(1)+offset1,  pos(2)+offset1, num2str ( i ),'Color', 'b' )
            elseif PlotView(5) == 1
              Disp_N_finita(i,paso) = 0;
              text( pos(1)+offset1,  pos(2)+offset1 , num2str ( Disp_N_finita(i,paso) ),'Color', 'b' )
            end
          end
        end
      end
      aux2_fin = aux2_fin + 2;
      %
      axial_fin_plot_time = axial_fin_plot_time +toc;
      if Print(5) == 1
        tic
        a=0;
        if Dimensions ~= 3
          print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' axial '/' name '_' axial '_' num2str(paso) '.png' ] ,'-dpng')
        else 
          if TresD_View(1) == 1
            view(0,90) % XY
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XY/' axial '/' name '_' axial '_XY_' num2str(paso) '.png' ] ,'-dpng')
          pause(0.1)
          end
          if TresD_View(2) == 1
            view(0,0) % XZ
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/XZ/' axial '/' name '_' axial '_XZ_' num2str(paso) '.png' ] ,'-dpng')
          pause(0.1)
          end
          if TresD_View(3) == 1
            view(90,0) % YZ
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/XY_XZ_YZ/YZ/' axial '/' name '_' axial '_YZ_' num2str(paso) '.png' ] ,'-dpng')
			pause(0.1)
          end
            view(TresD_View(5),TresD_View(6))
            print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' axial '/' name '_' axial '_' num2str(paso) '.png' ] ,'-dpng')
        a=sum(TresD_View([1:3]))*0.1;
        end
        hold ("off") ;
        pause(0.2);
        if paso<LoadControl(2)
          close (figure(5))
        end
        axial_fin_print_time = axial_fin_print_time + toc - 0.2 - a;
      end
    end
		%
	end
  axial_fin_time = axial_fin_plot_time + axial_fin_print_time;
  axial_time     = axial_lin_time + axial_fin_time;
  
  conv_fin_plot_time = 0;
	conv_fin_print_time = 0;
  if SD_LD ~= 1
		
		if Plots(6) == 1
			tic
			if Lenguage == 1
				fprintf(' - Convergence plot.\n')
			else
				fprintf(' - Grafico de convergencia.\n')
			end
			figure(6)
			if Lenguage == 1
				title(['Convergence'])
				xlabel(['Iterations'])
				 ylabel(['Gradient norm [',ForceMagnitude,']'])
			else
				title(['Convergencia'])
				xlabel(['Iteraciones'])
				ylabel(['Norma gradiente [',ForceMagnitude,']'])
			end
			aaaa = 0;
			for j = 1:LoadControl(2)
				hold on
				a = MNorma([1:iteraciones(j)+1],j);
				b = [1:iteraciones(j)+1]+aaaa-1;
				aaaa = aaaa+iteraciones(j);
				Color = [mod(j,2),0,mod(j+1,2)];
				semilogy(b,a,'Color',Color,b(1),a(1),'k*')
			end
			conv_fin_plot_time = toc;
			if Print(6) == 1
				tic
				if Lenguage == 1
					fprintf(' - Convergence print.\n')
				else
					fprintf(' - Impresion del grafico de convergencia.\n')
				end
				print( [ '../../output/' Dim 'D/' KP '_' Dim 'D_' var1 '/' name '/' elas '/' conv '/' name '_' conv '.png' ] ,'-dpng')
				conv_fin_print_time = toc;
			end
		end
  end
  conv_fin_time = conv_fin_plot_time + conv_fin_print_time;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  posprocess_time = parameters_time + undeformed_time + deformed_time + axial_time + conv_fin_time;
  
  if Lenguage == 1
    fprintf(' - After %6.3f seconds, IETFEM complete PosProcess module.\n\n',posprocess_time)
  else
    fprintf(' - Luego de %6.3f segundos, IETFEM competo el modulo "PosProcess".\n\n',posprocess_time)
  end
  
  if Lenguage == 1
    fprintf('Plots and images list made by IETFEM:\n\n')
    fprintf('	---------------------------------------------------------------------------------\n')
    fprintf('	|    Variable   |   Plot  |  Time (s)  | Image  |  Time (s)  |  Total time (s)  |\n')
    fprintf('	---------------------------------------------------------------------------------\n')
    fprintf('	|   Undeformed  |')
    if Print(1) == 1
      fprintf('   Yes   |   %6.3f   |   Yes  |   %6.3f   |      %6.3f      |\n',undeformed_plot_time,undeformed_print_time,undeformed_time)
    elseif Plots(1) == 1
      fprintf('   Yes   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',undeformed_plot_time,undeformed_print_time,undeformed_time)
    else
      fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',undeformed_plot_time,undeformed_print_time,undeformed_time)
    end
    fprintf('	| SD Deformed   |')
    if Print(2)==1
      fprintf('   Yes   |   %6.3f   |   Yes  |   %6.3f   |      %6.3f      |\n',deformed_lin_plot_time,deformed_lin_print_time,deformed_lin_time)
    elseif Plots(2)==1
      fprintf('   Yes   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',deformed_lin_plot_time,deformed_lin_print_time,deformed_lin_time)
    else
      fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',deformed_lin_plot_time,deformed_lin_print_time,deformed_lin_time)
    end
    fprintf('	| SD Axial Force|')
    if Print(3)==1
      fprintf('   Yes   |   %6.3f   |   Yes  |   %6.3f   |      %6.3f      |\n',axial_lin_plot_time,axial_lin_print_time,axial_lin_time)
    elseif Plots(3)==1
      fprintf('   Yes   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',axial_lin_plot_time,axial_lin_print_time,axial_lin_time)
    else
      fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',axial_lin_plot_time,axial_lin_print_time,axial_lin_time)
    end
    if SD_LD ~= 1
      fprintf('	| LD Deformed   |')
      if Print(4)==1
        fprintf('   Yes   |   %6.3f   |   Yes  |   %6.3f   |      %6.3f      |\n',deformed_fin_plot_time,deformed_fin_print_time,deformed_fin_time)
      elseif Plots(4)==1
        fprintf('   Yes   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',deformed_fin_plot_time,deformed_fin_print_time,deformed_fin_time)
      else
        fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',deformed_fin_plot_time,deformed_fin_print_time,deformed_fin_time)
      end
      fprintf('	| LD Axial Force|')
      if Print(5)==1
        fprintf('   Yes   |   %6.3f   |   Yes  |   %6.3f   |      %6.3f      |\n',axial_fin_plot_time,axial_fin_print_time,axial_fin_time)
      elseif Plots(5)==1
        fprintf('   Yes   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',axial_fin_plot_time,axial_fin_print_time,axial_fin_time)
      else
        fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',axial_fin_plot_time,axial_fin_print_time,axial_fin_time)
      end
			fprintf('	|  Convergence  |')
      if Print(6)==1
        fprintf('   Yes   |   %6.3f   |   Yes  |   %6.3f   |      %6.3f      |\n',conv_fin_plot_time,conv_fin_print_time,conv_fin_time)
      elseif Plots(6)==1
        fprintf('   Yes   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',conv_fin_plot_time,conv_fin_print_time,conv_fin_time)
      else
        fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',conv_fin_plot_time,conv_fin_print_time,conv_fin_time)
      end
    end
    fprintf('	---------------------------------------------------------------------------------\n')
    fprintf('	|        Plots time       |     Images time     |           Total time          |\n')
    fprintf('	|                         |                     |                               |\n')
    graphics_time = undeformed_plot_time + deformed_lin_plot_time + axial_lin_plot_time + deformed_fin_plot_time + axial_fin_plot_time+conv_fin_plot_time;
    images_time   = undeformed_print_time + deformed_lin_print_time + axial_lin_print_time + deformed_fin_print_time + axial_fin_print_time+conv_fin_print_time;
    fprintf('	|     %6.3f  segundos    |  %6.3f  segundos   |         %6.3f  segundos      |\n',graphics_time,images_time,posprocess_time)
    fprintf('	|                         |                     |                               |\n')
    fprintf('	---------------------------------------------------------------------------------\n')
  else
    fprintf('Lista de graficos e imagenes a realizar segun variable:\n\n')
    fprintf('	---------------------------------------------------------------------------------\n')
    fprintf('	|    Variable   | Grafico | Tiempo (s) | Imagen | Tiempo (s) | Tiempo total (s) |\n')
    fprintf('	---------------------------------------------------------------------------------\n')
    fprintf('	|  Indeformada  |')
    if Print(1) == 1
      fprintf('    Si   |   %6.3f   |   Si   |   %6.3f   |      %6.3f      |\n',undeformed_plot_time,undeformed_print_time,undeformed_time)
    elseif Plots(1) == 1
      fprintf('    Si   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',undeformed_plot_time,undeformed_print_time,undeformed_time)
    else
      fprintf('    No   |   %6.3f   |   Si   |   %6.3f   |      %6.3f      |\n',undeformed_plot_time,undeformed_print_time,undeformed_time)
    end
    fprintf('	|PD Deformada   |')
    if Print(2)==1
      fprintf('    Si   |   %6.3f   |   Si   |   %6.3f   |      %6.3f      |\n',deformed_lin_plot_time,deformed_lin_print_time,deformed_lin_time)
    elseif Plots(2)==1
      fprintf('    Si   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',deformed_lin_plot_time,deformed_lin_print_time,deformed_lin_time)
    else
      fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',deformed_lin_plot_time,deformed_lin_print_time,deformed_lin_time)
    end
    fprintf('	|PD Fuerza Axial|')
    if Print(3)==1
      fprintf('    Si   |   %6.3f   |   Si   |   %6.3f   |      %6.3f      |\n',axial_lin_plot_time,axial_lin_print_time,axial_lin_time)
    elseif Plots(3)==1
      fprintf('    Si   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',axial_lin_plot_time,axial_lin_print_time,axial_lin_time)
    else
      fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',axial_lin_plot_time,axial_lin_print_time,axial_lin_time)
    end
    if SD_LD ~= 1
      fprintf('	|GD Deformada   |')
      if Print(4)==1
        fprintf('    Si   |   %6.3f   |   Si   |   %6.3f   |      %6.3f      |\n',deformed_fin_plot_time,deformed_fin_print_time,deformed_fin_time)
      elseif Plots(4)==1
        fprintf('    Si   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',deformed_fin_plot_time,deformed_fin_print_time,deformed_fin_time)
      else
        fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',deformed_fin_plot_time,deformed_fin_print_time,deformed_fin_time)
      end
      fprintf('	|GD Fuerza Axial|')
      if Print(5)==1
        fprintf('    Si   |   %6.3f   |   Si   |   %6.3f   |      %6.3f      |\n',axial_fin_plot_time,axial_fin_print_time,axial_fin_time)
      elseif Plots(5)==1
        fprintf('    Si   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',axial_fin_plot_time,axial_fin_print_time,axial_fin_time)
      else
        fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',axial_fin_plot_time,axial_fin_print_time,axial_fin_time)
      end
			fprintf('	|  Convergencia |')
      if Print(6)==1
        fprintf('    Si   |   %6.3f   |   Si   |   %6.3f   |      %6.3f      |\n',conv_fin_plot_time,conv_fin_print_time,conv_fin_time)
      elseif Plots(6)==1
        fprintf('    Si   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',conv_fin_plot_time,conv_fin_print_time,conv_fin_time)
      else
        fprintf('    No   |   %6.3f   |   No   |   %6.3f   |      %6.3f      |\n',conv_fin_plot_time,conv_fin_print_time,conv_fin_time)
      end
    end
    fprintf('	---------------------------------------------------------------------------------\n')
    fprintf('	|   Tiempo para graficos  | Tiempo para imagenes|     Tiempo total empleado     |\n')
    fprintf('	|                         |                     |                               |\n')
    graphics_time = undeformed_plot_time + deformed_lin_plot_time + axial_lin_plot_time + deformed_fin_plot_time + axial_fin_plot_time+conv_fin_plot_time;
    images_time   = undeformed_print_time + deformed_lin_print_time + axial_lin_print_time + deformed_fin_print_time + axial_fin_print_time+conv_fin_print_time;
    posprocess_time = graphics_time + images_time;
    fprintf('	|     %6.3f  segundos    |  %6.3f  segundos   |         %6.3f  segundos      |\n',graphics_time,images_time,posprocess_time)
    fprintf('	|                         |                     |                               |\n')
    fprintf('	---------------------------------------------------------------------------------\n')
  end
  %
end

