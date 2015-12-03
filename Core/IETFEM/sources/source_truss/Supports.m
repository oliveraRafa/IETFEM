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

function [ H1 , H2 , H3, color] = Supports( Parameter , pos , offset, ProbType)

color    = [1,0,0];
%if ProbType == 2 || ProbType == 3
	% página con colores: http://cloford.com/resources/colours/500col.htm
	if Parameter == 1
		[ x, y ] = Polygs ( [0,0] , offset , 3 , 0 ) ;
		z        = zeros(1,4);
		H1 = x' + pos(1) - offset; H2 = y' + pos(2); H3 = z' + pos(3);
	elseif Parameter == 2
		[ x, y ] = Polygs ( [0,0] , offset , 3 , -3*pi/2 ) ;
		z        = zeros(1,4);
		%r = 0; g = 191; b = 255;
		H1 = x' + pos(1); H2 = y' + pos(2) - offset; H3 = z' + pos(3);
	elseif Parameter == 3
		[ x, z ] = Polygs ( [0,0] , offset , 3 , -3*pi/2 ) ;
		y        = zeros(1,4);
		%r = 238; g = 121; b = 66;
		H1 = x' + pos(1); H2 = y' + pos(2); H3 = z' + pos(3) - offset;
	% en lo que sigue van los resortes
	elseif Parameter == 4
		x = [0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
    y = [0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
		z = zeros(1,30);
		H1 = x' + pos(1); H2 = y' + pos(2); H3 = z' + pos(3);
	elseif Parameter == 5
		x = [0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
    y = 1*[0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
		z = zeros(1,30);
		H1 = x' + pos(1); H2 = y' + pos(2); H3 = z' + pos(3);
	elseif Parameter == 6
		x = [0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
    z = 1*[0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
		y = zeros(1,30);
		H1 = x' + pos(1); H2 = y' + pos(2); H3 = z' + pos(3);
	end
	%
%elseif Probtype == 1

%end

% if size(pos,2)==1,
  % pos(:,2)=0 ;
% end

 
% HX = [];
% HY = [];

% tam=size(CondMat);

% if type==1
% for i=1:tam(1)
	% %
	% Hx = [];
	% Hy = [];
	% %
      % if CondMat(i,2)==0 && CondMat(i,3)==0
       	% if lado==1
            	% %
            	% [ X , Y ] = Polygs( [0,0] , offset , 3 , pi/2) ;
			% Xsuelo(1:2:15)=linspace(-offset*cos(pi/6),+offset*cos(pi/6),8);
			% Xsuelo(2:2:14)=linspace(-offset*cos(pi/6)*7/8,+offset*cos(pi/6),7);
			% Xsuelo(16)=+offset*cos(pi/6);
			% Ysuelo(1:2:15)=-offset-offset*sin(pi/6);
			% Ysuelo(2:2:16)=-offset-offset*sin(pi/6)-offset*cos(pi/6)/4;
            	% Hx = [ Hx ,  X'        ;Xsuelo'  ]; 
            	% Hy = [ Hy , (Y-offset)';Ysuelo'  ];
            	% %
		% elseif lado==2 
            	% %
			% Ysuelo(1:2:15)=linspace(-offset*cos(pi/6),+offset*cos(pi/6),8);
			% Ysuelo(2:2:14)=linspace(-offset*cos(pi/6)*7/8,+offset*cos(pi/6),7);
			% Ysuelo(16)=+offset*cos(pi/6);
			% Xsuelo(1:2:15)=+offset+offset*sin(pi/6);
			% Xsuelo(2:2:16)=+offset+offset*sin(pi/6)+offset*cos(pi/6)/4;
            	% [ X , Y ] = Polygs( [0,0] , offset , 3 , pi) ;
            	% Hx = [ Hx ,  (X+offset)'  ; Xsuelo']; 
            	% Hy = [ Hy ,   Y'          ; Ysuelo'];
            	% %
		% elseif lado==3
            	% %
			% Xsuelo(1:2:15)=linspace(-offset*cos(pi/6),+offset*cos(pi/6),8);
			% Xsuelo(2:2:14)=linspace(-offset*cos(pi/6)*7/8,+offset*cos(pi/6),7);
			% Xsuelo(16)=+offset*cos(pi/6);
			% Ysuelo(1:2:15)=+offset+offset*sin(pi/6);
			% Ysuelo(2:2:16)=+offset+offset*sin(pi/6)+offset*cos(pi/6)/4;
            	% [ X , Y ] = Polygs( [0,0] , offset , 3 , 3*pi/2) ;
            	% Hx = [ Hx ,   X'          ;Xsuelo'  ]; 
           		% Hy = [ Hy ,  (Y+offset)'  ;Ysuelo'  ];
        	% else
            	% %
            	% [ X , Y ] = Polygs( [0,0] , offset , 3 , 0) ;
			% Ysuelo(1:2:15)=linspace(-offset*cos(pi/6),+offset*cos(pi/6),8);
			% Ysuelo(2:2:14)=linspace(-offset*cos(pi/6)*7/8,+offset*cos(pi/6),7);
			% Ysuelo(16)=+offset*cos(pi/6);
			% Xsuelo(1:2:15)=-offset-offset*sin(pi/6);
			% Xsuelo(2:2:16)=-offset-offset*sin(pi/6)-offset*cos(pi/6)/4;
            	% Hx = [ Hx ,  (X-offset)'; Xsuelo'    ]; 
            	% Hy = [ Hy ,   Y'        ; Ysuelo'    ];
		% end
	% end
	% %
	% if CondMat(i,2)~=0 && CondMat(i,3)==0
	  	% %
        	% if lado==1
            	% %
            	% [ X , Y ] = Polygs( [0,0] , offset , 3 , pi/2) ;
            	% Hx = [ Hx ,  X'         ;linspace( + offset , - offset ,21)']; 
            	% Hy = [ Hy , (Y-offset)' ; -ones(21,1)*offset*1.8];
            	% %
        	% elseif lado==3
            	% %
            	% [ X , Y ] = Polygs( [0,0] , offset , 3 , 3*pi/2) ;
            	% Hx = [ Hx ,  X'         ;linspace( + offset , - offset ,21)']; 
            	% Hy = [ Hy , (Y+offset)' ; +ones(21,1)*offset*1.8];
			% %
		% else
            	% %
            	% [ X , Y ] = Polygs( [0,0] , offset , 3 , pi/2) ;
            	% Hx = [ Hx ,  X'         ;linspace( + offset , - offset ,21)']; 
            	% Hy = [ Hy , (Y-offset)' ; -ones(21,1)*offset*1.8];
            	% %
        	% end
	% end
	% %
	% if CondMat(i,2)==0 && CondMat(i,3)~=0
	  	% %
        	% if lado==2
            	% %
            	% [ X , Y ] = Polygs( [0,0] , offset , 3 , pi) ;
            	% Hx = [ Hx , (X+offset)' ; ones(21,1)*offset*1.8               ] ; 
            	% Hy = [ Hy , Y'          ; linspace( + offset , - offset ,21)' ] ;
            	% %
       	 % elseif lado==4
            	% %
            	% [ X , Y ] = Polygs( [0,0] , offset , 3 , 0) ;
            	% Hx = [ Hx , (X-offset)' ; -ones(21,1)*offset*1.8               ] ; 
            	% Hy = [ Hy , Y'          ; linspace( + offset , - offset ,21)' ] ;
            	% %
		% else
			% %
            	% [ X , Y ] = Polygs( [0,0] , offset , 3 , pi) ;
            	% Hx = [ Hx , (X+offset)' ; ones(21,1)*offset*1.8               ] ; 
            	% Hy = [ Hy , Y'          ; linspace( + offset , - offset ,21)' ] ;
            	% %
        	% end
	% end
	% %
% end
% end
% if type==2
% for i=1:tam(1)
    	% if CondMat(i,2)~=0 && CondMat(i,3)~=0
		% if lado==1
	 		% %
      		% Hx = [linspace( + offset/2 , - offset/2 ,21),0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
      		% Hy = [-(8/2-1/4)*offset*ones(21,1)',-offset*(8/2-1/4),-offset*(7/2-1/4),-offset*6/2,-offset*5/2,-offset*4/2,-offset*3/2,-offset*2/2,-offset*(1/2+1/4),0,0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
      		% %
		% elseif lado==2
	 		% %
      		% Hx = -1*[linspace( + offset/2 , - offset/2 ,21),0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
      		% Hy = [-(8/2-1/4)*offset*ones(21,1)',-offset*(8/2-1/4),-offset*(7/2-1/4),-offset*6/2,-offset*5/2,-offset*4/2,-offset*3/2,-offset*2/2,-offset*(1/2+1/4),0,0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
      		% %
		% elseif lado==3
	 		% %
      		% Hx = [linspace( + offset/2 , - offset/2 ,21),0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
      		% Hy = -1*[-(8/2-1/4)*offset*ones(21,1)',-offset*(8/2-1/4),-offset*(7/2-1/4),-offset*6/2,-offset*5/2,-offset*4/2,-offset*3/2,-offset*2/2,-offset*(1/2+1/4),0,0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
      		% %
		% else
	 		% %
      		% Hx = [linspace( + offset/2 , - offset/2 ,21),0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
      		% Hy = [-(8/2-1/4)*offset*ones(21,1)',-offset*(8/2-1/4),-offset*(7/2-1/4),-offset*6/2,-offset*5/2,-offset*4/2,-offset*3/2,-offset*2/2,-offset*(1/2+1/4),0,0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
      		% %
		% end
   	 % end
    	% %
    	% if CondMat(i,2)~=0 && CondMat(i,3)==0 
		% if lado==2 
	 		% %
      		% Hx = -1*[0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
      		% Hy = [0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
     			% %
		% else
	 		% %
      		% Hx = [0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
      		% Hy = [0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
     			% %
		% end
    	% end
    	% %	
    	% if CondMat(i,2)==0 && CondMat(i,3)~=0
		% if lado==3
	 		% %
      		% Hx = [0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
      		% Hy = -1*[0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
		% else
	 		% %
      		% Hx = [0,0,offset/2,-offset/2,offset/2,-offset/2,offset/2,0,0,linspace( + offset/2 , - offset/2 ,21)];
      		% Hy = [0,-offset*(1/2+1/4),-offset*2/2,-offset*3/2,-offset*4/2,-offset*5/2,-offset*6/2,-offset*(7/2-1/4),-offset*(8/2-1/4),-(8/2-1/4)*offset*ones(21,1)'];
      		% %
   		% end
	% end
% end	
% end

% HX = [HX , Hx  + pos(i,1) ] ;
% HY = [HY , Hy + pos(i,2) ] ;

% end


























